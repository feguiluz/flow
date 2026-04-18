import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flow/shared/models/goal.dart';
import 'package:flow/shared/widgets/app_banner.dart';
import 'package:flow/features/home/data/providers/goal_notifier.dart';
import 'package:flow/features/home/data/providers/month_summary_provider.dart';

/// Dialog for publishers to set auxiliary pioneer goal (15h or 30h)
/// Only shown for publishers, not for regular/special pioneers
class AuxiliaryGoalDialog extends ConsumerStatefulWidget {
  const AuxiliaryGoalDialog({
    super.key,
    this.currentGoal,
    required this.year,
    required this.month,
  });

  final Goal? currentGoal;
  final int year;
  final int month;

  @override
  ConsumerState<AuxiliaryGoalDialog> createState() =>
      _AuxiliaryGoalDialogState();
}

class _AuxiliaryGoalDialogState extends ConsumerState<AuxiliaryGoalDialog> {
  GoalType? _selectedGoalType;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Start with current goal or null (no auxiliary goal)
    _selectedGoalType = widget.currentGoal?.goalType;
  }

  // Note: 15 hours is now available in ALL months (not just special months)
  // This changed in recent years - any publisher can be auxiliary pioneer with 15h or 30h

  Future<void> _saveGoal() async {
    if (_selectedGoalType == null) {
      // Remove goal (publisher without auxiliary goal)
      await _removeGoal();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final notifier =
          ref.read(goalNotifierProvider(widget.year, widget.month).notifier);

      final targetHours =
          _selectedGoalType == GoalType.auxiliaryPioneer15 ? 15.0 : 30.0;

      final goal = Goal(
        id: widget.currentGoal?.id, // Keep existing ID if updating
        year: widget.year,
        month: widget.month,
        goalType: _selectedGoalType!,
        targetHours: targetHours,
        createdAt: widget.currentGoal?.createdAt ?? DateTime.now(),
      );

      await notifier.setGoal(goal);

      // Invalidate month summary to refresh UI
      ref.invalidate(monthSummaryProvider);

      if (!mounted) return;

      Navigator.of(context).pop();

      AppBanner.showSuccess(context, 'Meta auxiliar establecida');
    } catch (e) {
      if (!mounted) return;

      AppBanner.showError(context, 'Error al guardar meta: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _removeGoal() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final notifier =
          ref.read(goalNotifierProvider(widget.year, widget.month).notifier);
      await notifier.deleteGoal(widget.year, widget.month);

      // Invalidate month summary to refresh UI
      ref.invalidate(monthSummaryProvider);

      if (!mounted) return;

      Navigator.of(context).pop();

      AppBanner.showSuccess(context, 'Meta auxiliar eliminada');
    } catch (e) {
      if (!mounted) return;

      AppBanner.showError(context, 'Error al eliminar meta: $e');
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

    return AlertDialog(
      title: const Text('Meta de Precursor Auxiliar'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Como publicador, puedes establecer una meta de precursor auxiliar para este mes.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),

          // No goal option
          RadioListTile<GoalType?>(
            title: const Text('Sin meta auxiliar'),
            subtitle: const Text('Solo participación este mes'),
            value: null,
            groupValue: _selectedGoalType,
            onChanged: (value) {
              setState(() {
                _selectedGoalType = value;
              });
            },
          ),

          const Divider(),

          // 30 hours option
          RadioListTile<GoalType>(
            title: const Text('Precursor Auxiliar - 30 horas'),
            subtitle: const Text('Meta estándar'),
            value: GoalType.auxiliaryPioneer30,
            groupValue: _selectedGoalType,
            onChanged: (value) {
              setState(() {
                _selectedGoalType = value;
              });
            },
          ),

          const Divider(),

          // 15 hours option (available all year)
          RadioListTile<GoalType>(
            title: const Text('Precursor Auxiliar - 15 horas'),
            subtitle: const Text('Disponible todo el año'),
            value: GoalType.auxiliaryPioneer15,
            groupValue: _selectedGoalType,
            onChanged: (value) {
              setState(() {
                _selectedGoalType = value;
              });
            },
          ),

          const SizedBox(height: 16),

          // Warning if trying to remove existing goal
          if (widget.currentGoal != null && _selectedGoalType == null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_outlined,
                    color: colorScheme.onErrorContainer,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Al eliminar la meta, no podrás registrar horas este mes',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _saveGoal,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Guardar'),
        ),
      ],
    );
  }
}
