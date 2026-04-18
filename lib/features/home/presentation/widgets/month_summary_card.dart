import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:flow/shared/models/month_summary.dart';
import 'package:flow/shared/models/publisher_type.dart';
import 'package:flow/shared/providers/user_profile_provider.dart';
import 'package:flow/features/home/data/providers/month_summary_provider.dart';
import 'auxiliary_goal_dialog.dart';
import 'participation_checkbox.dart';

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

    // Get user profile to check if can edit goal
    final profileAsync = ref.watch(userProfileProvider);
    final profile = profileAsync.valueOrNull;
    final isPublisher = profile?.publisherType == PublisherType.publisher;

    // Month name
    final monthName = DateFormat.MMMM('es').format(
      DateTime(summary.year, summary.month),
    );
    final capitalizedMonth =
        monthName[0].toUpperCase() + monthName.substring(1);

    // Check if goal is met for special styling
    final isGoalMet = summary.isGoalMet && summary.targetHours > 0;

    // Use theme's secondary color (teal) for success state
    final successColor = colorScheme.secondary;
    final borderColor = isGoalMet ? successColor : null;

    return Card(
      elevation: isGoalMet ? 4 : 2,
      shape: isGoalMet && borderColor != null
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: borderColor,
                width: 3,
              ),
            )
          : null,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Month + Edit button (only for publishers)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$capitalizedMonth ${summary.year}',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (isPublisher)
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    tooltip: 'Editar meta auxiliar',
                    onPressed: () => _showGoalSelector(context, ref, summary),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Show different content based on user type and goal status
            if (summary.targetHours > 0) ...[
              // Has target hours: Show goal info and progress
              _buildGoalInfo(theme, colorScheme, summary, profile),
              const SizedBox(height: 16),
              _buildProgressBar(colorScheme, summary),
              const SizedBox(height: 16),
            ] else if (isPublisher) ...[
              // Publisher without auxiliary goal: Show participation checkbox
              ParticipationCheckbox(
                year: summary.year,
                month: summary.month,
              ),
              const SizedBox(height: 8),
              _buildSetGoalButton(context, ref, summary, colorScheme),
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
    dynamic profile,
  ) {
    // Get label from goal if it exists, otherwise show publisher type label
    final goalTypeLabel = summary.goal != null
        ? _getGoalTypeLabel(summary.goal!.goalType)
        : _getPublisherTypeLabel(profile?.publisherType);

    return Row(
      children: [
        Icon(
          Icons.flag_outlined,
          size: 20,
          color: colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Text(
          goalTypeLabel,
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
    // Get color based on progress - use secondary (teal) when goal is met
    final progressColor = summary.isGoalMet
        ? colorScheme.secondary
        : switch (summary.progressColor) {
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
              '${_formatHours(summary.totalHours)} / ${summary.targetHours.toStringAsFixed(0)}h',
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
    // Use theme's secondary color (teal) for success state
    final successColor = colorScheme.secondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
    // Only publishers can set auxiliary goals
    final profileAsync = ref.read(userProfileProvider);
    final profile = profileAsync.valueOrNull;

    if (profile?.publisherType != PublisherType.publisher) {
      // Show info dialog for pioneers
      final pioneerLabel = _getPublisherTypeLabel(profile?.publisherType);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(pioneerLabel),
          content: Text(
            'Como ${pioneerLabel.toLowerCase()}, tu meta es automática según tu privilegio y no puede ser modificada.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Entendido'),
            ),
          ],
        ),
      );
      return;
    }

    await showDialog(
      context: context,
      builder: (context) => AuxiliaryGoalDialog(
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
      'auxiliaryPioneer15' => 'Precursorado Auxiliar',
      'auxiliaryPioneer30' => 'Precursorado Auxiliar',
      'regularPioneer' => 'Precursorado Regular',
      'specialPioneer' => 'Precursorado Especial',
      'missionary' => 'Misionero',
      _ => 'Sin meta',
    };
  }

  String _getPublisherTypeLabel(PublisherType? publisherType) {
    if (publisherType == null) return 'Sin meta';

    return switch (publisherType) {
      PublisherType.publisher => 'Publicador',
      PublisherType.regularPioneer => 'Precursorado Regular',
      PublisherType.specialPioneer => 'Precursorado Especial',
    };
  }

  /// Format hours as "Xh Ymin" or "Xh" if no minutes
  String _formatHours(double hours) {
    final wholeHours = hours.floor();
    final minutes = ((hours - wholeHours) * 60).round();

    if (minutes == 0) {
      return '${wholeHours}h';
    }
    return '${wholeHours}h ${minutes}min';
  }
}
