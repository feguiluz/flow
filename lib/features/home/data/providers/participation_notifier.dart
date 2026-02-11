import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flow/shared/models/participation.dart';
import 'package:flow/shared/providers/database_provider.dart';
import 'package:flow/features/home/data/providers/month_summary_provider.dart';

part 'participation_notifier.g.dart';

/// Provider for managing monthly participation
@riverpod
class ParticipationNotifier extends _$ParticipationNotifier {
  late int _year;
  late int _month;

  @override
  Future<Participation?> build(int year, int month) async {
    _year = year;
    _month = month;
    final participationDao = await ref.read(participationDaoProvider.future);
    return participationDao.getByMonth(year, month);
  }

  /// Toggle participation for the month
  Future<void> toggleParticipation() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final participationDao = await ref.read(participationDaoProvider.future);
      final current = await participationDao.getByMonth(_year, _month);

      if (current == null) {
        // Create new participation record
        final participation = Participation(
          year: _year,
          month: _month,
          participated: true,
          createdAt: DateTime.now(),
        );
        await participationDao.insertOrUpdate(participation);
        ref.invalidate(monthSummaryProvider);
        return participation;
      } else {
        // Toggle existing participation
        final updated = current.copyWith(participated: !current.participated);
        await participationDao.insertOrUpdate(updated);
        ref.invalidate(monthSummaryProvider);
        return updated;
      }
    });
  }

  /// Set participation status explicitly
  Future<void> setParticipation(bool participated) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final participationDao = await ref.read(participationDaoProvider.future);

      final participation = Participation(
        year: _year,
        month: _month,
        participated: participated,
        createdAt: DateTime.now(),
      );

      await participationDao.insertOrUpdate(participation);
      ref.invalidate(monthSummaryProvider);

      return participation;
    });
  }
}

/// Provider for current month's participation
@riverpod
Future<Participation?> currentMonthParticipation(
  CurrentMonthParticipationRef ref,
) async {
  final now = DateTime.now();
  return ref.watch(participationNotifierProvider(now.year, now.month).future);
}
