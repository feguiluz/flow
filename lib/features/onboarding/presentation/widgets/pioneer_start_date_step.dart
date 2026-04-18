import 'package:flutter/material.dart';

import 'package:flow/core/utils/date_formatter.dart';
import 'package:flow/shared/models/publisher_type.dart';
import 'package:flow/shared/widgets/month_year_picker.dart';

/// Step for selecting pioneer start date
class PioneerStartDateStep extends StatelessWidget {
  const PioneerStartDateStep({
    super.key,
    required this.publisherType,
    this.selectedDate,
    required this.onChanged,
  });

  final PublisherType publisherType;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onChanged;

  String get _title {
    if (publisherType == PublisherType.regularPioneer) {
      return '¿Cuándo comenzaste el precursorado regular?';
    } else {
      return '¿Cuándo comenzaste el precursorado especial?';
    }
  }

  String get _subtitle {
    return 'Selecciona el mes en que iniciaste como ${publisherType.displayName.toLowerCase()}';
  }

  DateTime _getMinDate() {
    final now = DateTime.now();
    // Service year starts in September
    if (now.month >= 9) {
      // Current service year started this year
      return DateTime(now.year, 9, 1);
    } else {
      // Current service year started last year
      return DateTime(now.year - 1, 9, 1);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final minDate = _getMinDate();
    final now = DateTime.now();
    final initialDate = selectedDate ?? DateTime(now.year, now.month, 1);

    final pickedDate = await showMonthYearPicker(
      context: context,
      initialDate: initialDate,
      firstDate: minDate,
      lastDate: now,
      helpText: 'Selecciona mes de inicio',
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
            Icons.event_available,
            size: 64,
            color: colorScheme.primary,
          ),
          const SizedBox(height: 24),

          // Title
          Text(
            _title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // Subtitle
          Text(
            _subtitle,
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
                      Icons.calendar_month,
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
                            'Mes de inicio',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: selectedDate != null
                                  ? colorScheme.onPrimaryContainer
                                  : colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            selectedDate != null
                                ? DateFormatter.getMonthYear(
                                    selectedDate!.year,
                                    selectedDate!.month,
                                  )
                                : 'Toca para seleccionar',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: selectedDate != null
                                  ? colorScheme.onPrimaryContainer
                                  : colorScheme.onSurfaceVariant,
                            ),
                          ),
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

          const SizedBox(height: 24),

          // Info message
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: colorScheme.outlineVariant,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 20,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Solo puedes seleccionar desde el inicio del año de servicio actual (1 de septiembre)',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
