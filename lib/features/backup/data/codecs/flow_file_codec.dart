import 'dart:convert';

import 'package:flow/core/database/database.dart';
import 'package:flow/features/backup/data/models/flow_backup.dart';

/// Encodes [FlowBackup] to/from the on-disk JSON representation
/// and enforces compatibility rules.
class FlowFileCodec {
  const FlowFileCodec();

  static const JsonEncoder _encoder = JsonEncoder.withIndent('  ');

  /// Serialize a backup to a pretty-printed JSON string.
  String encode(FlowBackup backup) => _encoder.convert(backup.toJson());

  /// Parse a JSON string into a [FlowBackup], validating format and version.
  ///
  /// Throws [BackupFormatException] if the payload is not a flow backup,
  /// or [BackupVersionException] if the backup was produced by a newer
  /// schema than the current app understands.
  FlowBackup decode(String raw) {
    final dynamic parsed;
    try {
      parsed = jsonDecode(raw);
    } on FormatException catch (e) {
      throw BackupFormatException('El archivo no es un JSON válido: ${e.message}');
    }

    if (parsed is! Map) {
      throw const BackupFormatException('Archivo de copia de seguridad inválido.');
    }

    final FlowBackup backup;
    try {
      backup = FlowBackup.fromJson(parsed.map((k, v) => MapEntry(k.toString(), v)));
    } on FormatException catch (e) {
      throw BackupFormatException(
        'Archivo de copia de seguridad corrupto: ${e.message}',
      );
    }

    if (backup.meta.format != BackupMeta.kFormat) {
      throw BackupFormatException(
        'Formato desconocido: ${backup.meta.format}. '
        'Se esperaba ${BackupMeta.kFormat}.',
      );
    }

    if (backup.meta.schemaVersion > AppDatabase.kDatabaseVersion) {
      throw BackupVersionException(
        backupVersion: backup.meta.schemaVersion,
        appVersion: AppDatabase.kDatabaseVersion,
      );
    }

    return backup;
  }
}

/// Raised when a backup file cannot be parsed or doesn't identify itself
/// as a Flow backup.
class BackupFormatException implements Exception {
  const BackupFormatException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Raised when the backup schema version is newer than the app supports.
/// The user should update the app and try again.
class BackupVersionException implements Exception {
  const BackupVersionException({
    required this.backupVersion,
    required this.appVersion,
  });

  final int backupVersion;
  final int appVersion;

  @override
  String toString() =>
      'Esta copia fue creada con una versión más reciente de la app '
      '(esquema v$backupVersion, soportado v$appVersion). '
      'Actualiza la app e inténtalo de nuevo.';
}
