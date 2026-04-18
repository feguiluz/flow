import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/person.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import 'person_item.dart';

/// Widget that displays a list of persons
class PersonList extends ConsumerWidget {
  const PersonList({
    required this.personsAsync,
    required this.onPersonTap,
    this.emptyMessage = 'No hay personas registradas',
    super.key,
  });

  final AsyncValue<List<Person>> personsAsync;
  final void Function(Person) onPersonTap;
  final String emptyMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return personsAsync.when(
      data: (persons) {
        if (persons.isEmpty) {
          return EmptyState(
            icon: Icons.people_outline,
            message: emptyMessage,
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: persons.length,
          itemBuilder: (context, index) {
            final person = persons[index];
            return PersonItem(
              key: ValueKey(person.id),
              person: person,
              onTap: () => onPersonTap(person),
            );
          },
        );
      },
      loading: () => const LoadingIndicator(),
      error: (error, stack) => ErrorView(
        message: error.toString(),
        onRetry: () {
          // Refresh will be handled by parent
        },
      ),
    );
  }
}
