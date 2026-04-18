import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/providers/person_notifier.dart';
import '../widgets/add_person_sheet.dart';
import '../widgets/person_list.dart';
import 'person_detail_screen.dart';

/// People screen - Interested persons and Bible studies management
///
/// Displays:
/// - Tab 1: Bible studies with badge count
/// - Tab 2: Interested persons
/// - Search functionality (future)
/// - Add new person FAB
class PeopleScreen extends ConsumerStatefulWidget {
  const PeopleScreen({super.key});

  @override
  ConsumerState<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends ConsumerState<PeopleScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAddPersonSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: const AddPersonSheet(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Watch providers for both lists
    final bibleStudiesAsync = ref.watch(bibleStudiesProvider);
    final interestedPersonsAsync = ref.watch(interestedPersonsProvider);

    // Watch counts for badges
    final bibleStudiesCountAsync = ref.watch(bibleStudiesCountProvider);
    final interestedPersonsCountAsync =
        ref.watch(interestedPersonsCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personas'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Interesados'),
                  const SizedBox(width: 8),
                  interestedPersonsCountAsync.when(
                    data: (count) => count > 0
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '$count',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSecondaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Cursos bíblicos'),
                  const SizedBox(width: 8),
                  bibleStudiesCountAsync.when(
                    data: (count) => count > 0
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '$count',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Interested Persons Tab
          PersonList(
            personsAsync: interestedPersonsAsync,
            onPersonTap: (person) {
              // Navigate to person detail screen
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => PersonDetailScreen(person: person),
                ),
              );
            },
            emptyMessage: 'No hay personas interesadas registradas',
          ),

          // Bible Studies Tab
          PersonList(
            personsAsync: bibleStudiesAsync,
            onPersonTap: (person) {
              // Navigate to person detail screen
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => PersonDetailScreen(person: person),
                ),
              );
            },
            emptyMessage: 'No hay cursos bíblicos registrados',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPersonSheet,
        child: const Icon(Icons.person_add),
      ),
    );
  }
}
