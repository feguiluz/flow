import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flow/features/statistics/data/providers/statistics_provider.dart';
import 'package:flow/features/statistics/presentation/widgets/hours_chart.dart';
import 'package:flow/features/statistics/presentation/widgets/summary_cards.dart';
import 'package:flow/shared/providers/user_profile_provider.dart';

/// Statistics screen - Charts and analytics
///
/// Displays:
/// - Bar chart showing hours per month
/// - Annual totals and averages
/// - Goal achievement tracking
/// - Participation history
class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({super.key});

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen> {
  late int _selectedYear;

  @override
  void initState() {
    super.initState();
    _selectedYear = getCurrentServiceYear();
  }

  void _goToPreviousYear() {
    setState(() {
      _selectedYear--;
    });
  }

  void _goToNextYear() {
    setState(() {
      _selectedYear++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final statisticsAsync =
        ref.watch(serviceYearStatisticsProvider(_selectedYear));
    final profileAsync = ref.watch(userProfileProvider);

    // Get goal hours if user is pioneer
    final goalHours = profileAsync.valueOrNull?.monthlyGoalHours;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text('Estadísticas'),
            Text(
              'Año de Servicio $_selectedYear-${_selectedYear + 1}',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _goToPreviousYear,
            tooltip: 'Año anterior',
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed:
                _selectedYear >= getCurrentServiceYear() ? null : _goToNextYear,
            tooltip: 'Año siguiente',
          ),
        ],
      ),
      body: statisticsAsync.when(
        data: (statistics) {
          if (statistics.monthsWithData == 0) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bar_chart,
                    size: 64,
                    color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Sin datos para este año',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Registra horas para ver estadísticas',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView(
            children: [
              // Summary Cards
              SummaryCards(
                totalHours: statistics.totalHours,
                averageHours: statistics.averageHours,
                totalBibleStudies: statistics.totalBibleStudies,
                monthsWithData: statistics.monthsWithData,
              ),

              // Hours Chart
              HoursChart(
                hoursByMonth: statistics.hoursByMonth,
                goalHours: goalHours,
              ),

              // Additional info
              Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Información del Año de Servicio',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          context,
                          'Periodo',
                          'Septiembre $_selectedYear - Agosto ${_selectedYear + 1}',
                        ),
                        const Divider(height: 24),
                        _buildInfoRow(
                          context,
                          'Meses activos',
                          '${statistics.monthsWithData} de 12',
                        ),
                        const Divider(height: 24),
                        _buildInfoRow(
                          context,
                          'Total de horas',
                          '${statistics.totalHours.toStringAsFixed(1)} h',
                        ),
                        if (goalHours != null) ...[
                          const Divider(height: 24),
                          _buildInfoRow(
                            context,
                            'Meta anual',
                            '${(goalHours * 12).toStringAsFixed(0)} h',
                          ),
                          const Divider(height: 24),
                          _buildInfoRow(
                            context,
                            'Progreso',
                            '${((statistics.totalHours / (goalHours * 12)) * 100).toStringAsFixed(1)}%',
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Error al cargar estadísticas',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
