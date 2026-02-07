import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/constants.dart';
import '../../../../shared/models/month_summary.dart';
import '../../data/providers/month_summary_provider.dart';
import 'goal_selector_dialog.dart';

/// Card displaying monthly summary with goal progress
class MonthSummaryCard extends ConsumerWidget {
  const MonthSummaryCard({
    super.key,
    this.year,
    this.month,
  });

  final int? year;
  final int? month;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use provided year/month or default to current month
    final now = DateTime.now();
    final targetYear = year ?? now.year;
    final targetMonth = month ?? now.month;

    final summaryAsync = ref.watch(
      monthSummaryProvider(targetYear, targetMonth),
    );

    return summaryAsync.when(
      data: (summary) => _buildCard(context, ref, summary),
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      error: (error, stack) => Card(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text('Error: ${error.toString()}'),
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    WidgetRef ref,
    MonthSummary summary,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Month name
    final monthName = DateFormat.MMMM('es').format(
      DateTime(summary.year, summary.month),
    );
    final capitalizedMonth =
        monthName[0].toUpperCase() + monthName.substring(1);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Month + Edit button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$capitalizedMonth ${summary.year}',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: 'Editar meta',
                  onPressed: () => _showGoalSelector(context, ref, summary),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Goal info or "Set goal" button
            if (summary.goal != null)
              _buildGoalInfo(theme, colorScheme, summary)
            else
              _buildSetGoalButton(context, ref, summary, colorScheme),

            const SizedBox(height: 16),

            // Progress bar (only if goal exists)
            if (summary.goal != null) ...[
              _buildProgressBar(colorScheme, summary),
              const SizedBox(height: 16),
            ],

            // Stats row
            _buildStatsRow(theme, colorScheme, summary),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalInfo(
    ThemeData theme,
    ColorScheme colorScheme,
    MonthSummary summary,
  ) {
    final goalTypeLabel = _getGoalTypeLabel(summary.goal!.goalType);

    return Row(
      children: [
        Icon(
          Icons.flag_outlined,
          size: 20,
          color: colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Text(
          '$goalTypeLabel - ${summary.targetHours.toStringAsFixed(0)} horas',
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSetGoalButton(
    BuildContext context,
    WidgetRef ref,
    MonthSummary summary,
    ColorScheme colorScheme,
  ) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _showGoalSelector(context, ref, summary),
        icon: const Icon(Icons.add),
        label: const Text('Establecer meta del mes'),
      ),
    );
  }

  Widget _buildProgressBar(ColorScheme colorScheme, MonthSummary summary) {
    // Get color based on progress
    final progressColor = switch (summary.progressColor) {
      ProgressColor.green => colorScheme.primary,
      ProgressColor.yellow => Colors.orange,
      ProgressColor.red => colorScheme.error,
      ProgressColor.gray => colorScheme.outline,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hours display
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${summary.totalHours.toStringAsFixed(1)} / ${summary.targetHours.toStringAsFixed(0)} h',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: progressColor,
              ),
            ),
            Text(
              '${summary.progressPercentage.toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Progress bar
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: (summary.progressPercentage / 100.0).clamp(0.0, 1.0),
            minHeight: 12,
            backgroundColor: colorScheme.surfaceVariant,
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(
    ThemeData theme,
    ColorScheme colorScheme,
    MonthSummary summary,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Status message
        if (summary.goal != null)
          Row(
            children: [
              Icon(
                summary.isGoalMet
                    ? Icons.check_circle_outline
                    : Icons.schedule_outlined,
                size: 20,
                color: summary.isGoalMet
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                summary.statusMessage,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: summary.isGoalMet
                      ? colorScheme.primary
                      : colorScheme.onSurface,
                ),
              ),
            ],
          ),

        const SizedBox(height: 8),

        // Bible studies count
        Row(
          children: [
            Icon(
              Icons.menu_book_outlined,
              size: 20,
              color: colorScheme.secondary,
            ),
            const SizedBox(width: 8),
            Text(
              summary.bibleStudiesCount == 1
                  ? '1 curso bíblico activo'
                  : '${summary.bibleStudiesCount} cursos bíblicos activos',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _showGoalSelector(
    BuildContext context,
    WidgetRef ref,
    MonthSummary summary,
  ) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => GoalSelectorDialog(
        currentGoal: summary.goal,
        year: summary.year,
        month: summary.month,
      ),
    );
  }

  String _getGoalTypeLabel(dynamic goalType) {
    final typeStr = goalType.toString().split('.').last;
    return switch (typeStr) {
      'publisher' => 'Publicador',
      'auxiliaryPioneer15' => 'Precursor Auxiliar',
      'auxiliaryPioneer30' => 'Precursor Auxiliar',
      'regularPioneer' => 'Precursor Regular',
      'specialPioneer' => 'Precursor Especial',
      'missionary' => 'Misionero',
      _ => 'Sin meta',
    };
  }
}
