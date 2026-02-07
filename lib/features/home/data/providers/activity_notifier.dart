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
    _activityDao = ref.watch(activityDaoProvider);
    final now = DateTime.now();
    return _loadActivities(now.year, now.month);
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

/// Provider for calculating total hours in the current month
@riverpod
Future<double> currentMonthTotalHours(CurrentMonthTotalHoursRef ref) async {
  final activityDao = ref.watch(activityDaoProvider);
  final now = DateTime.now();
  return activityDao.getTotalHoursByMonth(now.year, now.month);
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

/// Provider for total hours by month in a specific year
@riverpod
Future<Map<int, double>> yearlyHoursByMonth(
  YearlyHoursByMonthRef ref,
  int year,
) async {
  final activityDao = ref.watch(activityDaoProvider);
  return activityDao.getHoursByMonthForYear(year);
}
