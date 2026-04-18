/// Utility class for time formatting and conversion
class TimeFormatter {
  // Private constructor to prevent instantiation
  TimeFormatter._();

  /// Convert minutes to hours and minutes format (e.g., 150 -> "2h 30m")
  static String formatMinutesToHoursMinutes(int totalMinutes) {
    if (totalMinutes == 0) {
      return '0m';
    }

    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;

    if (hours == 0) {
      return '${minutes}m';
    }

    if (minutes == 0) {
      return '${hours}h';
    }

    return '${hours}h ${minutes}m';
  }

  /// Convert minutes to HH:MM format (e.g., 150 -> "02:30")
  static String formatMinutesToHHMM(int totalMinutes) {
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  /// Parse HH:MM format to total minutes (e.g., "02:30" -> 150)
  /// Returns null if format is invalid
  static int? parseHHMMToMinutes(String time) {
    if (time.isEmpty) {
      return null;
    }

    // Remove whitespace
    time = time.trim();

    // Expected format: HH:MM or H:MM
    final parts = time.split(':');

    if (parts.length != 2) {
      return null;
    }

    final hours = int.tryParse(parts[0]);
    final minutes = int.tryParse(parts[1]);

    if (hours == null || minutes == null) {
      return null;
    }

    if (hours < 0 || minutes < 0 || minutes >= 60) {
      return null;
    }

    return (hours * 60) + minutes;
  }

  /// Convert decimal hours to minutes (e.g., 2.5 -> 150)
  static int decimalHoursToMinutes(double hours) {
    return (hours * 60).round();
  }

  /// Convert minutes to decimal hours (e.g., 150 -> 2.5)
  static double minutesToDecimalHours(int minutes) {
    return minutes / 60;
  }

  /// Validate HH:MM format
  static bool isValidHHMMFormat(String time) {
    return parseHHMMToMinutes(time) != null;
  }

  /// Get total hours as integer (e.g., 150 minutes -> 2 hours)
  static int getHours(int totalMinutes) {
    return totalMinutes ~/ 60;
  }

  /// Get remaining minutes (e.g., 150 minutes -> 30 minutes)
  static int getMinutes(int totalMinutes) {
    return totalMinutes % 60;
  }
}
