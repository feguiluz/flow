/// Application-wide constants for Flow app
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  // Goal hours requirements
  static const double auxiliaryPioneer15Hours = 15.0;
  static const double auxiliaryPioneer30Hours = 30.0;
  static const double regularPioneerMonthlyHours = 50.0;
  static const double regularPioneerAnnualHours = 600.0;
  static const double specialPioneerMaleHours = 100.0;
  static const double specialPioneerFemaleUnder40Hours = 100.0;
  static const double specialPioneerFemaleOver40Hours = 90.0;
  static const double missionaryMaleHours = 100.0;
  static const double missionaryFemaleUnder40Hours = 100.0;
  static const double missionaryFemaleOver40Hours = 90.0;

  // Special months (March and April - historically had special campaigns)
  // Note: As of recent years, 15h auxiliary pioneer is available ALL year round
  @Deprecated('15h option is now available all year, not just special months')
  static const List<int> specialMonths = [3, 4]; // March, April

  // Date formats
  static const String displayDateFormat = 'dd/MM/yyyy';
  static const String dbDateFormat = 'yyyy-MM-dd';
  static const String monthYearFormat = 'MMMM yyyy';

  // SharedPreferences keys
  static const String keyUserName = 'user_name';
  static const String keyPublisherType = 'user_publisher_type';
  static const String keyGender = 'user_gender';
  static const String keyBirthDate = 'user_birth_date';
  static const String keyRegularPioneerStartDate = 'regular_pioneer_start_date';
  static const String keySpecialPioneerStartDate = 'special_pioneer_start_date';
  static const String keyThemeMode = 'theme_mode';

  // Deprecated keys (kept for migration, will be removed in future)
  @Deprecated('Use keyPublisherType instead')
  static const String keyDefaultGoalType = 'default_goal_type';
  @Deprecated('Use keyGender instead')
  static const String keyUserGender = 'user_gender';
  @Deprecated('Use keyBirthDate instead')
  static const String keyUserAge = 'user_age';

  // Gender values
  static const String genderMale = 'male';
  static const String genderFemale = 'female';

  // Age threshold for special pioneer/missionary
  static const int specialPioneerAgeThreshold = 40;

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double cardBorderRadius = 16.0;
  static const double defaultElevation = 1.0;

  // Validation
  static const double minHours = 0.01;
  static const double maxHoursPerDay = 24.0; // Maximum hours in a single day
  static const int maxNoteLength = 500;

  // Service Year (Año de Servicio)
  // The service year runs from September to August
  static const int serviceYearStartMonth = 9; // September
  static const int serviceYearEndMonth = 8; // August

  /// Get the current service year as [startYear, endYear]
  /// Example: If we're in January 2026, returns [2025, 2026] (Sep 2025 - Aug 2026)
  static List<int> getCurrentServiceYear() {
    final now = DateTime.now();
    return getServiceYearForDate(now);
  }

  /// Get the service year for a specific date as [startYear, endYear]
  /// Example: January 2026 → [2025, 2026] (Sep 2025 - Aug 2026)
  /// Example: September 2026 → [2026, 2027] (Sep 2026 - Aug 2027)
  static List<int> getServiceYearForDate(DateTime date) {
    if (date.month >= serviceYearStartMonth) {
      // Sep-Dec: current year - next year
      return [date.year, date.year + 1];
    } else {
      // Jan-Aug: previous year - current year
      return [date.year - 1, date.year];
    }
  }

  /// Format service year for display
  /// Example: [2025, 2026] → "Año de servicio 2025-2026"
  static String formatServiceYear(List<int> serviceYear) {
    return 'Año de servicio ${serviceYear[0]}-${serviceYear[1]}';
  }

  /// Get the start date of a service year
  /// Example: 2025 → September 1, 2025
  static DateTime getServiceYearStartDate(int startYear) {
    return DateTime(startYear, serviceYearStartMonth, 1);
  }

  /// Get the end date of a service year (inclusive)
  /// Example: 2025 → August 31, 2026
  static DateTime getServiceYearEndDate(int startYear) {
    return DateTime(startYear + 1, serviceYearEndMonth + 1, 0);
  }
}
