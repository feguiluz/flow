import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/database/daos/person_dao.dart';
import '../../../../shared/models/person.dart';
import '../../../../shared/providers/database_provider.dart';
import '../../../home/data/providers/month_summary_provider.dart';

part 'person_notifier.g.dart';

/// Provider for managing person data (Bible studies and interested persons)
@riverpod
class PersonNotifier extends _$PersonNotifier {
  @override
  Future<List<Person>> build() async {
    try {
      final personDao = await ref.watch(personDaoProvider.future);
      return await personDao.getAll();
    } catch (e) {
      // Return empty list on initial load error instead of showing error state
      return [];
    }
  }

  /// Add a new person
  Future<void> addPerson(Person person) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final personDao = await ref.read(personDaoProvider.future);
      await personDao.insert(person);

      // Invalidate all person-related providers to refresh UI
      ref.invalidate(bibleStudiesProvider);
      ref.invalidate(interestedPersonsProvider);
      ref.invalidate(bibleStudiesCountProvider);
      ref.invalidate(interestedPersonsCountProvider);
      ref.invalidate(personByIdProvider);

      // Invalidate month summary to update Bible studies count on home
      ref.invalidate(monthSummaryProvider);
      ref.invalidate(currentMonthSummaryProvider);

      return await personDao.getAll();
    });
  }

  /// Update an existing person
  Future<void> updatePerson(Person person) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final personDao = await ref.read(personDaoProvider.future);
      await personDao.update(person);

      // Invalidate all person-related providers to refresh UI
      ref.invalidate(bibleStudiesProvider);
      ref.invalidate(interestedPersonsProvider);
      ref.invalidate(bibleStudiesCountProvider);
      ref.invalidate(interestedPersonsCountProvider);
      // Detail screens (and the event detail sheet) watch this family.
      ref.invalidate(personByIdProvider);

      // Invalidate month summary to update Bible studies count on home
      ref.invalidate(monthSummaryProvider);
      ref.invalidate(currentMonthSummaryProvider);

      return await personDao.getAll();
    });
  }

  /// Delete a person (and all their visits due to CASCADE)
  Future<void> deletePerson(int id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final personDao = await ref.read(personDaoProvider.future);
      await personDao.delete(id);

      // Invalidate all person-related providers to refresh UI
      ref.invalidate(bibleStudiesProvider);
      ref.invalidate(interestedPersonsProvider);
      ref.invalidate(bibleStudiesCountProvider);
      ref.invalidate(interestedPersonsCountProvider);
      ref.invalidate(personByIdProvider);

      // Invalidate month summary to update Bible studies count on home
      ref.invalidate(monthSummaryProvider);
      ref.invalidate(currentMonthSummaryProvider);

      return await personDao.getAll();
    });
  }

  /// Refresh all persons
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final personDao = await ref.read(personDaoProvider.future);
      return await personDao.getAll();
    });
  }

  /// Search persons by name
  Future<List<Person>> searchPersons(String query) async {
    final personDao = await ref.read(personDaoProvider.future);
    if (query.isEmpty) {
      return await personDao.getAll();
    }
    return personDao.search(query);
  }
}

/// Provider for Bible studies only
@riverpod
Future<List<Person>> bibleStudies(BibleStudiesRef ref) async {
  try {
    final personDao = await ref.watch(personDaoProvider.future);
    return await personDao.getBibleStudies();
  } catch (e) {
    // Return empty list on initial load error instead of showing error state
    return [];
  }
}

/// Provider for interested persons only (not Bible studies)
@riverpod
Future<List<Person>> interestedPersons(InterestedPersonsRef ref) async {
  try {
    final personDao = await ref.watch(personDaoProvider.future);
    return await personDao.getInterestedPersons();
  } catch (e) {
    // Return empty list on initial load error instead of showing error state
    return [];
  }
}

/// Provider for Bible studies count
@riverpod
Future<int> bibleStudiesCount(BibleStudiesCountRef ref) async {
  final personDao = await ref.watch(personDaoProvider.future);
  return personDao.getBibleStudiesCount();
}

/// Provider for interested persons count
@riverpod
Future<int> interestedPersonsCount(InterestedPersonsCountRef ref) async {
  final personDao = await ref.watch(personDaoProvider.future);
  return personDao.getInterestedPersonsCount();
}

/// Provider for a specific person by ID
@riverpod
Future<Person?> personById(PersonByIdRef ref, int id) async {
  final personDao = await ref.watch(personDaoProvider.future);
  return personDao.getById(id);
}
