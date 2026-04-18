import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Bar chart widget showing hours per month
class HoursChart extends StatelessWidget {
  const HoursChart({
    super.key,
    required this.hoursByMonth,
    this.goalHours,
  });

  final Map<int, double> hoursByMonth;
  final double? goalHours;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Months in service year order: Sep, Oct, Nov, Dec, Jan, Feb, Mar, Apr, May, Jun, Jul, Aug
    final monthsOrder = [9, 10, 11, 12, 1, 2, 3, 4, 5, 6, 7, 8];
    final monthLabels = [
      'Sep',
      'Oct',
      'Nov',
      'Dic',
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago'
    ];

    final barGroups = <BarChartGroupData>[];
    for (int i = 0; i < monthsOrder.length; i++) {
      final month = monthsOrder[i];
      final hours = hoursByMonth[month] ?? 0.0;

      // Determine bar color based on goal achievement
      Color barColor;
      if (goalHours != null && hours > 0) {
        if (hours >= goalHours!) {
          barColor = Colors.green;
        } else if (hours >= goalHours! * 0.8) {
          barColor = Colors.orange;
        } else {
          barColor = Colors.red;
        }
      } else {
        barColor = colorScheme.primary;
      }

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: hours,
              color: barColor,
              width: 16,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
          ],
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Horas por Mes',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _getMaxY(),
                  barGroups: barGroups,
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 &&
                              value.toInt() < monthLabels.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                monthLabels[value.toInt()],
                                style: theme.textTheme.bodySmall,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: theme.textTheme.bodySmall,
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 20,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: colorScheme.outlineVariant.withOpacity(0.3),
                        strokeWidth: 1,
                        dashArray: [5, 5],
                      );
                    },
                  ),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
            if (goalHours != null) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegendItem('Cumplida', Colors.green),
                  const SizedBox(width: 16),
                  _buildLegendItem('80%+', Colors.orange),
                  const SizedBox(width: 16),
                  _buildLegendItem('<80%', Colors.red),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  double _getMaxY() {
    final maxHours = hoursByMonth.values
        .fold<double>(0, (max, hours) => hours > max ? hours : max);
    final goalMax = goalHours ?? 0;
    final maxValue = maxHours > goalMax ? maxHours : goalMax;

    // Round up to nearest 20
    return ((maxValue / 20).ceil() * 20).toDouble() + 20;
  }
}
