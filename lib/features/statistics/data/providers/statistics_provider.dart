import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flow/features/home/data/providers/activity_notifier.dart';
import 'package:flow/features/people/data/providers/visit_notifier.dart';

part 'statistics_provider.freezed.dart';
part 'statistics_provider.g.dart';

/// Statistics for a service year (September to August)
@freezed
class ServiceYearStatistics with _$ServiceYearStatistics {
  const factory ServiceYearStatistics({
    required int startYear,
    required Map<int, double> hoursByMonth, // month (1-12) -> hours
    required double totalHours,
    required double averageHours,
    required int totalBibleStudies,
    required int monthsWithData,
  }) = _ServiceYearStatistics;
}

/// Provider for service year statistics
/// startYear = 2025 means September 2025 to August 2026
@riverpod
Future<ServiceYearStatistics> serviceYearStatistics(
  ServiceYearStatisticsRef ref,
  int startYear,
) async {
  final Map<int, double> hoursByMonth = {};
  double totalHours = 0.0;
  int totalBibleStudies = 0;
  int monthsWithData = 0;

  // Service year goes from September (startYear) to August (startYear + 1)
  for (int monthOffset = 0; monthOffset < 12; monthOffset++) {
    final month =
        ((8 + monthOffset) % 12) + 1; // September = 9, ..., August = 8
    final year = month >= 9 ? startYear : startYear + 1;

    // Get hours for this month
    final minutes = await ref.watch(
      getTotalMinutesForMonthProvider(year: year, month: month).future,
    );
    final hours = minutes / 60.0;

    if (hours > 0) {
      monthsWithData++;
      totalHours += hours;
    }

    hoursByMonth[month] = hours;

    // Get bible studies for this month
    final studies = await ref.watch(
      bibleStudiesCountForMonthProvider(year, month).future,
    );
    totalBibleStudies += studies;
  }

  final averageHours = monthsWithData > 0 ? totalHours / monthsWithData : 0.0;

  return ServiceYearStatistics(
    startYear: startYear,
    hoursByMonth: hoursByMonth,
    totalHours: totalHours,
    averageHours: averageHours,
    totalBibleStudies: totalBibleStudies,
    monthsWithData: monthsWithData,
  );
}

/// Get current service year start year
/// If current month >= September, service year starts this year
/// If current month < September, service year started last year
int getCurrentServiceYear() {
  final now = DateTime.now();
  return now.month >= 9 ? now.year : now.year - 1;
}
