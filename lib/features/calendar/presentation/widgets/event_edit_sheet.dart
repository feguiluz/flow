import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flow/core/utils/date_formatter.dart';
import 'package:flow/features/calendar/data/models/calendar_event.dart';
import 'package:flow/features/calendar/data/providers/event_provider.dart';
import 'package:flow/features/people/data/providers/person_notifier.dart';
import 'package:flow/shared/models/person.dart';
import 'package:flow/shared/widgets/app_banner.dart';

/// Mode the [EventEditSheet] is opened in.
enum EventEditMode {
  /// Brand-new event (puntual or series).
  create,

  /// Editing a single occurrence — fields freely editable, no series propagation.
  editInstance,

  /// Editing all future occurrences of a series — date is locked.
  editSeries,
}

/// Bottom sheet to create or edit a calendar event.
class EventEditSheet extends ConsumerStatefulWidget {
  const EventEditSheet({
    super.key,
    required this.mode,
    this.initialEvent,
    this.initialDate,
    this.initialPersonId,
  });

  final EventEditMode mode;

  /// Required when editing.
  final CalendarEvent? initialEvent;

  /// Default day for create mode (typically the day the user tapped).
  final DateTime? initialDate;

  /// Default person for create mode (e.g. when launched from a person detail).
  final int? initialPersonId;

  @override
  ConsumerState<EventEditSheet> createState() => _EventEditSheetState();
}

enum _RecurrenceChoice { once, weekly, biweekly }

class _EventEditSheetState extends ConsumerState<EventEditSheet> {
  final _formKey = GlobalKey<FormState>();

  int? _personId;
  late DateTime _date;
  TimeOfDay? _time;
  late TextEditingController _notesController;
  late _RecurrenceChoice _recurrence;
  late DateTime _recurrenceEndDate;
  bool _saving = false;

  bool get _isEditing => widget.mode != EventEditMode.create;
  bool get _dateLocked => widget.mode == EventEditMode.editSeries;
  bool get _personLocked => widget.mode == EventEditMode.editSeries;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialEvent;
    _personId = initial?.personId ?? widget.initialPersonId;
    _date = initial?.date ?? widget.initialDate ?? DateTime.now();
    _time = initial?.time;
    _notesController = TextEditingController(text: initial?.notes ?? '');

    _recurrence = switch (initial?.recurrenceWeeks) {
      1 => _RecurrenceChoice.weekly,
      2 => _RecurrenceChoice.biweekly,
      _ => _RecurrenceChoice.once,
    };
    _recurrenceEndDate =
        initial?.recurrenceEndDate ?? _date.add(const Duration(days: 7 * 12));
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  // ---------- pickers ----------

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date.isBefore(now.subtract(const Duration(days: 365 * 5)))
          ? now
          : _date,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
      helpText: 'Fecha de la visita',
    );
    if (picked != null) {
      setState(() {
        _date = picked;
        if (_recurrenceEndDate.isBefore(_date)) {
          _recurrenceEndDate = _date.add(const Duration(days: 7 * 12));
        }
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? const TimeOfDay(hour: 18, minute: 0),
      helpText: 'Hora de la visita',
    );
    if (picked != null) {
      setState(() => _time = picked);
    }
  }

  Future<void> _pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _recurrenceEndDate.isBefore(_date)
          ? _date.add(const Duration(days: 7 * 12))
          : _recurrenceEndDate,
      firstDate: _date,
      lastDate: _date.add(const Duration(days: 365 * 2)),
      helpText: 'Última fecha de la serie',
    );
    if (picked != null) {
      setState(() => _recurrenceEndDate = picked);
    }
  }

  // ---------- save ----------

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_personId == null) {
      AppBanner.showError(context, 'Selecciona una persona');
      return;
    }

    setState(() => _saving = true);
    try {
      final notifier = ref.read(eventNotifierProvider.notifier);
      final notes = _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim();

      switch (widget.mode) {
        case EventEditMode.create:
          if (_recurrence == _RecurrenceChoice.once) {
            await notifier.createSingle(
              personId: _personId!,
              date: _date,
              time: _time,
              notes: notes,
            );
            if (mounted) {
              AppBanner.showSuccess(context, 'Visita programada');
            }
          } else {
            final weeks = _recurrence == _RecurrenceChoice.weekly ? 1 : 2;
            final created = await notifier.createSeries(
              personId: _personId!,
              startDate: _date,
              time: _time,
              notes: notes,
              weeks: weeks,
              endDate: _recurrenceEndDate,
            );
            if (mounted) {
              AppBanner.showSuccess(
                context,
                'Serie creada con $created ocurrencia${created == 1 ? '' : 's'}',
              );
            }
          }
          break;

        case EventEditMode.editInstance:
          final original = widget.initialEvent!;
          final updated = original.copyWith(
            personId: _personId!,
            date: _date,
            time: _time,
            notes: notes,
          );
          await notifier.editInstance(updated);
          if (mounted) {
            AppBanner.showSuccess(context, 'Visita actualizada');
          }
          break;

        case EventEditMode.editSeries:
          final original = widget.initialEvent!;
          final weeks = switch (_recurrence) {
            _RecurrenceChoice.weekly => 1,
            _RecurrenceChoice.biweekly => 2,
            _RecurrenceChoice.once => null,
          };
          final template = original.copyWith(
            personId: original.personId, // locked
            time: _time,
            notes: notes,
            recurrenceWeeks: weeks,
            recurrenceEndDate: weeks == null ? null : _recurrenceEndDate,
          );
          await notifier.editSeriesFrom(
            seriesId: original.seriesId!,
            fromDate: original.date,
            template: template,
          );
          if (mounted) {
            AppBanner.showSuccess(context, 'Serie actualizada');
          }
          break;
      }

      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        AppBanner.showError(context, 'No se pudo guardar: $e');
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  // ---------- build ----------

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final peopleAsync = ref.watch(personNotifierProvider);

    final title = switch (widget.mode) {
      EventEditMode.create => 'Programar visita',
      EventEditMode.editInstance => 'Editar visita',
      EventEditMode.editSeries => 'Editar serie',
    };

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: _saving ? null : () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Person
              peopleAsync.when(
                data: (people) => _PersonDropdown(
                  people: people,
                  value: _personId,
                  enabled: !_saving && !_personLocked,
                  onChanged: (id) => setState(() => _personId = id),
                ),
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text('Error: $e'),
              ),
              const SizedBox(height: 16),

              // Date
              _RowTile(
                icon: Icons.calendar_today,
                label: 'Fecha',
                value: DateFormatter.formatWithDayOfWeek(_date),
                onTap: _saving || _dateLocked ? null : _pickDate,
                trailing: _dateLocked
                    ? Icon(Icons.lock_outline,
                        color: colorScheme.onSurfaceVariant, size: 20)
                    : null,
              ),
              const SizedBox(height: 12),

              // Time
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: _time != null,
                title: const Text('Asignar hora'),
                subtitle: _time != null
                    ? Text(_formatTime(_time!))
                    : const Text('Sin hora específica'),
                onChanged: _saving
                    ? null
                    : (v) async {
                        if (v) {
                          await _pickTime();
                          if (_time == null) {
                            // user dismissed picker — keep switch off
                            setState(() {});
                          }
                        } else {
                          setState(() => _time = null);
                        }
                      },
              ),
              if (_time != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: _saving ? null : _pickTime,
                    icon: const Icon(Icons.access_time),
                    label: Text('Cambiar hora (${_formatTime(_time!)})'),
                  ),
                ),
              const SizedBox(height: 12),

              // Notes
              TextFormField(
                controller: _notesController,
                enabled: !_saving,
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Notas (opcional)',
                  hintText: 'Recordatorio, tema a tratar…',
                  prefixIcon: Icon(Icons.notes_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Recurrence
              Text(
                'REPETICIÓN',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              SegmentedButton<_RecurrenceChoice>(
                segments: const [
                  ButtonSegment(
                    value: _RecurrenceChoice.once,
                    label: Text('Una vez'),
                  ),
                  ButtonSegment(
                    value: _RecurrenceChoice.weekly,
                    label: Text('Cada semana'),
                  ),
                  ButtonSegment(
                    value: _RecurrenceChoice.biweekly,
                    label: Text('Cada 2 sem.'),
                  ),
                ],
                selected: {_recurrence},
                onSelectionChanged: (_saving || _isInstanceModeRecurrenceLocked)
                    ? null
                    : (s) => setState(() => _recurrence = s.first),
              ),
              if (_isInstanceModeRecurrenceLocked)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    'La frecuencia se cambia desde "Editar serie".',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              if (_recurrence != _RecurrenceChoice.once) ...[
                const SizedBox(height: 12),
                _RowTile(
                  icon: Icons.event_repeat,
                  label: 'Hasta',
                  value: DateFormatter.formatWithDayOfWeek(_recurrenceEndDate),
                  onTap: _saving ? null : _pickEndDate,
                ),
              ],
              const SizedBox(height: 24),

              // Save
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(_isEditing ? 'Actualizar' : 'Guardar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// In editInstance mode you can change date/time/notes/person of just
  /// this row, but changing the recurrence rule on a single instance has
  /// no meaning — that's a series-level change.
  bool get _isInstanceModeRecurrenceLocked =>
      widget.mode == EventEditMode.editInstance;

  String _formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}

class _PersonDropdown extends StatelessWidget {
  const _PersonDropdown({
    required this.people,
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  final List<Person> people;
  final int? value;
  final bool enabled;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    if (people.isEmpty) {
      return InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Persona',
          prefixIcon: Icon(Icons.person_outline),
          border: OutlineInputBorder(),
        ),
        child: Text(
          'No tienes personas registradas todavía',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      );
    }

    return DropdownButtonFormField<int>(
      value: value,
      isExpanded: true,
      decoration: const InputDecoration(
        labelText: 'Persona',
        prefixIcon: Icon(Icons.person_outline),
        border: OutlineInputBorder(),
      ),
      items: people
          .map(
            (p) => DropdownMenuItem<int>(
              value: p.id,
              child: Row(
                children: [
                  Icon(
                    p.isBibleStudy ? Icons.menu_book : Icons.person,
                    size: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      p.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
      onChanged: enabled ? onChanged : null,
      validator: (v) => v == null ? 'Selecciona una persona' : null,
    );
  }
}

class _RowTile extends StatelessWidget {
  const _RowTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.outline),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: colorScheme.primary),
            const SizedBox(width: 16),
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
                  const SizedBox(height: 4),
                  Text(value, style: theme.textTheme.titleMedium),
                ],
              ),
            ),
            if (trailing != null)
              trailing!
            else if (onTap != null)
              Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
