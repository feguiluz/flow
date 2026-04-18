import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/user_profile_service.dart';
import '../../../../shared/models/goal.dart';
import '../../../../shared/widgets/app_banner.dart';
import '../../data/providers/goal_notifier.dart';

/// Dialog for selecting monthly goal type
class GoalSelectorDialog extends ConsumerStatefulWidget {
  const GoalSelectorDialog({
    super.key,
    this.currentGoal,
    required this.year,
    required this.month,
  });

  final Goal? currentGoal;
  final int year;
  final int month;

  @override
  ConsumerState<GoalSelectorDialog> createState() => _GoalSelectorDialogState();
}

class _GoalSelectorDialogState extends ConsumerState<GoalSelectorDialog> {
  late GoalType _selectedGoalType;
  bool _enable15Hours = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedGoalType = widget.currentGoal?.goalType ?? GoalType.publisher;

    // If current goal is 15h auxiliary, enable the checkbox
    if (_selectedGoalType == GoalType.auxiliaryPioneer15) {
      _enable15Hours = true;
    }
  }

  bool get _isSpecialMonth {
    // March (3) and April (4) are special months
    return widget.month == 3 || widget.month == 4;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Seleccionar meta',
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
          const SizedBox(height: 16),

          // Goal options
          SingleChildScrollView(
            child: Column(
              children: [
                // Publisher (no hours)
                _buildGoalOption(
                  GoalType.publisher,
                  'Publicador',
                  'Solo participación',
                ),
                const Divider(),

                // Auxiliary Pioneer
                if (_isSpecialMonth) ...[
                  // Special months: Show both 15h and 30h options
                  _buildGoalOption(
                    GoalType.auxiliaryPioneer15,
                    'Precursor Auxiliar',
                    '15 horas (mes especial)',
                  ),
                  const Divider(),
                  _buildGoalOption(
                    GoalType.auxiliaryPioneer30,
                    'Precursor Auxiliar',
                    '30 horas',
                  ),
                ] else ...[
                  // Regular months: Show 30h with optional 15h checkbox
                  _buildGoalOption(
                    GoalType.auxiliaryPioneer30,
                    'Precursor Auxiliar',
                    '30 horas',
                  ),
                  if (_selectedGoalType == GoalType.auxiliaryPioneer30)
                    Padding(
                      padding: const EdgeInsets.only(left: 56, top: 8),
                      child: CheckboxListTile(
                        value: _enable15Hours,
                        onChanged: (value) {
                          setState(() {
                            _enable15Hours = value ?? false;
                            if (_enable15Hours) {
                              _selectedGoalType = GoalType.auxiliaryPioneer15;
                            }
                          });
                        },
                        title: const Text('Mes con visita del superintendente'),
                        subtitle:
                            const Text('Permite establecer meta de 15 horas'),
                        controlAffinity: ListTileControlAffinity.leading,
                        dense: true,
                      ),
                    ),
                ],
                const Divider(),

                // Regular Pioneer
                _buildGoalOption(
                  GoalType.regularPioneer,
                  'Precursor Regular',
                  '50 horas',
                ),
                const Divider(),

                // Special Pioneer / Missionary
                _buildGoalOption(
                  GoalType.specialPioneer,
                  'Precursor Especial / Misionero',
                  _getSpecialPioneerHoursText(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Action buttons
          Row(
            children: [
              // Delete button (only if goal exists)
              if (widget.currentGoal != null)
                Expanded(
                  child: TextButton.icon(
                    onPressed: _isLoading ? null : _deleteGoal,
                    icon: Icon(
                      Icons.delete_outline,
                      color: colorScheme.error,
                    ),
                    label: Text(
                      'Eliminar',
                      style: TextStyle(color: colorScheme.error),
                    ),
                  ),
                ),

              if (widget.currentGoal != null) const SizedBox(width: 8),

              // Save button
              Expanded(
                flex: 2,
                child: FilledButton(
                  onPressed: _isLoading ? null : _saveGoal,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Guardar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGoalOption(GoalType type, String title, String subtitle) {
    return RadioListTile<GoalType>(
      value: type,
      groupValue: _selectedGoalType,
      onChanged: _isLoading
          ? null
          : (value) {
              setState(() {
                _selectedGoalType = value!;

                // Reset 15h checkbox if switching away from auxiliary pioneer
                if (value != GoalType.auxiliaryPioneer30 &&
                    value != GoalType.auxiliaryPioneer15) {
                  _enable15Hours = false;
                }

                // If enabling 15h, switch to 15h type
                if (value == GoalType.auxiliaryPioneer30 && _enable15Hours) {
                  _selectedGoalType = GoalType.auxiliaryPioneer15;
                }
              });
            },
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }

  String _getSpecialPioneerHoursText() {
    final userProfile = UserProfileService.instance;
    final gender = userProfile.getUserGender();
    final age = userProfile.getUserAge();

    if (gender == null || age == null) {
      return '90-100 horas (según edad/género)';
    }

    if (gender == 'male') {
      return '100 horas';
    }

    // Female
    if (age >= 40) {
      return '90 horas (mujer 40+)';
    } else {
      return '100 horas (mujer <40)';
    }
  }

  Future<void> _saveGoal() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Calculate target hours
      final targetHours = UserProfileService.instance.getTargetHoursForGoal(
        _selectedGoalType,
      );

      // Create goal
      final goal = Goal(
        id: widget.currentGoal?.id,
        year: widget.year,
        month: widget.month,
        goalType: _selectedGoalType,
        targetHours: targetHours,
        createdAt: widget.currentGoal?.createdAt ?? DateTime.now(),
      );

      // Save to database
      await ref
          .read(goalNotifierProvider(widget.year, widget.month).notifier)
          .setGoal(goal);

      if (mounted) {
        AppBanner.showSuccess(
          context,
          widget.currentGoal != null ? 'Meta actualizada' : 'Meta establecida',
        );
        Navigator.of(context).pop();
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

  Future<void> _deleteGoal() async {
    // Confirm deletion
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar meta'),
        content: const Text(
          '¿Estás seguro de que deseas eliminar esta meta? '
          'Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await ref
          .read(goalNotifierProvider(widget.year, widget.month).notifier)
          .deleteGoal(widget.year, widget.month);

      if (mounted) {
        AppBanner.showSuccess(context, 'Meta eliminada');
        Navigator.of(context).pop();
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
}
