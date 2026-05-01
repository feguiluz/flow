import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/providers/person_notifier.dart';
import '../widgets/add_person_sheet.dart';
import '../../../../core/routing/app_route.dart';
import '../../../../shared/widgets/motion/scale_tap.dart';
import '../widgets/people_sort_sheet.dart';
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

    // Watch providers for both lists (sorted variant — order follows the
    // user's choice persisted in PeopleSortOptionNotifier).
    final bibleStudiesAsync = ref.watch(sortedBibleStudiesProvider);
    final interestedPersonsAsync = ref.watch(sortedInterestedPersonsProvider);

    // Watch counts for badges
    final bibleStudiesCountAsync = ref.watch(bibleStudiesCountProvider);
    final interestedPersonsCountAsync =
        ref.watch(interestedPersonsCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            tooltip: 'Ordenar por…',
            onPressed: () => PeopleSortSheet.show(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Interesados'),
                  const SizedBox(width: 8),
                  _AnimatedTabBadge(
                    countAsync: interestedPersonsCountAsync,
                    background: colorScheme.secondaryContainer,
                    foreground: colorScheme.onSecondaryContainer,
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
                  _AnimatedTabBadge(
                    countAsync: bibleStudiesCountAsync,
                    background: colorScheme.primaryContainer,
                    foreground: colorScheme.onPrimaryContainer,
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
                appRoute<void>(
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
                appRoute<void>(
                  builder: (context) => PersonDetailScreen(person: person),
                ),
              );
            },
            emptyMessage: 'No hay cursos bíblicos registrados',
          ),
        ],
      ),
      floatingActionButton: ScaleTap(
        child: FloatingActionButton(
          onPressed: _showAddPersonSheet,
          child: const Icon(Icons.person_add),
        ),
      ),
    );
  }
}

/// Pill-shaped tab badge that scales + fades in/out whenever the count
/// changes. Uses a [ValueKey] on the count so [AnimatedSwitcher] treats
/// each value as a fresh child and runs the transition.
class _AnimatedTabBadge extends StatelessWidget {
  const _AnimatedTabBadge({
    required this.countAsync,
    required this.background,
    required this.foreground,
  });

  final AsyncValue<int> countAsync;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      switchInCurve: Curves.easeOutBack,
      transitionBuilder: (child, animation) => ScaleTransition(
        scale: animation,
        child: FadeTransition(opacity: animation, child: child),
      ),
      child: countAsync.maybeWhen(
        data: (count) {
          if (count <= 0) {
            return const SizedBox.shrink(key: ValueKey('badge-empty'));
          }
          return Container(
            key: ValueKey('badge-$count'),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$count',
              style: theme.textTheme.labelSmall?.copyWith(
                color: foreground,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
        orElse: () => const SizedBox.shrink(key: ValueKey('badge-empty')),
      ),
    );
  }
}
