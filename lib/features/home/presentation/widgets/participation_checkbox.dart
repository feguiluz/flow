import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flow/features/home/data/providers/participation_notifier.dart';

/// Checkbox widget for publishers without auxiliary goal
/// Shows "Participé este mes" checkbox
class ParticipationCheckbox extends ConsumerWidget {
  const ParticipationCheckbox({
    super.key,
    required this.year,
    required this.month,
  });

  final int year;
  final int month;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final participationAsync = ref.watch(
      participationNotifierProvider(year, month),
    );

    return participationAsync.when(
      data: (participation) {
        final participated = participation?.participated ?? false;

        return Card(
          elevation: participated ? 2 : 0,
          color: participated
              ? colorScheme.primaryContainer
              : colorScheme.surfaceContainerHighest,
          child: InkWell(
            onTap: () {
              ref
                  .read(participationNotifierProvider(year, month).notifier)
                  .toggleParticipation();
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Checkbox
                  Checkbox(
                    value: participated,
                    onChanged: (value) {
                      ref
                          .read(participationNotifierProvider(year, month)
                              .notifier)
                          .setParticipation(value ?? false);
                    },
                  ),
                  const SizedBox(width: 12),

                  // Text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Participé este mes',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: participated
                                ? colorScheme.onPrimaryContainer
                                : colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          participated
                              ? 'Participación registrada'
                              : 'Marca si participaste en el ministerio este mes',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: participated
                                ? colorScheme.onPrimaryContainer
                                : colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Icon
                  if (participated)
                    Icon(
                      Icons.check_circle,
                      color: colorScheme.primary,
                      size: 32,
                    ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      error: (error, stack) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}
