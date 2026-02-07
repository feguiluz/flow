import 'package:freezed_annotation/freezed_annotation.dart';

import 'goal.dart';

part 'month_summary.freezed.dart';

/// Model representing a summary of ministry activity for a specific month
@freezed
class MonthSummary with _$MonthSummary {
  const factory MonthSummary({
    /// Year (e.g., 2026)
    required int year,

    /// Month (1-12)
    required int month,

    /// Total hours registered in the month
    required double totalHours,

    /// Count of active Bible studies in the month
    /// (persons with isBibleStudy=true who had at least 1 visit that month)
    required int bibleStudiesCount,

    /// Goal for the month (if set)
    Goal? goal,

    /// Progress percentage (0.0 to 100.0+)
    /// Calculated as (totalHours / targetHours) * 100
    /// If no goal, always 0.0
    required double progressPercentage,

    /// Whether the goal has been met
    /// If no goal, always false
    required bool isGoalMet,
  }) = _MonthSummary;

  const MonthSummary._();

  /// Get target hours from goal
  /// Returns 0.0 if no goal set
  double get targetHours => goal?.targetHours ?? 0.0;

  /// Get remaining hours to meet goal
  /// Returns 0.0 if goal is met or no goal set
  double get remainingHours {
    if (goal == null || isGoalMet) return 0.0;
    return (targetHours - totalHours).clamp(0.0, double.infinity);
  }

  /// Get progress color based on percentage
  /// - Green (≥90%): Goal practically met
  /// - Yellow (50-89%): In progress
  /// - Red (<50%): Below target
  ProgressColor get progressColor {
    if (goal == null) return ProgressColor.gray;
    if (progressPercentage >= 90) return ProgressColor.green;
    if (progressPercentage >= 50) return ProgressColor.yellow;
    return ProgressColor.red;
  }

  /// Get status message
  String get statusMessage {
    if (goal == null) return 'Sin meta establecida';
    if (isGoalMet) return '¡Meta cumplida!';
    if (remainingHours == 0.0) return '¡Meta cumplida!';
    return 'Faltan ${remainingHours.toStringAsFixed(1)} horas';
  }
}

/// Color categorization for progress indication
enum ProgressColor {
  gray,
  red,
  yellow,
  green,
}
