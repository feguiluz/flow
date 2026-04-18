import 'package:flutter/material.dart';

import 'package:flow/shared/models/publisher_type.dart';

/// Step 2: Publisher type selection
class PrivilegeStep extends StatelessWidget {
  const PrivilegeStep({
    super.key,
    this.selectedType,
    required this.onChanged,
  });

  final PublisherType? selectedType;
  final ValueChanged<PublisherType> onChanged;

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
            Icons.workspace_premium_outlined,
            size: 64,
            color: colorScheme.primary,
          ),
          const SizedBox(height: 24),

          // Title
          Text(
            '¿Cuál es tu privilegio?',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // Subtitle
          Text(
            'Selecciona tu situación actual en el servicio',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),

          // Option cards
          ...PublisherType.values.map((type) {
            final isSelected = selectedType == type;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(
                elevation: isSelected ? 4 : 1,
                color: isSelected
                    ? colorScheme.primaryContainer
                    : colorScheme.surface,
                child: InkWell(
                  onTap: () => onChanged(type),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Radio indicator
                        Radio<PublisherType>(
                          value: type,
                          groupValue: selectedType,
                          onChanged: (value) {
                            if (value != null) onChanged(value);
                          },
                        ),
                        const SizedBox(width: 12),

                        // Text content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                type.displayName,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? colorScheme.onPrimaryContainer
                                      : colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                type.description,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: isSelected
                                      ? colorScheme.onPrimaryContainer
                                      : colorScheme.onSurfaceVariant,
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
          }),
        ],
      ),
    );
  }
}
