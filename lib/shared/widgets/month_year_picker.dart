import 'package:flutter/material.dart';

import 'package:flow/core/utils/date_formatter.dart';

/// Shows a dialog to pick month and year
/// Returns DateTime with day set to 1
Future<DateTime?> showMonthYearPicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  DateTime? lastDate,
  String? helpText,
}) async {
  return showDialog<DateTime>(
    context: context,
    builder: (context) => _MonthYearPickerDialog(
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate ?? DateTime.now(),
      helpText: helpText,
    ),
  );
}

class _MonthYearPickerDialog extends StatefulWidget {
  const _MonthYearPickerDialog({
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    this.helpText,
  });

  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final String? helpText;

  @override
  State<_MonthYearPickerDialog> createState() => _MonthYearPickerDialogState();
}

class _MonthYearPickerDialogState extends State<_MonthYearPickerDialog> {
  late int _selectedYear;
  late int _selectedMonth;

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.initialDate.year;
    _selectedMonth = widget.initialDate.month;
  }

  bool _isDateValid() {
    final selectedDate = DateTime(_selectedYear, _selectedMonth, 1);
    return !selectedDate.isBefore(widget.firstDate) &&
        !selectedDate.isAfter(widget.lastDate);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Generate list of valid years
    final years = List.generate(
      widget.lastDate.year - widget.firstDate.year + 1,
      (index) => widget.firstDate.year + index,
    );

    return AlertDialog(
      title: Text(widget.helpText ?? 'Seleccionar mes y año'),
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Year selector
            DropdownButtonFormField<int>(
              value: _selectedYear,
              decoration: const InputDecoration(
                labelText: 'Año',
                border: OutlineInputBorder(),
              ),
              items: years.map((year) {
                return DropdownMenuItem(
                  value: year,
                  child: Text(year.toString()),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedYear = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            // Month selector
            DropdownButtonFormField<int>(
              value: _selectedMonth,
              decoration: const InputDecoration(
                labelText: 'Mes',
                border: OutlineInputBorder(),
              ),
              items: List.generate(12, (index) => index + 1).map((month) {
                final monthName = DateFormatter.getMonthName(month);
                final date = DateTime(_selectedYear, month, 1);
                final isDisabled = date.isBefore(widget.firstDate) ||
                    date.isAfter(widget.lastDate);

                return DropdownMenuItem(
                  value: month,
                  enabled: !isDisabled,
                  child: Text(
                    monthName,
                    style: isDisabled
                        ? TextStyle(
                            color: colorScheme.onSurface.withOpacity(0.38))
                        : null,
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedMonth = value;
                  });
                }
              },
            ),

            const SizedBox(height: 16),

            // Preview
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 20,
                    color: colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    DateFormatter.getMonthYear(_selectedYear, _selectedMonth),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _isDateValid()
              ? () {
                  Navigator.of(context).pop(
                    DateTime(_selectedYear, _selectedMonth, 1),
                  );
                }
              : null,
          child: const Text('Aceptar'),
        ),
      ],
    );
  }
}
