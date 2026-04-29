import 'package:flow/features/people/data/models/people_sort_option.dart';
import 'package:flow/shared/models/person.dart';

/// Returns a new list of [persons] ordered by [option].
///
/// For [PeopleSortOption.lastVisitDesc], [lastVisits] must map each person id
/// to its most recent visit date. People without an entry in [lastVisits] are
/// considered "never visited" and placed at the end of the list. Ties are
/// broken alphabetically (case-insensitive). For the other sort options
/// [lastVisits] is ignored.
List<Person> sortPersons(
  List<Person> persons,
  PeopleSortOption option, {
  Map<int, DateTime>? lastVisits,
}) {
  int byNameAsc(Person a, Person b) =>
      a.name.toLowerCase().compareTo(b.name.toLowerCase());

  final sorted = [...persons];
  switch (option) {
    case PeopleSortOption.alphabetical:
      sorted.sort(byNameAsc);
    case PeopleSortOption.createdAtDesc:
      sorted.sort((a, b) {
        final c = b.createdAt.compareTo(a.createdAt);
        return c != 0 ? c : byNameAsc(a, b);
      });
    case PeopleSortOption.lastVisitDesc:
      final lv = lastVisits ?? const <int, DateTime>{};
      sorted.sort((a, b) {
        final av = a.id != null ? lv[a.id] : null;
        final bv = b.id != null ? lv[b.id] : null;
        if (av == null && bv == null) return byNameAsc(a, b);
        if (av == null) return 1;
        if (bv == null) return -1;
        final c = bv.compareTo(av);
        return c != 0 ? c : byNameAsc(a, b);
      });
  }
  return sorted;
}
