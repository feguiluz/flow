import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flow/core/utils/date_formatter.dart';
import 'package:flow/features/calendar/data/models/calendar_event.dart';
import 'package:flow/features/calendar/data/providers/event_provider.dart';
import 'package:flow/features/calendar/presentation/widgets/event_edit_sheet.dart';
import 'package:flow/features/calendar/presentation/widgets/series_scope_dialog.dart';
import 'package:flow/features/people/data/providers/person_notifier.dart';
import 'package:flow/features/people/presentation/widgets/register_visit_sheet.dart';
import 'package:flow/shared/widgets/app_banner.dart';
import 'package:flow/shared/widgets/confirmation_dialog.dart';

/// Bottom sheet showing the details of a calendar event with the actions
/// available depending on its status (pending → editable, completed → view-only).
class EventDetailSheet extends ConsumerWidget {
  const EventDetailSheet({super.key, required this.event});

  final CalendarEvent event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isPending = event.status == EventStatus.pending;
    final isRecurring = event.seriesId != null;

    final personAsync = ref.watch(personByIdProvider(event.personId));

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Person header
            personAsync.when(
              data: (person) => Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: colorScheme.primaryContainer,
                    child: Icon(
                      person?.isBibleStudy == true
                          ? Icons.menu_book
                          : Icons.person,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          person?.name ?? 'Persona desconocida',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (person?.isBibleStudy == true)
                          Text(
                            'Curso bíblico',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.primary,
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('Error: $e'),
            ),
            const SizedBox(height: 20),

            // Date + time
            _DetailRow(
              icon: Icons.calendar_today,
              label: 'Fecha',
              value: DateFormatter.formatWithDayOfWeek(event.date),
            ),
            if (event.time != null) ...[
              const SizedBox(height: 8),
              _DetailRow(
                icon: Icons.access_time,
                label: 'Hora',
                value:
                    '${event.time!.hour.toString().padLeft(2, '0')}:${event.time!.minute.toString().padLeft(2, '0')}',
              ),
            ],

            if (event.notes != null && event.notes!.isNotEmpty) ...[
              const SizedBox(height: 8),
              _DetailRow(
                icon: Icons.notes_outlined,
                label: 'Notas',
                value: event.notes!,
                multiline: true,
              ),
            ],

            const SizedBox(height: 12),
            // Status / recurrence chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                  avatar: Icon(
                    isPending ? Icons.schedule : Icons.check_circle,
                    size: 18,
                    color: isPending
                        ? colorScheme.primary
                        : colorScheme.tertiary,
                  ),
                  label: Text(isPending ? 'Programado' : 'Completado'),
                ),
                if (isRecurring && event.recurrenceWeeks != null)
                  Chip(
                    avatar: const Icon(Icons.repeat, size: 18),
                    label: Text(
                      event.recurrenceWeeks == 1
                          ? 'Cada semana'
                          : 'Cada ${event.recurrenceWeeks} semanas',
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 24),

            if (isPending) ...[
              // Primary CTA: turn into a visit
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => _markAsVisited(context, ref),
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Marcar como visitada'),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _editEvent(context, ref),
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('Editar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _deleteEvent(context, ref),
                      icon: Icon(Icons.delete_outline,
                          color: colorScheme.error),
                      label: Text(
                        'Eliminar',
                        style: TextStyle(color: colorScheme.error),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ---------- actions ----------

  Future<void> _markAsVisited(BuildContext context, WidgetRef ref) async {
    final eventId = event.id;
    if (eventId == null) return;

    // Important: keep this sheet mounted while the visit sheet is open.
    // Popping first invalidates `ref`, and the onVisitCreated callback
    // needs it to mark the event as completed. We pop only after the
    // visit sheet returns.
    final navigator = Navigator.of(context);
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetCtx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(sheetCtx).viewInsets.bottom,
        ),
        child: RegisterVisitSheet(
          personId: event.personId,
          prefilledDate: event.date,
          onVisitCreated: (visit) async {
            final visitId = visit.id;
            if (visitId == null) return;
            await ref.read(eventNotifierProvider.notifier).markCompleted(
                  eventId: eventId,
                  visitId: visitId,
                );
          },
        ),
      ),
    );
    if (navigator.canPop()) navigator.pop();
  }

  Future<void> _editEvent(BuildContext context, WidgetRef ref) async {
    EventEditMode mode = EventEditMode.editInstance;
    if (event.seriesId != null) {
      final scope = await showSeriesScopeDialog(
        context,
        title: 'Editar visita',
      );
      if (scope == null) return;
      mode = scope == SeriesScope.thisInstance
          ? EventEditMode.editInstance
          : EventEditMode.editSeries;
    }

    if (!context.mounted) return;
    Navigator.of(context).pop(); // close detail sheet first

    await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => EventEditSheet(
        mode: mode,
        initialEvent: event,
      ),
    );
  }

  Future<void> _deleteEvent(BuildContext context, WidgetRef ref) async {
    if (event.seriesId == null) {
      final ok = await ConfirmationDialog.show(
        context,
        title: 'Eliminar visita',
        message: 'Esta acción no se puede deshacer.',
        confirmText: 'Eliminar',
        isDestructive: true,
      );
      if (!ok || !context.mounted) return;
      await ref
          .read(eventNotifierProvider.notifier)
          .deleteInstance(event.id!);
      if (context.mounted) {
        Navigator.of(context).pop();
        AppBanner.showSuccess(context, 'Visita eliminada');
      }
      return;
    }

    final scope = await showSeriesScopeDialog(
      context,
      title: 'Eliminar visita',
      confirmTextSeries: 'Eliminar toda la serie',
      isDestructive: true,
    );
    if (scope == null || !context.mounted) return;

    final notifier = ref.read(eventNotifierProvider.notifier);
    if (scope == SeriesScope.thisInstance) {
      await notifier.deleteInstance(event.id!);
      if (context.mounted) {
        Navigator.of(context).pop();
        AppBanner.showSuccess(context, 'Visita eliminada');
      }
    } else {
      final removed = await notifier.deleteSeriesFrom(
        seriesId: event.seriesId!,
        fromDate: event.date,
      );
      if (context.mounted) {
        Navigator.of(context).pop();
        AppBanner.showSuccess(
          context,
          'Eliminadas $removed visitas de la serie',
        );
      }
    }
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.multiline = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool multiline;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Row(
      crossAxisAlignment: multiline
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 20, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(value, style: theme.textTheme.bodyLarge),
            ],
          ),
        ),
      ],
    );
  }
}
