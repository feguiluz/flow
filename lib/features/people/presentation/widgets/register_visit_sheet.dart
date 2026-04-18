import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/models/visit.dart';
import '../../../../shared/widgets/app_banner.dart';
import '../../data/providers/visit_notifier.dart';

/// Bottom sheet for registering or editing a visit
class RegisterVisitSheet extends ConsumerStatefulWidget {
  const RegisterVisitSheet({
    super.key,
    required this.personId,
    this.visit,
  });

  final int personId;

  /// If provided, the sheet will be in edit mode
  final Visit? visit;

  @override
  ConsumerState<RegisterVisitSheet> createState() => _RegisterVisitSheetState();
}

class _RegisterVisitSheetState extends ConsumerState<RegisterVisitSheet> {
  final _formKey = GlobalKey<FormState>();
  late DateTime _selectedDate;
  late TextEditingController _notesController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Use visit date or today
    _selectedDate = widget.visit?.date ?? DateTime.now();
    _notesController = TextEditingController(text: widget.visit?.notes ?? '');
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    // Allow selecting any past date (up to 2 years ago)
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

  Future<void> _saveVisit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final visit = Visit(
        id: widget.visit?.id,
        personId: widget.personId,
        date: _selectedDate,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        createdAt: widget.visit?.createdAt ?? DateTime.now(),
      );

      if (widget.visit == null) {
        // Add new visit
        await ref
            .read(visitNotifierProvider(widget.personId).notifier)
            .addVisit(visit);
        if (mounted) {
          AppBanner.showSuccess(context, 'Revisita registrada');
          Navigator.of(context).pop();
        }
      } else {
        // Update existing visit
        await ref
            .read(visitNotifierProvider(widget.personId).notifier)
            .updateVisit(visit);
        if (mounted) {
          AppBanner.showSuccess(context, 'Revisita actualizada');
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      if (mounted) {
        AppBanner.showError(context, 'Error: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isEditing = widget.visit != null;

    return Padding(
      padding: const EdgeInsets.all(24),
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
                    isEditing ? 'Editar revisita' : 'Registrar revisita',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
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
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: colorScheme.outline,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Fecha',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormatter.getRelativeDate(_selectedDate),
                              style: theme.textTheme.titleMedium,
                            ),
                            Text(
                              DateFormatter.formatForDisplay(_selectedDate),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Notes field
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notas',
                  hintText: '¿Qué se conversó en la revisita?',
                  prefixIcon: Icon(Icons.notes_outlined),
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
                enabled: !_isLoading,
              ),
              const SizedBox(height: 24),

              // Save button
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isLoading ? null : _saveVisit,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(isEditing ? 'Actualizar' : 'Guardar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
