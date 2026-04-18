import 'package:flutter/material.dart';

import 'package:flow/core/utils/date_formatter.dart';

/// Step 4: Birth date selection
class BirthdateStep extends StatelessWidget {
  const BirthdateStep({
    super.key,
    this.selectedDate,
    required this.onChanged,
  });

  final DateTime? selectedDate;
  final ValueChanged<DateTime> onChanged;

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final initialDate =
        selectedDate ?? DateTime(now.year - 30, now.month, now.day);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: now,
      helpText: 'Selecciona tu fecha de nacimiento',
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
    );

    if (pickedDate != null) {
      onChanged(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Icon(
            Icons.cake_outlined,
            size: 64,
            color: colorScheme.primary,
          ),
          const SizedBox(height: 24),

          // Title
          Text(
            '¿Cuál es tu fecha de nacimiento?',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // Subtitle
          Text(
            'Necesitamos tu fecha de nacimiento para calcular correctamente las horas de servicio en caso de ser precursor especial (mujeres de 40 años o más tienen una meta reducida)',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),

          // Date selector card
          Card(
            elevation: selectedDate != null ? 4 : 1,
            color: selectedDate != null
                ? colorScheme.primaryContainer
                : colorScheme.surface,
            child: InkWell(
              onTap: () => _selectDate(context),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    // Calendar icon
                    Icon(
                      Icons.calendar_today,
                      size: 48,
                      color: selectedDate != null
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 24),

                    // Date display
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Fecha de nacimiento',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: selectedDate != null
                                  ? colorScheme.onPrimaryContainer
                                  : colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            selectedDate != null
                                ? DateFormatter.formatForDisplay(selectedDate!)
                                : 'Toca para seleccionar',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: selectedDate != null
                                  ? colorScheme.onPrimaryContainer
                                  : colorScheme.onSurfaceVariant,
                            ),
                          ),
                          if (selectedDate != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              _calculateAge(selectedDate!) == 1
                                  ? '${_calculateAge(selectedDate!)} año'
                                  : '${_calculateAge(selectedDate!)} años',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    // Arrow icon
                    Icon(
                      Icons.arrow_forward_ios,
                      color: selectedDate != null
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;

    // Adjust if birthday hasn't occurred this year yet
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    return age;
  }
}
