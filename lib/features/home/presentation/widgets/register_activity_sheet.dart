import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/models/activity.dart';
import '../../data/providers/activity_notifier.dart';

/// Bottom sheet for registering or editing activity hours
class RegisterActivitySheet extends ConsumerStatefulWidget {
  const RegisterActivitySheet({
    super.key,
    this.activity,
  });

  /// If provided, the sheet will be in edit mode
  final Activity? activity;

  @override
  ConsumerState<RegisterActivitySheet> createState() =>
      _RegisterActivitySheetState();
}

class _RegisterActivitySheetState extends ConsumerState<RegisterActivitySheet> {
  final _formKey = GlobalKey<FormState>();
  late DateTime _selectedDate;
  late TextEditingController _hoursController;
  late TextEditingController _notesController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.activity?.date ?? DateTime.now();
    _hoursController = TextEditingController(
      text: widget.activity?.hours.toString() ?? '',
    );
    _notesController = TextEditingController(
      text: widget.activity?.notes ?? '',
    );
  }

  @override
  void dispose() {
    _hoursController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveActivity() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final hours = double.parse(_hoursController.text.trim());
      final notes = _notesController.text.trim();

      final activity = Activity(
        id: widget.activity?.id,
        date: _selectedDate,
        hours: hours,
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.activity == null
                  ? 'Actividad registrada'
                  : 'Actividad actualizada',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
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

            // Hours input
            TextFormField(
              controller: _hoursController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              decoration: InputDecoration(
                labelText: 'Horas',
                hintText: '0.0',
                prefixIcon: const Icon(Icons.access_time),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: Validators.validateHours,
              enabled: !_isLoading,
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
