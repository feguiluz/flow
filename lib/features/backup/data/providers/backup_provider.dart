import 'dart:io';
import 'dart:ui' show Rect;

import 'package:file_picker/file_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';

import 'package:flow/core/database/database.dart';
import 'package:flow/features/backup/data/services/backup_service.dart';
import 'package:flow/features/home/data/providers/activity_notifier.dart';
import 'package:flow/features/home/data/providers/goal_notifier.dart';
import 'package:flow/features/home/data/providers/month_summary_provider.dart';
import 'package:flow/features/home/data/providers/participation_notifier.dart';
import 'package:flow/features/people/data/providers/person_notifier.dart';
import 'package:flow/features/people/data/providers/visit_notifier.dart';
import 'package:flow/features/statistics/data/providers/statistics_provider.dart';
import 'package:flow/shared/providers/theme_provider.dart';
import 'package:flow/shared/providers/user_profile_provider.dart';

part 'backup_provider.g.dart';

/// Provider for the singleton [BackupService].
@riverpod
BackupService backupService(BackupServiceRef ref) {
  return BackupService(
    resolveDatabase: () => AppDatabase.instance.database,
    profileService: ref.watch(userProfileServiceProvider),
  );
}

/// Thrown when the user cancels the file picker — callers treat this
/// as a quiet no-op, not an error.
class BackupPickCancelled implements Exception {
  const BackupPickCancelled();
}

/// Orchestrates export/import flows from the UI. Exposes async methods
/// rather than state because the operations are one-shot and the UI
/// already uses dialogs / banners to communicate progress and outcome.
@riverpod
class BackupNotifier extends _$BackupNotifier {
  @override
  Future<void> build() async {}

  /// Export the current state to a temp `.flow` file and hand it off to
  /// the system share sheet. Returns silently after the sheet closes.
  Future<void> exportAndShare({Rect? sharePositionOrigin}) async {
    final service = ref.read(backupServiceProvider);
    final file = await service.exportToTempFile();
    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'application/json')],
      subject: 'Copia de seguridad Flow',
      sharePositionOrigin: sharePositionOrigin,
    );
  }

  /// Prompt the user to pick a `.flow` file and restore from it.
  ///
  /// Throws:
  ///  - [BackupPickCancelled] if the user closes the picker
  ///  - [BackupFormatException]/[BackupVersionException] if the file is invalid
  ///  - Any IO error if the file cannot be read
  Future<void> importFromPicker() async {
    final file = await _pickBackupFile();
    final service = ref.read(backupServiceProvider);
    await service.importFromFile(file);
    _invalidateAllDataProviders();
  }

  /// Import a backup from the onboarding flow.
  ///
  /// Like [importFromPicker] but additionally verifies the backup carries a
  /// complete profile (name/publisher type/gender/birth date) — otherwise
  /// the router would redirect the user straight back to onboarding.
  ///
  /// Throws everything [importFromPicker] does, plus
  /// [BackupIncompleteProfileException] when the backup is missing profile
  /// fields. When the latter is thrown, no DB mutation has happened.
  Future<void> importForOnboarding() async {
    final file = await _pickBackupFile();
    final service = ref.read(backupServiceProvider);
    final backup = await service.decodeFile(file);
    service.validateCompleteProfile(backup);
    await service.applyBackup(backup);
    _invalidateAllDataProviders();
  }

  Future<File> _pickBackupFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
      withData: false,
    );
    final path = result?.files.single.path;
    if (path == null) {
      throw const BackupPickCancelled();
    }
    return File(path);
  }

  /// Force every data-dependent provider to rebuild after a restore.
  ///
  /// Riverpod invalidates the whole family when given the top-level
  /// generated reference, so one call per family is enough.
  void _invalidateAllDataProviders() {
    // Profile + theme
    ref.invalidate(userProfileProvider);
    ref.invalidate(themeNotifierProvider);

    // Activities and derived totals
    ref.invalidate(activityNotifierProvider);
    ref.invalidate(activitiesByMonthProvider);
    ref.invalidate(yearlyMinutesByMonthProvider);
    ref.invalidate(getTotalMinutesForMonthProvider);
    ref.invalidate(serviceYearTotalMinutesProvider);
    ref.invalidate(serviceYearTotalUpToProvider);
    ref.invalidate(currentMonthTotalMinutesProvider);

    // Goals / participation / month summaries
    ref.invalidate(goalNotifierProvider);
    ref.invalidate(participationNotifierProvider);
    ref.invalidate(monthSummaryProvider);

    // People + visits
    ref.invalidate(personNotifierProvider);
    ref.invalidate(bibleStudiesProvider);
    ref.invalidate(interestedPersonsProvider);
    ref.invalidate(bibleStudiesCountProvider);
    ref.invalidate(interestedPersonsCountProvider);
    ref.invalidate(personByIdProvider);
    ref.invalidate(visitNotifierProvider);
    ref.invalidate(bibleStudiesCountForMonthProvider);

    // Statistics
    ref.invalidate(serviceYearStatisticsProvider);
  }
}
