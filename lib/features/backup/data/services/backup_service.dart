import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:flow/core/database/database.dart';
import 'package:flow/core/services/user_profile_service.dart';
import 'package:flow/core/utils/constants.dart';
import 'package:flow/features/backup/data/codecs/flow_file_codec.dart';
import 'package:flow/features/backup/data/models/flow_backup.dart';

/// Extension used for Flow backup files.
const String kFlowBackupExtension = 'flow';

/// Filename used to stash the pre-import snapshot as a safety net.
const String kPreImportSnapshotName = 'last_state_before_import.flow';

/// Thrown when a backup is structurally valid but lacks the profile fields
/// required to skip the onboarding flow (name, publisher type, gender, birth
/// date). Surfaces to the UI so it can ask the user for another file.
class BackupIncompleteProfileException implements Exception {
  const BackupIncompleteProfileException(this.missingKeys);

  final List<String> missingKeys;

  String get message =>
      'La copia de seguridad no contiene todos los datos del perfil.';

  @override
  String toString() => 'BackupIncompleteProfileException: $message '
      '(missing: ${missingKeys.join(', ')})';
}

/// Factory signature returning the sqflite [Database] to operate on.
typedef DatabaseResolver = Future<Database> Function();

/// Orchestrates creating and restoring `.flow` backup files.
///
/// Works directly against the sqflite [Database] using raw column maps
/// so that newer schema versions (which only ADD columns) can still import
/// older backups — missing columns fall back to SQLite column defaults.
class BackupService {
  BackupService({
    required DatabaseResolver resolveDatabase,
    required UserProfileService profileService,
    FlowFileCodec codec = const FlowFileCodec(),
    String appVersion = '1.2.0',
    DateTime Function() clock = _defaultClock,
    Future<Directory> Function()? exportDirProvider,
    Future<Directory> Function()? snapshotDirProvider,
  })  : _resolveDatabase = resolveDatabase,
        _profile = profileService,
        _codec = codec,
        _appVersion = appVersion,
        _clock = clock,
        _exportDirProvider = exportDirProvider ?? getTemporaryDirectory,
        _snapshotDirProvider =
            snapshotDirProvider ?? getApplicationDocumentsDirectory;

  final DatabaseResolver _resolveDatabase;
  final UserProfileService _profile;
  final FlowFileCodec _codec;
  final String _appVersion;
  final DateTime Function() _clock;
  final Future<Directory> Function() _exportDirProvider;
  final Future<Directory> Function() _snapshotDirProvider;

  static DateTime _defaultClock() => DateTime.now();

  // ==================== Public API ====================

  /// Build a [FlowBackup] from the current app state.
  Future<FlowBackup> buildBackup() async {
    final db = await _resolveDatabase();
    final data = BackupData(
      activities: await _dumpTable(db, 'activities'),
      people: await _dumpTable(db, 'people'),
      visits: await _dumpTable(db, 'visits'),
      goals: await _dumpTable(db, 'goals'),
      participations: await _dumpTable(db, 'participations'),
      events: await _dumpTable(db, 'events'),
    );
    return FlowBackup(
      meta: BackupMeta(
        format: BackupMeta.kFormat,
        appVersion: _appVersion,
        schemaVersion: AppDatabase.kDatabaseVersion,
        createdAt: _clock().toUtc().toIso8601String(),
      ),
      preferences: _profile.captureAsMap(),
      data: data,
    );
  }

  /// Export the current app state to a `.flow` file in the system temp
  /// directory. Returns the created file so the caller can hand it off to
  /// share_plus or save dialogs.
  Future<File> exportToTempFile() async {
    if (kIsWeb) {
      throw UnsupportedError('Las copias de seguridad no están disponibles en web.');
    }
    final backup = await buildBackup();
    final content = _codec.encode(backup);
    final dir = await _exportDirProvider();
    final file = File(p.join(dir.path, _defaultFileName()));
    await file.writeAsString(content, flush: true);
    return file;
  }

  /// Read and decode [file] into a [FlowBackup]. Validates the envelope
  /// format and schema version via the codec — throws on mismatch.
  Future<FlowBackup> decodeFile(File file) async {
    if (kIsWeb) {
      throw UnsupportedError('Las copias de seguridad no están disponibles en web.');
    }
    final raw = await file.readAsString();
    return _codec.decode(raw);
  }

  /// Ensure [backup] carries the profile fields needed to land directly on
  /// `/home` after import (i.e. the app won't redirect back to onboarding).
  void validateCompleteProfile(FlowBackup backup) {
    final missing = <String>[];
    for (final key in _requiredProfileKeys) {
      final value = backup.preferences[key];
      final isEmpty = value == null || (value is String && value.isEmpty);
      if (isEmpty) missing.add(key);
    }
    if (missing.isNotEmpty) {
      throw BackupIncompleteProfileException(missing);
    }
  }

  /// Apply [backup] to the app state. Writes a pre-import snapshot, wipes
  /// the DB in a single transaction and repopulates rows preserving IDs,
  /// then restores SharedPreferences.
  Future<void> applyBackup(FlowBackup backup) async {
    if (kIsWeb) {
      throw UnsupportedError('Las copias de seguridad no están disponibles en web.');
    }
    await _writePreImportSnapshot();

    final db = await _resolveDatabase();
    await db.transaction((txn) async {
      for (final table in AppDatabase.kTableNames) {
        await txn.delete(table);
      }
      await _restoreTable(txn, 'activities', backup.data.activities);
      await _restoreTable(txn, 'people', backup.data.people);
      await _restoreTable(txn, 'visits', backup.data.visits);
      await _restoreTable(txn, 'goals', backup.data.goals);
      await _restoreTable(txn, 'participations', backup.data.participations);
      // events references people.id and visits.id, so must come last.
      await _restoreTable(txn, 'events', backup.data.events);
    });

    await _profile.restoreFromMap(backup.preferences);
  }

  /// Replace the entire app state with the contents of [file].
  ///
  /// Convenience wrapper that composes [decodeFile] + [applyBackup]. Used by
  /// the Settings import flow where profile completeness isn't required.
  Future<void> importFromFile(File file) async {
    final backup = await decodeFile(file);
    await applyBackup(backup);
  }

  static const List<String> _requiredProfileKeys = [
    AppConstants.keyUserName,
    AppConstants.keyPublisherType,
    AppConstants.keyGender,
    AppConstants.keyBirthDate,
  ];

  /// Default filename, e.g. `flow_backup_2026-04-18_1730.flow`.
  String _defaultFileName() {
    final now = _clock();
    String two(int v) => v.toString().padLeft(2, '0');
    final stamp =
        '${now.year}-${two(now.month)}-${two(now.day)}_${two(now.hour)}${two(now.minute)}';
    return 'flow_backup_$stamp.$kFlowBackupExtension';
  }

  // ==================== Internals ====================

  Future<List<Map<String, Object?>>> _dumpTable(
    Database db,
    String table,
  ) async {
    final rows = await db.query(table, orderBy: 'id');
    return rows
        .map((r) => Map<String, Object?>.from(r))
        .toList(growable: false);
  }

  Future<void> _restoreTable(
    DatabaseExecutor txn,
    String table,
    List<Map<String, Object?>> rows,
  ) async {
    for (final row in rows) {
      if (row.isEmpty) continue;
      await txn.insert(table, row);
    }
  }

  Future<void> _writePreImportSnapshot() async {
    try {
      final backup = await buildBackup();
      final content = _codec.encode(backup);
      final dir = await _snapshotDirProvider();
      final file = File(p.join(dir.path, kPreImportSnapshotName));
      await file.writeAsString(content, flush: true);
    } catch (_) {
      // Snapshot is best-effort. If it fails (e.g. permissions), we still
      // let the import proceed — the backup file itself is the user's
      // primary safety net.
    }
  }
}
