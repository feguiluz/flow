import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/database/daos/person_dao.dart';
import '../../../../core/database/daos/visit_dao.dart';
import '../../../../shared/models/visit.dart';
import '../../../../shared/providers/database_provider.dart';
import '../../../home/data/providers/month_summary_provider.dart';

part 'visit_notifier.g.dart';

/// Provider for managing visit data for a specific person
@riverpod
class VisitNotifier extends _$VisitNotifier {
  late int _personId;

  @override
  Future<List<Visit>> build(int personId) async {
    try {
      _personId = personId;
      final visitDao = await ref.watch(visitDaoProvider.future);
      return await visitDao.getByPerson(_personId);
    } catch (e) {
      // Return empty list on initial load error instead of showing error state
      return [];
    }
  }

  /// Add a new visit
  Future<void> addVisit(Visit visit) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final visitDao = await ref.read(visitDaoProvider.future);
      await visitDao.insert(visit);

      // Invalidate all visit-related providers to refresh UI
      ref.invalidate(visitsByPersonProvider);
      ref.invalidate(visitsByMonthProvider);
      ref.invalidate(bibleStudiesCountForMonthProvider);
      ref.invalidate(visitCountByPersonProvider);

      // Invalidate month summary to update Bible studies count on home
      ref.invalidate(monthSummaryProvider);
      ref.invalidate(currentMonthSummaryProvider);

      return await visitDao.getByPerson(_personId);
    });
  }

  /// Update an existing visit
  Future<void> updateVisit(Visit visit) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final visitDao = await ref.read(visitDaoProvider.future);
      await visitDao.update(visit);

      // Invalidate all visit-related providers to refresh UI
      ref.invalidate(visitsByPersonProvider);
      ref.invalidate(visitsByMonthProvider);
      ref.invalidate(bibleStudiesCountForMonthProvider);
      ref.invalidate(visitCountByPersonProvider);

      // Invalidate month summary to update Bible studies count on home
      ref.invalidate(monthSummaryProvider);
      ref.invalidate(currentMonthSummaryProvider);

      return await visitDao.getByPerson(_personId);
    });
  }

  /// Delete a visit
  Future<void> deleteVisit(int id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final visitDao = await ref.read(visitDaoProvider.future);
      await visitDao.delete(id);

      // Invalidate all visit-related providers to refresh UI
      ref.invalidate(visitsByPersonProvider);
      ref.invalidate(visitsByMonthProvider);
      ref.invalidate(bibleStudiesCountForMonthProvider);
      ref.invalidate(visitCountByPersonProvider);

      // Invalidate month summary to update Bible studies count on home
      ref.invalidate(monthSummaryProvider);
      ref.invalidate(currentMonthSummaryProvider);

      return await visitDao.getByPerson(_personId);
    });
  }

  /// Refresh visits for the person
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final visitDao = await ref.read(visitDaoProvider.future);
      return await visitDao.getByPerson(_personId);
    });
  }
}

/// Provider for visits by person
@riverpod
Future<List<Visit>> visitsByPerson(VisitsByPersonRef ref, int personId) async {
  try {
    final visitDao = await ref.watch(visitDaoProvider.future);
    return await visitDao.getByPerson(personId);
  } catch (e) {
    // Return empty list on initial load error instead of showing error state
    return [];
  }
}

/// Provider for visits by month
@riverpod
Future<List<Visit>> visitsByMonth(
  VisitsByMonthRef ref,
  int year,
  int month,
) async {
  try {
    final visitDao = await ref.watch(visitDaoProvider.future);
    return await visitDao.getByMonth(year, month);
  } catch (e) {
    // Return empty list on initial load error instead of showing error state
    return [];
  }
}

/// Provider for Bible studies count
/// A Bible study is counted if the person has is_bible_study = true
/// Note: Month parameters are kept for consistency but not used in the query
/// All active Bible studies are counted regardless of visits that month
@riverpod
Future<int> bibleStudiesCountForMonth(
  BibleStudiesCountForMonthRef ref,
  int year,
  int month,
) async {
  final personDao = await ref.watch(personDaoProvider.future);
  return personDao.getBibleStudiesCount();
}

/// Provider for visit count by person
@riverpod
Future<int> visitCountByPerson(VisitCountByPersonRef ref, int personId) async {
  final visitDao = await ref.watch(visitDaoProvider.future);
  return visitDao.getVisitCountByPerson(personId);
}

/// Provider for a specific visit by ID
@riverpod
Future<Visit?> visitById(VisitByIdRef ref, int id) async {
  final visitDao = await ref.watch(visitDaoProvider.future);
  return visitDao.getById(id);
}
