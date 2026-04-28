import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/maps_launcher.dart';
import '../../../../core/utils/phone_formatter.dart';
import '../../../../shared/models/person.dart';
import '../../../../shared/widgets/app_banner.dart';
import '../../../../shared/widgets/confirmation_dialog.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../calendar/data/models/calendar_event.dart';
import '../../../calendar/data/providers/event_provider.dart';
import '../../../calendar/presentation/widgets/event_detail_sheet.dart';
import '../../../calendar/presentation/widgets/event_edit_sheet.dart';
import '../../data/providers/person_notifier.dart';
import '../../data/providers/visit_notifier.dart';
import '../widgets/add_person_sheet.dart';
import '../widgets/register_visit_sheet.dart';
import '../widgets/visit_item.dart';

/// Person detail screen showing visit history and actions
class PersonDetailScreen extends ConsumerWidget {
  const PersonDetailScreen({
    super.key,
    required this.person,
  });

  final Person person;

  Future<void> _showEditSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
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
          child: AddPersonSheet(person: person),
        ),
      ),
    );
  }

  Future<void> _showRegisterVisitSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
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
          child: RegisterVisitSheet(personId: person.id!),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Eliminar persona',
      message: '¿Estás seguro de que deseas eliminar a ${person.name}? '
          'Esto también eliminará todas las revisitas registradas. '
          'Esta acción no se puede deshacer.',
      confirmText: 'Eliminar',
      isDestructive: true,
    );

    if (confirmed == true) {
      try {
        await ref
            .read(personNotifierProvider.notifier)
            .deletePerson(person.id!);

        if (context.mounted) {
          AppBanner.showSuccess(context, 'Persona eliminada');
          Navigator.of(context).pop(); // Go back to people list
        }
      } catch (e) {
        if (context.mounted) {
          AppBanner.showError(context, 'Error al eliminar: ${e.toString()}');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Watch visits for this person
    final visitsAsync = ref.watch(visitsByPersonProvider(person.id!));

    return Scaffold(
      appBar: AppBar(
        title: Text(person.name),
        actions: [
          // Edit button
          IconButton(
            onPressed: () => _showEditSheet(context),
            icon: const Icon(Icons.edit),
            tooltip: 'Editar',
          ),
          // Delete button
          IconButton(
            onPressed: () => _confirmDelete(context, ref),
            icon: Icon(
              Icons.delete,
              color: colorScheme.error,
            ),
            tooltip: 'Eliminar',
          ),
        ],
      ),
      body: Column(
        children: [
          // Person info card
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type badge
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: person.isBibleStudy
                              ? colorScheme.primaryContainer
                              : colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              person.isBibleStudy
                                  ? Icons.book
                                  : Icons.person_outline,
                              size: 16,
                              color: person.isBibleStudy
                                  ? colorScheme.onPrimaryContainer
                                  : colorScheme.onSecondaryContainer,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              person.isBibleStudy
                                  ? 'Curso bíblico'
                                  : 'Persona interesada',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: person.isBibleStudy
                                    ? colorScheme.onPrimaryContainer
                                    : colorScheme.onSecondaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Contact info
                  if (person.phone != null) ...[
                    _buildInfoRow(
                      context,
                      Icons.phone_outlined,
                      'Teléfono',
                      formatMexicanPhone(person.phone!),
                    ),
                    const SizedBox(height: 12),
                  ],
                  if (person.address != null) ...[
                    _buildInfoRow(
                      context,
                      Icons.location_on_outlined,
                      'Dirección',
                      person.address!,
                      trailing: IconButton(
                        tooltip: 'Cómo llegar (Google Maps)',
                        icon: const Icon(Icons.directions),
                        color: colorScheme.primary,
                        onPressed: () => _openDirections(context),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  if (person.notes != null) ...[
                    _buildInfoRow(
                      context,
                      Icons.notes_outlined,
                      'Notas',
                      person.notes!,
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Upcoming events
          _UpcomingEventsSection(personId: person.id!),

          // Visit history header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Historial de revisitas',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _showRegisterVisitSheet(context),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Registrar revisita'),
                ),
              ],
            ),
          ),

          // Visit list
          Expanded(
            child: visitsAsync.when(
              data: (visits) {
                if (visits.isEmpty) {
                  return const EmptyState(
                    icon: Icons.event_note_outlined,
                    message: 'No hay revisitas registradas',
                    actionLabel: null,
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: visits.length,
                  itemBuilder: (context, index) {
                    final visit = visits[index];
                    return VisitItem(
                      key: ValueKey(visit.id),
                      visit: visit,
                      personId: person.id!,
                    );
                  },
                );
              },
              loading: () => const LoadingIndicator(),
              error: (error, stack) => ErrorView(
                message: error.toString(),
                onRetry: () => ref.refresh(visitsByPersonProvider(person.id!)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value, {
    Widget? trailing,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: colorScheme.onSurfaceVariant,
        ),
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
              Text(
                value,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        if (trailing != null) trailing,
      ],
    );
  }

  Future<void> _openDirections(BuildContext context) async {
    final result = await const MapsLauncher().openDirectionsTo(person);
    if (!context.mounted) return;
    switch (result) {
      case MapsLaunchResult.launched:
        break;
      case MapsLaunchResult.noAddress:
        AppBanner.showError(
            context, 'Esta persona no tiene dirección guardada');
      case MapsLaunchResult.failed:
        AppBanner.showError(context, 'No se pudo abrir Google Maps');
    }
  }
}

/// Compact list of upcoming events for [personId]. Hidden when the person
/// has no future pending events. Includes a CTA to schedule a new event.
class _UpcomingEventsSection extends ConsumerWidget {
  const _UpcomingEventsSection({required this.personId});
  final int personId;

  Future<void> _openCreate(BuildContext context) async {
    await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => EventEditSheet(
        mode: EventEditMode.create,
        initialPersonId: personId,
      ),
    );
  }

  Future<void> _openDetail(BuildContext context, CalendarEvent event) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => EventDetailSheet(event: event),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final upcomingAsync =
        ref.watch(upcomingEventsByPersonProvider(personId));

    return upcomingAsync.maybeWhen(
      data: (events) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Próximas visitas',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => _openCreate(context),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Programar'),
                  ),
                ],
              ),
              if (events.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'No hay visitas programadas',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                )
              else
                SizedBox(
                  height: 112,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: events.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, i) {
                      final e = events[i];
                      return _UpcomingEventChip(
                        event: e,
                        onTap: () => _openDetail(context, e),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _UpcomingEventChip extends StatelessWidget {
  const _UpcomingEventChip({required this.event, required this.onTap});

  final CalendarEvent event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final time = event.time;
    final timeLabel = time != null
        ? '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'
        : 'Sin hora';

    return SizedBox(
      width: 168,
      child: Card(
        color: colorScheme.surfaceContainerHighest,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(Icons.event,
                        size: 18, color: colorScheme.primary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        DateFormatter.getRelativeDate(event.date),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  timeLabel,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                if (event.seriesId != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      children: [
                        Icon(Icons.repeat,
                            size: 14,
                            color: colorScheme.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Text(
                          event.recurrenceWeeks == 1
                              ? 'Cada semana'
                              : 'Cada ${event.recurrenceWeeks} sem.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
