import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/database/daos/activity_dao.dart';
import '../../../../shared/models/activity.dart';
import '../../../../shared/providers/database_provider.dart';

part 'activity_notifier.g.dart';

/// Provider for managing activity data for the current month
@riverpod
class ActivityNotifier extends _$ActivityNotifier {
  late ActivityDao _activityDao;

  @override
  Future<List<Activity>> build() async {
    try {
      _activityDao = ref.watch(activityDaoProvider);
      final now = DateTime.now();
      return await _loadActivities(now.year, now.month);
    } catch (e) {
      // Return empty list on initial load error instead of showing error state
      return [];
    }
  }

  /// Load activities for a specific month
  Future<List<Activity>> _loadActivities(int year, int month) async {
    return _activityDao.getByMonth(year, month);
  }

  /// Add a new activity
  Future<void> addActivity(Activity activity) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _activityDao.insert(activity);
      final now = DateTime.now();
      return _loadActivities(now.year, now.month);
    });
  }

  /// Update an existing activity
  Future<void> updateActivity(Activity activity) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _activityDao.update(activity);
      final now = DateTime.now();
      return _loadActivities(now.year, now.month);
    });
  }

  /// Delete an activity
  Future<void> deleteActivity(int id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _activityDao.delete(id);
      final now = DateTime.now();
      return _loadActivities(now.year, now.month);
    });
  }

  /// Refresh activities for the current month
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final now = DateTime.now();
      return _loadActivities(now.year, now.month);
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
  final activityDao = ref.watch(activityDaoProvider);
  return activityDao.getByMonth(year, month);
}

/// Provider for total minutes by month in a specific year
@riverpod
Future<Map<int, int>> yearlyMinutesByMonth(
  YearlyMinutesByMonthRef ref,
  int year,
) async {
  final activityDao = ref.watch(activityDaoProvider);
  return activityDao.getMinutesByMonthForYear(year);
}
