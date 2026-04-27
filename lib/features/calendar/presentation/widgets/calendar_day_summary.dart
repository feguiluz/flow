import 'package:flutter/material.dart';

/// Compact card showing the predication minutes registered on the selected day.
class CalendarDaySummary extends StatelessWidget {
  const CalendarDaySummary({super.key, required this.minutes});

  final int minutes;

  // Same green used by the statistics chart for "Cumplida". Picked
  // explicitly (instead of colorScheme.tertiary) because the seed-based M3
  // tertiary leans rose, which clashes with the predication semantics.
  static const Color _green = Color(0xFF2E7D32); // Material green 800
  static const Color _greenContainer = Color(0xFFC8E6C9); // green 100

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    final formatted = hours > 0
        ? (mins > 0 ? '${hours}h ${mins}min' : '${hours}h')
        : '$mins min';

    return Card(
      color: _greenContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.work_history, color: _green),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Predicación',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: _green,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    formatted,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: _green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
