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

  // Special months (March and April always have 15h option available)
  static const List<int> specialMonths = [3, 4]; // March, April

  // Date formats
  static const String displayDateFormat = 'dd/MM/yyyy';
  static const String dbDateFormat = 'yyyy-MM-dd';
  static const String monthYearFormat = 'MMMM yyyy';

  // SharedPreferences keys
  static const String keyUserName = 'user_name';
  static const String keyDefaultGoalType = 'default_goal_type';
  static const String keyUserGender = 'user_gender';
  static const String keyUserAge = 'user_age';
  static const String keyThemeMode = 'theme_mode';

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
}
