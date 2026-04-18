import 'package:flutter/material.dart';

import 'package:flow/shared/models/gender.dart';

/// Step 3: Gender selection
class GenderStep extends StatelessWidget {
  const GenderStep({
    super.key,
    this.selectedGender,
    required this.onChanged,
  });

  final Gender? selectedGender;
  final ValueChanged<Gender> onChanged;

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
            Icons.wc_outlined,
            size: 64,
            color: colorScheme.primary,
          ),
          const SizedBox(height: 24),

          // Title
          Text(
            '¿Cuál es tu género?',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // Subtitle
          Text(
            'Necesitamos esta información para calcular correctamente las horas de servicio en caso de ser precursor especial',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),

          // Option cards
          ...Gender.values.map((gender) {
            final isSelected = selectedGender == gender;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(
                elevation: isSelected ? 4 : 1,
                color: isSelected
                    ? colorScheme.primaryContainer
                    : colorScheme.surface,
                child: InkWell(
                  onTap: () => onChanged(gender),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Radio indicator
                        Radio<Gender>(
                          value: gender,
                          groupValue: selectedGender,
                          onChanged: (value) {
                            if (value != null) onChanged(value);
                          },
                        ),
                        const SizedBox(width: 12),

                        // Icon
                        Icon(
                          gender == Gender.male ? Icons.male : Icons.female,
                          size: 32,
                          color: isSelected
                              ? colorScheme.onPrimaryContainer
                              : colorScheme.onSurface,
                        ),
                        const SizedBox(width: 12),

                        // Text
                        Text(
                          gender.displayName,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? colorScheme.onPrimaryContainer
                                : colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
