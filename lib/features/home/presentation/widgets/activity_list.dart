import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/activity_notifier.dart';
import 'activity_item.dart';

/// Widget displaying a list of activities with loading and error states
class ActivityList extends ConsumerWidget {
  const ActivityList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activitiesAsync = ref.watch(activityNotifierProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return activitiesAsync.when(
      data: (activities) {
        if (activities.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.event_note_outlined,
                    size: 64,
                    color: colorScheme.outlineVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No hay actividades registradas',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Toca el botón + para registrar tus horas',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await ref.read(activityNotifierProvider.notifier).refresh();
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index];
              return ActivityItem(
                key: ValueKey(activity.id),
                activity: activity,
              );
            },
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Error al cargar actividades',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () {
                  ref.invalidate(activityNotifierProvider);
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
