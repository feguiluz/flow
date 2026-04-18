import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flow/core/services/user_profile_service.dart';
import 'package:flow/shared/models/month_summary.dart';
import 'package:flow/shared/models/publisher_type.dart';
import 'package:flow/shared/providers/database_provider.dart';
import 'package:flow/shared/providers/user_profile_provider.dart';
import 'goal_notifier.dart';

part 'month_summary_provider.g.dart';

/// Provider for calculating month summary for a specific month
@riverpod
Future<MonthSummary> monthSummary(
  MonthSummaryRef ref,
  int year,
  int month,
) async {
  // Watch user profile to automatically invalidate when it changes
  final userProfile = await ref.watch(userProfileProvider.future);

  // Listen to profile changes and invalidate this provider
  ref.listen(userProfileProvider, (previous, next) {
    // Force rebuild when profile changes
    ref.invalidateSelf();
  });

  // Get goal for the month (may be null for regular/special pioneers)
  final goal = await ref.watch(goalNotifierProvider(year, month).future);

  // Get total hours for the month
  final activityDao = await ref.read(activityDaoProvider.future);
  final activities = await activityDao.getByMonth(year, month);
  final totalHours = activities.fold<double>(
    0.0,
    (sum, activity) => sum + activity.minutes / 60.0,
  );

  // Get Bible studies count
  // Count all persons marked as isBibleStudy=true (active Bible studies)
  final personDao = await ref.read(personDaoProvider.future);
  final bibleStudiesCount = await personDao.getBibleStudiesCount();

  // Calculate target hours based on publisher type and start date
  double targetHours = 0.0;
  final currentMonthDate = DateTime(year, month, 1);

  if (userProfile.publisherType == PublisherType.regularPioneer) {
    // Regular pioneer: automatic 50h goal ONLY if month >= start date
    final startDate = userProfile.regularPioneerStartDate;
    if (startDate != null) {
      final startMonthDate = DateTime(startDate.year, startDate.month, 1);
      // Check if current month is on or after start month
      if (currentMonthDate.isAtSameMomentAs(startMonthDate) ||
          currentMonthDate.isAfter(startMonthDate)) {
        targetHours = 50.0;
      }
    }
  } else if (userProfile.publisherType == PublisherType.specialPioneer) {
    // Special pioneer: automatic 90-100h goal based on gender/age ONLY if month >= start date
    final startDate = userProfile.specialPioneerStartDate;
    if (startDate != null) {
      final startMonthDate = DateTime(startDate.year, startDate.month, 1);
      // Check if current month is on or after start month
      if (currentMonthDate.isAtSameMomentAs(startMonthDate) ||
          currentMonthDate.isAfter(startMonthDate)) {
        targetHours =
            UserProfileService.instance.getMonthlyGoalHours() ?? 100.0;
      }
    }
  } else if (userProfile.publisherType == PublisherType.publisher) {
    // Publisher: only has goal if they set auxiliary pioneer goal manually
    if (goal != null) {
      targetHours =
          UserProfileService.instance.getTargetHoursForGoal(goal.goalType);
    }
  }

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
    targetHours: targetHours, // Add explicit target hours
  );
}

/// Provider for current month summary
@riverpod
Future<MonthSummary> currentMonthSummary(CurrentMonthSummaryRef ref) async {
  final now = DateTime.now();
  return ref.watch(monthSummaryProvider(now.year, now.month).future);
}
