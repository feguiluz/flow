import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/services/user_profile_service.dart';
import '../../../../shared/models/month_summary.dart';
import '../../../../shared/providers/database_provider.dart';
import 'goal_notifier.dart';

part 'month_summary_provider.g.dart';

/// Provider for calculating month summary for a specific month
@riverpod
Future<MonthSummary> monthSummary(
  MonthSummaryRef ref,
  int year,
  int month,
) async {
  // Get goal for the month
  final goal = await ref.watch(goalNotifierProvider(year, month).future);

  // Get total hours for the month
  final activityDao = await ref.read(activityDaoProvider.future);
  final activities = await activityDao.getByMonth(year, month);
  final totalHours = activities.fold<double>(
    0.0,
    (sum, activity) => sum + activity.minutes / 60.0,
  );

  // Get Bible studies count for the month
  final visitDao = await ref.read(visitDaoProvider.future);
  final bibleStudiesCount = await visitDao.countBibleStudiesInMonth(
    year,
    month,
  );

  // Calculate progress
  final targetHours = goal != null
      ? UserProfileService.instance.getTargetHoursForGoal(goal.goalType)
      : 0.0;

  final progressPercentage = targetHours > 0
      ? (totalHours / targetHours * 100.0).clamp(0.0, double.infinity)
      : 0.0;

  final isGoalMet = targetHours > 0 && totalHours >= targetHours;

  return MonthSummary(
    year: year,
    month: month,
    totalHours: totalHours,
    bibleStudiesCount: bibleStudiesCount,
    goal: goal,
    progressPercentage: progressPercentage,
    isGoalMet: isGoalMet,
  );
}

/// Provider for current month summary
@riverpod
Future<MonthSummary> currentMonthSummary(CurrentMonthSummaryRef ref) async {
  final now = DateTime.now();
  return ref.watch(monthSummaryProvider(now.year, now.month).future);
}
