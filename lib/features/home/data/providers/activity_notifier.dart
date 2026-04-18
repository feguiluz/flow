import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flow/core/database/daos/activity_dao.dart';
import 'package:flow/features/home/data/providers/month_summary_provider.dart';
import 'package:flow/shared/models/activity.dart';
import 'package:flow/shared/providers/database_provider.dart';

part 'activity_notifier.g.dart';

/// Provider for managing activity data for the current month
@riverpod
class ActivityNotifier extends _$ActivityNotifier {
  @override
  Future<List<Activity>> build() async {
    try {
      final activityDao = await ref.watch(activityDaoProvider.future);
      final now = DateTime.now();
      return await activityDao.getByMonth(now.year, now.month);
    } catch (e) {
      // Return empty list on initial load error instead of showing error state
      return [];
    }
  }

  /// Add a new activity
  Future<void> addActivity(Activity activity) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final activityDao = await ref.read(activityDaoProvider.future);
      await activityDao.insert(activity);

      // Invalidate all month-specific providers to refresh UI
      ref.invalidate(activitiesByMonthProvider);
      ref.invalidate(getTotalMinutesForMonthProvider);
      ref.invalidate(serviceYearTotalMinutesProvider);
      ref.invalidate(serviceYearTotalUpToProvider);
      ref.invalidate(monthSummaryProvider);

      final now = DateTime.now();
      return activityDao.getByMonth(now.year, now.month);
    });
  }

  /// Update an existing activity
  Future<void> updateActivity(Activity activity) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final activityDao = await ref.read(activityDaoProvider.future);
      await activityDao.update(activity);

      // Invalidate all month-specific providers to refresh UI
      ref.invalidate(activitiesByMonthProvider);
      ref.invalidate(getTotalMinutesForMonthProvider);
      ref.invalidate(serviceYearTotalMinutesProvider);
      ref.invalidate(serviceYearTotalUpToProvider);
      ref.invalidate(monthSummaryProvider);

      final now = DateTime.now();
      return activityDao.getByMonth(now.year, now.month);
    });
  }

  /// Delete an activity
  Future<void> deleteActivity(int id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final activityDao = await ref.read(activityDaoProvider.future);
      await activityDao.delete(id);

      // Invalidate all month-specific providers to refresh UI
      ref.invalidate(activitiesByMonthProvider);
      ref.invalidate(getTotalMinutesForMonthProvider);
      ref.invalidate(serviceYearTotalMinutesProvider);
      ref.invalidate(serviceYearTotalUpToProvider);
      ref.invalidate(monthSummaryProvider);

      final now = DateTime.now();
      return activityDao.getByMonth(now.year, now.month);
    });
  }

  /// Refresh activities for the current month
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final now = DateTime.now();
      final activityDao = await ref.read(activityDaoProvider.future);
      return activityDao.getByMonth(now.year, now.month);
    });
  }
}

/// Provider for calculating total minutes in the current month
@riverpod
Future<int> currentMonthTotalMinutes(CurrentMonthTotalMinutesRef ref) async {
  // Watch the activity list to auto-refresh when it changes
  final activities = await ref.watch(activityNotifierProvider.future);

  // Calculate total from the activities list
  return activities.fold<int>(
    0,
    (sum, activity) => sum + activity.minutes,
  );
}

/// Provider for activities of a specific month
@riverpod
Future<List<Activity>> activitiesByMonth(
  ActivitiesByMonthRef ref,
  int year,
  int month,
) async {
  try {
    final activityDao = await ref.watch(activityDaoProvider.future);
    return await activityDao.getByMonth(year, month);
  } catch (e) {
    // Return empty list on initial load error instead of showing error state
    return [];
  }
}

/// Provider for total minutes by month in a specific year
@riverpod
Future<Map<int, int>> yearlyMinutesByMonth(
  YearlyMinutesByMonthRef ref,
  int year,
) async {
  final activityDao = await ref.watch(activityDaoProvider.future);
  return activityDao.getMinutesByMonthForYear(year);
}

/// Provider for total minutes in a specific month
@riverpod
Future<int> getTotalMinutesForMonth(
  GetTotalMinutesForMonthRef ref, {
  required int year,
  required int month,
}) async {
  final activityDao = await ref.watch(activityDaoProvider.future);
  return activityDao.getTotalMinutesByMonth(year, month);
}

/// Provider for service year total minutes
/// startYear = 2025 means Sep 2025 - Aug 2026
@riverpod
Future<int> serviceYearTotalMinutes(
  ServiceYearTotalMinutesRef ref,
  int startYear,
) async {
  final activityDao = await ref.watch(activityDaoProvider.future);
  return activityDao.getTotalMinutesForServiceYear(startYear);
}

/// Provider for service year total UP TO a specific date
/// Used for showing accumulated progress
@riverpod
Future<int> serviceYearTotalUpTo(
  ServiceYearTotalUpToRef ref, {
  required int startYear,
  required DateTime upToDate,
}) async {
  final activityDao = await ref.watch(activityDaoProvider.future);
  return activityDao.getTotalMinutesForServiceYearUpTo(startYear, upToDate);
}
