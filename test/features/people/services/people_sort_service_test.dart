import 'package:flutter_test/flutter_test.dart';

import 'package:flow/features/people/data/models/people_sort_option.dart';
import 'package:flow/features/people/data/services/people_sort_service.dart';
import 'package:flow/shared/models/person.dart';

Person _person({
  required int id,
  required String name,
  DateTime? createdAt,
}) {
  return Person(
    id: id,
    name: name,
    isBibleStudy: false,
    createdAt: createdAt ?? DateTime(2026, 1, 1),
  );
}

void main() {
  group('sortPersons - alphabetical', () {
    test('sorts by name case-insensitive ascending', () {
      final list = [
        _person(id: 1, name: 'Carlos'),
        _person(id: 2, name: 'ana'),
        _person(id: 3, name: 'Beatriz'),
      ];

      final sorted = sortPersons(list, PeopleSortOption.alphabetical);

      expect(sorted.map((p) => p.id).toList(), [2, 3, 1]);
    });

    test('returns a new list (does not mutate input)', () {
      final input = [
        _person(id: 1, name: 'B'),
        _person(id: 2, name: 'A'),
      ];
      final originalOrder = input.map((p) => p.id).toList();

      sortPersons(input, PeopleSortOption.alphabetical);

      expect(input.map((p) => p.id).toList(), originalOrder);
    });

    test('handles empty list', () {
      expect(sortPersons([], PeopleSortOption.alphabetical), isEmpty);
    });
  });

  group('sortPersons - createdAtDesc', () {
    test('most recently created first', () {
      final list = [
        _person(id: 1, name: 'A', createdAt: DateTime(2026, 1, 10)),
        _person(id: 2, name: 'B', createdAt: DateTime(2026, 4, 1)),
        _person(id: 3, name: 'C', createdAt: DateTime(2026, 2, 15)),
      ];

      final sorted = sortPersons(list, PeopleSortOption.createdAtDesc);

      expect(sorted.map((p) => p.id).toList(), [2, 3, 1]);
    });

    test('breaks ties alphabetically', () {
      final sameDate = DateTime(2026, 4, 1);
      final list = [
        _person(id: 1, name: 'Carlos', createdAt: sameDate),
        _person(id: 2, name: 'Ana', createdAt: sameDate),
        _person(id: 3, name: 'Beatriz', createdAt: sameDate),
      ];

      final sorted = sortPersons(list, PeopleSortOption.createdAtDesc);

      expect(sorted.map((p) => p.id).toList(), [2, 3, 1]);
    });
  });

  group('sortPersons - lastVisitDesc', () {
    test('most recent visit first', () {
      final list = [
        _person(id: 1, name: 'A'),
        _person(id: 2, name: 'B'),
        _person(id: 3, name: 'C'),
      ];
      final lastVisits = {
        1: DateTime(2026, 1, 1),
        2: DateTime(2026, 4, 1),
        3: DateTime(2026, 2, 15),
      };

      final sorted = sortPersons(
        list,
        PeopleSortOption.lastVisitDesc,
        lastVisits: lastVisits,
      );

      expect(sorted.map((p) => p.id).toList(), [2, 3, 1]);
    });

    test('people without visits go to the end', () {
      final list = [
        _person(id: 1, name: 'NoVisit'),
        _person(id: 2, name: 'Recent'),
        _person(id: 3, name: 'AlsoNoVisit'),
        _person(id: 4, name: 'Old'),
      ];
      final lastVisits = {
        2: DateTime(2026, 4, 1),
        4: DateTime(2026, 1, 1),
      };

      final sorted = sortPersons(
        list,
        PeopleSortOption.lastVisitDesc,
        lastVisits: lastVisits,
      );

      // First Recent (id 2), then Old (id 4), then no-visits alphabetically
      // (AlsoNoVisit id 3, then NoVisit id 1).
      expect(sorted.map((p) => p.id).toList(), [2, 4, 3, 1]);
    });

    test('breaks visit-date ties alphabetically', () {
      final sameDate = DateTime(2026, 4, 1);
      final list = [
        _person(id: 1, name: 'Carlos'),
        _person(id: 2, name: 'Ana'),
      ];
      final lastVisits = {1: sameDate, 2: sameDate};

      final sorted = sortPersons(
        list,
        PeopleSortOption.lastVisitDesc,
        lastVisits: lastVisits,
      );

      expect(sorted.map((p) => p.id).toList(), [2, 1]);
    });

    test('all without visits → alphabetical order', () {
      final list = [
        _person(id: 1, name: 'Carlos'),
        _person(id: 2, name: 'Ana'),
        _person(id: 3, name: 'Beatriz'),
      ];

      final sorted = sortPersons(
        list,
        PeopleSortOption.lastVisitDesc,
        lastVisits: const {},
      );

      expect(sorted.map((p) => p.id).toList(), [2, 3, 1]);
    });

    test('omitting lastVisits map treats everyone as no-visits', () {
      final list = [
        _person(id: 1, name: 'B'),
        _person(id: 2, name: 'A'),
      ];

      final sorted = sortPersons(list, PeopleSortOption.lastVisitDesc);

      expect(sorted.map((p) => p.id).toList(), [2, 1]);
    });
  });
}
