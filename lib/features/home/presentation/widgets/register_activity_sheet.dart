import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/constants.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/time_formatter.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/models/activity.dart';
import '../../../../shared/providers/database_provider.dart';
import '../../../../shared/widgets/app_banner.dart';
import '../../data/providers/activity_notifier.dart';

/// Bottom sheet for registering or editing activity hours
class RegisterActivitySheet extends ConsumerStatefulWidget {
  const RegisterActivitySheet({
    super.key,
    this.activity,
    this.initialDate,
  });

  /// If provided, the sheet will be in edit mode
  final Activity? activity;

  /// Suggested initial date (e.g., from selected month)
  final DateTime? initialDate;

  @override
  ConsumerState<RegisterActivitySheet> createState() =>
      _RegisterActivitySheetState();
}

class _RegisterActivitySheetState extends ConsumerState<RegisterActivitySheet> {
  final _formKey = GlobalKey<FormState>();
  late DateTime _selectedDate;
  TimeOfDay? _selectedTime; // Time selected with TimePicker
  late TextEditingController _notesController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Use activity date, or initialDate, or today
    _selectedDate =
        widget.activity?.date ?? widget.initialDate ?? DateTime.now();

    // Initialize time from existing activity
    if (widget.activity != null) {
      final hours = TimeFormatter.getHours(widget.activity!.minutes);
      final minutes = TimeFormatter.getMinutes(widget.activity!.minutes);
      _selectedTime = TimeOfDay(hour: hours, minute: minutes);
    }

    _notesController = TextEditingController(
      text: widget.activity?.notes ?? '',
    );
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    // Allow selecting any past date (up to 2 years ago for practical purposes)
    final firstDate = DateTime(now.year - 2, 1, 1);

    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate.isAfter(now) ? now : _selectedDate,
      firstDate: firstDate,
      lastDate: now,
      helpText: 'Seleccionar fecha',
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? const TimeOfDay(hour: 0, minute: 0),
      helpText: 'Seleccionar tiempo',
      hourLabelText: 'Horas',
      minuteLabelText: 'Minutos',
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _saveActivity() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate that time has been selected
    if (_selectedTime == null) {
      AppBanner.showError(context, 'Por favor selecciona el tiempo');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Convert TimeOfDay to total minutes
      final minutes = (_selectedTime!.hour * 60) + _selectedTime!.minute;

      if (minutes == 0) {
        throw FormatException('El tiempo debe ser mayor a 0');
      }

      // Validate that total minutes for this day don't exceed 24 hours
      final activityDao = await ref.read(activityDaoProvider.future);
      final existingMinutes = await activityDao.getTotalMinutesForDate(
        _selectedDate,
        excludeActivityId: widget.activity?.id,
      );

      final totalMinutes = existingMinutes + minutes;
      final maxMinutesPerDay = AppConstants.maxHoursPerDay * 60;

      if (totalMinutes > maxMinutesPerDay) {
        final existingTime =
            TimeFormatter.formatMinutesToHoursMinutes(existingMinutes);
        final newTime = TimeFormatter.formatMinutesToHoursMinutes(minutes);
        final totalTime =
            TimeFormatter.formatMinutesToHoursMinutes(totalMinutes);

        throw FormatException(
          'Este día ya tiene $existingTime registrado. '
          'No puedes agregar $newTime (total: $totalTime). '
          'Máximo permitido: 24h por día.',
        );
      }

      final notes = _notesController.text.trim();

      final activity = Activity(
        id: widget.activity?.id,
        date: _selectedDate,
        minutes: minutes,
        notes: notes.isEmpty ? null : notes,
        createdAt: widget.activity?.createdAt ?? DateTime.now(),
      );

      if (widget.activity == null) {
        await ref.read(activityNotifierProvider.notifier).addActivity(activity);
      } else {
        await ref
            .read(activityNotifierProvider.notifier)
            .updateActivity(activity);
      }

      if (mounted) {
        Navigator.of(context).pop();
        AppBanner.showSuccess(
          context,
          widget.activity == null
              ? 'Actividad registrada'
              : 'Actividad actualizada',
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        AppBanner.showError(context, e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.activity == null
                      ? 'Registrar horas'
                      : 'Editar actividad',
                  style: theme.textTheme.headlineSmall,
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Date selector
            InkWell(
              onTap: _isLoading ? null : () => _selectDate(context),
              borderRadius: BorderRadius.circular(12),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Fecha',
                  prefixIcon: const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  DateFormatter.formatForDisplay(_selectedDate),
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Time selector
            InkWell(
              onTap: _isLoading ? null : () => _selectTime(context),
              borderRadius: BorderRadius.circular(12),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Tiempo',
                  prefixIcon: const Icon(Icons.access_time),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _selectedTime != null
                      ? TimeFormatter.formatMinutesToHoursMinutes(
                          (_selectedTime!.hour * 60) + _selectedTime!.minute,
                        )
                      : 'Seleccionar tiempo',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: _selectedTime != null
                        ? theme.textTheme.bodyLarge?.color
                        : theme.hintColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Notes input
            TextFormField(
              controller: _notesController,
              maxLines: 3,
              maxLength: 500,
              decoration: InputDecoration(
                labelText: 'Notas (opcional)',
                hintText: 'Detalles de la actividad...',
                prefixIcon: const Icon(Icons.notes),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              enabled: !_isLoading,
            ),
            const SizedBox(height: 24),

            // Save button
            FilledButton(
              onPressed: _isLoading ? null : _saveActivity,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colorScheme.onPrimary,
                      ),
                    )
                  : Text(
                      widget.activity == null ? 'Registrar' : 'Actualizar',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
