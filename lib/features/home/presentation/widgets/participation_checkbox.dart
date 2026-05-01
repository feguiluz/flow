import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flow/core/theme/motion.dart';
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

        // Animated card so color (surface ↔ primaryContainer) interpolates
        // when toggled. Card itself has no animated color/elevation, so we
        // wrap with an AnimatedContainer painted to look like a Card.
        return AnimatedContainer(
          duration: AppMotion.sm,
          curve: AppMotion.standard,
          decoration: BoxDecoration(
            color: participated
                ? colorScheme.primaryContainer
                : colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            boxShadow: participated
                ? [
                    BoxShadow(
                      color: colorScheme.shadow.withOpacity(0.08),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : const [],
          ),
          child: Material(
            color: Colors.transparent,
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedDefaultTextStyle(
                            duration: AppMotion.sm,
                            curve: AppMotion.standard,
                            style: theme.textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: participated
                                  ? colorScheme.onPrimaryContainer
                                  : colorScheme.onSurface,
                            ),
                            child: const Text('Participé este mes'),
                          ),
                          const SizedBox(height: 4),
                          AnimatedDefaultTextStyle(
                            duration: AppMotion.sm,
                            curve: AppMotion.standard,
                            style: theme.textTheme.bodyMedium!.copyWith(
                              color: participated
                                  ? colorScheme.onPrimaryContainer
                                  : colorScheme.onSurfaceVariant,
                            ),
                            child: Text(
                              participated
                                  ? 'Participación registrada'
                                  : 'Marca si participaste en el ministerio este mes',
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Icon enters/leaves with a scale + fade.
                    AnimatedSwitcher(
                      duration: AppMotion.sm,
                      transitionBuilder: (child, animation) => ScaleTransition(
                        scale: animation,
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      ),
                      child: participated
                          ? Icon(
                              Icons.check_circle,
                              key: const ValueKey('participated-yes'),
                              color: colorScheme.primary,
                              size: 32,
                            )
                          : const SizedBox(
                              key: ValueKey('participated-no'),
                              width: 32,
                              height: 32,
                            ),
                    ),
                  ],
                ),
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
