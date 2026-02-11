import 'package:flutter/material.dart';

/// Summary cards showing key statistics
class SummaryCards extends StatelessWidget {
  const SummaryCards({
    super.key,
    required this.totalHours,
    required this.averageHours,
    required this.totalBibleStudies,
    required this.monthsWithData,
  });

  final double totalHours;
  final double averageHours;
  final int totalBibleStudies;
  final int monthsWithData;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildCard(
              context,
              icon: Icons.access_time,
              label: 'Total',
              value: '${totalHours.toStringAsFixed(1)}h',
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildCard(
              context,
              icon: Icons.show_chart,
              label: 'Promedio',
              value: '${averageHours.toStringAsFixed(1)}h',
              color: colorScheme.secondary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildCard(
              context,
              icon: Icons.book,
              label: 'Cursos',
              value: totalBibleStudies.toString(),
              color: colorScheme.tertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
