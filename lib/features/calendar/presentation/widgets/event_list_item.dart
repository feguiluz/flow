import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flow/features/calendar/data/models/calendar_event.dart';
import 'package:flow/features/people/data/providers/person_notifier.dart';

/// Card representing a single event inside the day list.
/// Shows the time (or "Sin hora"), the person and a recurrence chip.
class EventListItem extends ConsumerWidget {
  const EventListItem({
    super.key,
    required this.event,
    required this.onTap,
  });

  final CalendarEvent event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isCompleted = event.status == EventStatus.completed;
    final personAsync = ref.watch(personByIdProvider(event.personId));

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              SizedBox(
                width: 56,
                child: Column(
                  children: [
                    Icon(
                      isCompleted ? Icons.check_circle : Icons.event,
                      color: isCompleted
                          ? colorScheme.tertiary
                          : colorScheme.primary,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event.time != null ? _formatTime(event.time!) : 'Sin hora',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: isCompleted
                            ? colorScheme.onSurfaceVariant
                            : colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    personAsync.when(
                      data: (p) => Text(
                        p?.name ?? '—',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          decoration:
                              isCompleted ? TextDecoration.lineThrough : null,
                          color: isCompleted
                              ? colorScheme.onSurfaceVariant
                              : null,
                        ),
                      ),
                      loading: () => const Text('Cargando…'),
                      error: (_, __) => const Text('—'),
                    ),
                    if (event.notes != null && event.notes!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        event.notes!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    if (event.seriesId != null) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.repeat,
                            size: 14,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            event.recurrenceWeeks == 1
                                ? 'Cada semana'
                                : 'Cada ${event.recurrenceWeeks} semanas',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}
