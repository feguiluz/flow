import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../shared/models/goal.dart';
import '../../../../shared/providers/database_provider.dart';

part 'goal_notifier.g.dart';

/// Provider for managing monthly goals
@riverpod
class GoalNotifier extends _$GoalNotifier {
  @override
  Future<Goal?> build(int year, int month) async {
    return _loadGoal(year, month);
  }

  Future<Goal?> _loadGoal(int year, int month) async {
    final goalDao = await ref.read(goalDaoProvider.future);
    return goalDao.getByMonth(year, month);
  }

  /// Set or update goal for a specific month
  Future<void> setGoal(Goal goal) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final goalDao = await ref.read(goalDaoProvider.future);

      // Use insertOrUpdate which handles both cases
      final id = await goalDao.insertOrUpdate(goal);
      return goal.copyWith(id: id);
    });
  }

  /// Delete goal for a specific month
  Future<void> deleteGoal(int year, int month) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final goalDao = await ref.read(goalDaoProvider.future);
      await goalDao.delete(year, month);
      return null;
    });
  }
}

/// Provider for current month's goal
@riverpod
Future<Goal?> currentMonthGoal(CurrentMonthGoalRef ref) async {
  final now = DateTime.now();
  return ref.watch(goalNotifierProvider(now.year, now.month).future);
}
