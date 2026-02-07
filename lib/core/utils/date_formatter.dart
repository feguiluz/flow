import 'package:intl/intl.dart';

import 'constants.dart';

/// Utility class for date formatting and parsing
class DateFormatter {
  // Private constructor to prevent instantiation
  DateFormatter._();

  /// Format a DateTime for display to user (dd/MM/yyyy)
  static String formatForDisplay(DateTime date) {
    final formatter = DateFormat(AppConstants.displayDateFormat);
    return formatter.format(date);
  }

  /// Format a DateTime for database storage (yyyy-MM-dd)
  static String formatForDb(DateTime date) {
    final formatter = DateFormat(AppConstants.dbDateFormat);
    return formatter.format(date);
  }

  /// Parse a date string from database format (yyyy-MM-dd)
  static DateTime parseFromDb(String dateStr) {
    final formatter = DateFormat(AppConstants.dbDateFormat);
    return formatter.parse(dateStr);
  }

  /// Get month name in Spanish
  static String getMonthName(int month) {
    const monthNames = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];

    if (month < 1 || month > 12) {
      throw ArgumentError('Month must be between 1 and 12');
    }

    return monthNames[month - 1];
  }

  /// Get month abbreviation in Spanish
  static String getMonthAbbr(int month) {
    const monthAbbrs = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic',
    ];

    if (month < 1 || month > 12) {
      throw ArgumentError('Month must be between 1 and 12');
    }

    return monthAbbrs[month - 1];
  }

  /// Format month and year for display (e.g., "Febrero 2026")
  static String getMonthYear(int year, int month) {
    return '${getMonthName(month)} $year';
  }

  /// Get relative date description with day of week
  static String getRelativeDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'Hoy';
    } else if (dateOnly == yesterday) {
      return 'Ayer';
    } else {
      // Format: "Lun, 15 de enero"
      final formatter = DateFormat('EEE, d \'de\' MMMM', 'es_ES');
      return formatter.format(date);
    }
  }

  /// Format date with day of week (e.g., "Lunes, 15 de enero de 2026")
  static String formatWithDayOfWeek(DateTime date) {
    final formatter = DateFormat('EEEE, d \'de\' MMMM \'de\' yyyy', 'es_ES');
    return formatter.format(date);
  }
}
