import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/people/data/models/people_sort_option.dart';
import '../../shared/models/gender.dart';
import '../../shared/models/goal.dart';
import '../../shared/models/publisher_type.dart';
import '../utils/constants.dart';

/// Service for managing user profile data using SharedPreferences
class UserProfileService {
  UserProfileService._();

  static final UserProfileService instance = UserProfileService._();

  SharedPreferences? _prefs;

  /// Initialize the service
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get _preferences {
    if (_prefs == null) {
      throw StateError(
        'UserProfileService not initialized. Call init() first.',
      );
    }
    return _prefs!;
  }

  // ==================== Getters ====================

  /// Get user full name
  String? getUserName() {
    return _preferences.getString(AppConstants.keyUserName);
  }

  /// Get publisher type
  PublisherType? getPublisherType() {
    final value = _preferences.getString(AppConstants.keyPublisherType);
    if (value == null) return null;
    return PublisherTypeExtension.fromKey(value);
  }

  /// Get user gender
  Gender? getGender() {
    final value = _preferences.getString(AppConstants.keyGender);
    if (value == null) return null;
    return GenderExtension.fromKey(value);
  }

  /// Get user birth date
  DateTime? getBirthDate() {
    final value = _preferences.getString(AppConstants.keyBirthDate);
    if (value == null) return null;
    try {
      return DateTime.parse(value);
    } catch (_) {
      return null;
    }
  }

  /// Get regular pioneer start date
  DateTime? getRegularPioneerStartDate() {
    final value =
        _preferences.getString(AppConstants.keyRegularPioneerStartDate);
    if (value == null) return null;
    try {
      return DateTime.parse(value);
    } catch (_) {
      return null;
    }
  }

  /// Get special pioneer start date
  DateTime? getSpecialPioneerStartDate() {
    final value =
        _preferences.getString(AppConstants.keySpecialPioneerStartDate);
    if (value == null) return null;
    try {
      return DateTime.parse(value);
    } catch (_) {
      return null;
    }
  }

  /// Calculate age from birth date
  int? get age {
    final birthDate = getBirthDate();
    if (birthDate == null) return null;

    final today = DateTime.now();
    int age = today.year - birthDate.year;

    // Adjust if birthday hasn't occurred this year yet
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  /// Get theme mode
  ThemeMode getThemeMode() {
    final value = _preferences.getString(AppConstants.keyThemeMode);
    if (value == null) return ThemeMode.system;

    try {
      return ThemeMode.values.firstWhere((e) => e.name == value);
    } catch (_) {
      return ThemeMode.system;
    }
  }

  /// Get the saved sort option for the people list. Returns the enum's
  /// declared default when nothing is stored yet or the value is unknown
  /// (e.g. left over from a removed option).
  PeopleSortOption getPeopleSortOption() {
    final value = _preferences.getString(AppConstants.keyPeopleSort);
    if (value == null) return PeopleSortOption.defaultOption;
    try {
      return PeopleSortOption.values.firstWhere((e) => e.name == value);
    } catch (_) {
      return PeopleSortOption.defaultOption;
    }
  }

  // ==================== Deprecated Getters (for backward compatibility) ====================

  /// Get default goal type
  @Deprecated('Use getPublisherType() instead')
  GoalType? getDefaultGoalType() {
    final value = _preferences.getString(AppConstants.keyDefaultGoalType);
    if (value == null) return null;

    try {
      return GoalType.values.firstWhere((e) => e.name == value);
    } catch (_) {
      return null;
    }
  }

  /// Get user gender (legacy string format)
  @Deprecated('Use getGender() instead')
  String? getUserGender() {
    return _preferences.getString(AppConstants.keyUserGender);
  }

  /// Get user age (legacy)
  @Deprecated('Use age getter instead')
  int? getUserAge() {
    return _preferences.getInt(AppConstants.keyUserAge);
  }

  // ==================== Setters ====================

  /// Set user full name
  Future<void> setUserName(String name) async {
    if (name.trim().isEmpty) {
      throw ArgumentError('Name cannot be empty');
    }
    await _preferences.setString(AppConstants.keyUserName, name.trim());
  }

  /// Set publisher type
  Future<void> setPublisherType(PublisherType type) async {
    await _preferences.setString(AppConstants.keyPublisherType, type.key);
  }

  /// Set user gender
  Future<void> setGender(Gender gender) async {
    await _preferences.setString(AppConstants.keyGender, gender.key);
  }

  /// Set user birth date
  Future<void> setBirthDate(DateTime birthDate) async {
    // Validate that birth date is not in the future
    if (birthDate.isAfter(DateTime.now())) {
      throw ArgumentError('Birth date cannot be in the future');
    }
    // Store in ISO 8601 format (YYYY-MM-DD)
    await _preferences.setString(
      AppConstants.keyBirthDate,
      birthDate.toIso8601String().split('T')[0],
    );
  }

  /// Set regular pioneer start date
  /// Always stores as first day of the month
  Future<void> setRegularPioneerStartDate(DateTime startDate) async {
    // Normalize to first day of month
    final normalizedDate = DateTime(startDate.year, startDate.month, 1);

    // Validate: must be from September 1st of current service year or later
    final now = DateTime.now();
    final currentServiceYearStart = _getServiceYearStart(now);

    if (normalizedDate.isBefore(currentServiceYearStart)) {
      throw ArgumentError(
        'La fecha de inicio debe ser a partir del 1 de septiembre del año de servicio actual',
      );
    }

    // Store in ISO 8601 format (YYYY-MM-DD)
    await _preferences.setString(
      AppConstants.keyRegularPioneerStartDate,
      normalizedDate.toIso8601String().split('T')[0],
    );
  }

  /// Set special pioneer start date
  /// Always stores as first day of the month
  Future<void> setSpecialPioneerStartDate(DateTime startDate) async {
    // Normalize to first day of month
    final normalizedDate = DateTime(startDate.year, startDate.month, 1);

    // Validate: must be from September 1st of current service year or later
    final now = DateTime.now();
    final currentServiceYearStart = _getServiceYearStart(now);

    if (normalizedDate.isBefore(currentServiceYearStart)) {
      throw ArgumentError(
        'La fecha de inicio debe ser a partir del 1 de septiembre del año de servicio actual',
      );
    }

    // Store in ISO 8601 format (YYYY-MM-DD)
    await _preferences.setString(
      AppConstants.keySpecialPioneerStartDate,
      normalizedDate.toIso8601String().split('T')[0],
    );
  }

  /// Get service year start date (September 1st)
  /// If current month is before September, returns previous year's September
  /// Otherwise returns current year's September
  DateTime _getServiceYearStart(DateTime date) {
    if (date.month >= 9) {
      // September or later: service year started this year
      return DateTime(date.year, 9, 1);
    } else {
      // Before September: service year started last year
      return DateTime(date.year - 1, 9, 1);
    }
  }

  /// Set theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    await _preferences.setString(AppConstants.keyThemeMode, mode.name);
  }

  /// Persist the chosen sort option for the people list.
  Future<void> setPeopleSortOption(PeopleSortOption option) async {
    await _preferences.setString(AppConstants.keyPeopleSort, option.name);
  }

  // ==================== Deprecated Setters (for backward compatibility) ====================

  /// Set default goal type (legacy)
  @Deprecated('Use setPublisherType() instead')
  Future<void> setDefaultGoalType(GoalType type) async {
    await _preferences.setString(AppConstants.keyDefaultGoalType, type.name);
  }

  /// Set user gender (legacy string format)
  @Deprecated('Use setGender() instead')
  Future<void> setUserGender(String gender) async {
    if (gender != AppConstants.genderMale &&
        gender != AppConstants.genderFemale) {
      throw ArgumentError('Gender must be "male" or "female"');
    }
    await _preferences.setString(AppConstants.keyUserGender, gender);
  }

  /// Set user age (legacy)
  @Deprecated('Use setBirthDate() instead')
  Future<void> setUserAge(int age) async {
    if (age < 0 || age > 150) {
      throw ArgumentError('Age must be between 0 and 150');
    }
    await _preferences.setInt(AppConstants.keyUserAge, age);
  }

  // ==================== Utility Methods ====================

  /// Check if user needs to complete onboarding
  /// Returns true if any required field is missing
  bool needsOnboarding() {
    return getUserName() == null ||
        getPublisherType() == null ||
        getGender() == null ||
        getBirthDate() == null;
  }

  /// Get monthly goal hours based on current publisher type
  /// Returns null for publishers without auxiliary goal
  /// Takes into account gender and age for special pioneers
  double? getMonthlyGoalHours() {
    final type = getPublisherType();
    if (type == null) return null;

    switch (type) {
      case PublisherType.publisher:
        // Publishers don't have automatic goals
        // They need to manually set auxiliary goal if desired
        return null;

      case PublisherType.regularPioneer:
        return AppConstants.regularPioneerMonthlyHours;

      case PublisherType.specialPioneer:
        return _getSpecialPioneerHours();
    }
  }

  /// Calculate special pioneer hours based on gender and age
  /// Male: 100h
  /// Female under 40: 100h
  /// Female 40+: 90h
  double _getSpecialPioneerHours() {
    final gender = getGender();
    final userAge = age;

    // Default to 100 hours if no gender/age set
    if (gender == null) {
      return AppConstants.specialPioneerMaleHours;
    }

    // Male: always 100 hours
    if (gender == Gender.male) {
      return AppConstants.specialPioneerMaleHours;
    }

    // Female: check age
    if (gender == Gender.female) {
      if (userAge == null) {
        return AppConstants.specialPioneerFemaleUnder40Hours;
      }

      // 40 or older: 90 hours
      if (userAge >= AppConstants.specialPioneerAgeThreshold) {
        return AppConstants.specialPioneerFemaleOver40Hours;
      }

      // Under 40: 100 hours
      return AppConstants.specialPioneerFemaleUnder40Hours;
    }

    // Fallback
    return AppConstants.specialPioneerMaleHours;
  }

  /// Get target hours for a given goal type (legacy method for backward compatibility)
  /// Takes into account user's gender and age for special pioneer/missionary
  @Deprecated(
      'Use getMonthlyGoalHours() for current user or calculate directly')
  double getTargetHoursForGoal(GoalType goalType) {
    switch (goalType) {
      case GoalType.publisher:
        return 0.0; // Publishers don't track hours

      case GoalType.auxiliaryPioneer15:
        return AppConstants.auxiliaryPioneer15Hours;

      case GoalType.auxiliaryPioneer30:
        return AppConstants.auxiliaryPioneer30Hours;

      case GoalType.regularPioneer:
        return AppConstants.regularPioneerMonthlyHours;

      case GoalType.specialPioneer:
      case GoalType.missionary:
        return _getSpecialPioneerHours();
    }
  }

  /// Clear all user profile data (except theme preference)
  Future<void> clearAll() async {
    await _preferences.remove(AppConstants.keyUserName);
    await _preferences.remove(AppConstants.keyPublisherType);
    await _preferences.remove(AppConstants.keyGender);
    await _preferences.remove(AppConstants.keyBirthDate);
    await _preferences.remove(AppConstants.keyRegularPioneerStartDate);
    await _preferences.remove(AppConstants.keySpecialPioneerStartDate);
    // Also clear deprecated keys
    await _preferences.remove(AppConstants.keyDefaultGoalType);
    await _preferences.remove(AppConstants.keyUserAge);
    // Don't clear theme mode - keep user preference
  }

  // ==================== Backup / Restore ====================

  /// All SharedPreferences keys owned by this service, including theme
  /// and deprecated legacy keys. Note: `keyGender` and the legacy
  /// `keyUserGender` both resolve to the same underlying string
  /// (`'user_gender'`), so only one is listed here.
  static const List<String> _allKeys = <String>[
    AppConstants.keyUserName,
    AppConstants.keyPublisherType,
    AppConstants.keyGender,
    AppConstants.keyBirthDate,
    AppConstants.keyRegularPioneerStartDate,
    AppConstants.keySpecialPioneerStartDate,
    AppConstants.keyThemeMode,
    // ignore: deprecated_member_use_from_same_package
    AppConstants.keyDefaultGoalType,
    // ignore: deprecated_member_use_from_same_package
    AppConstants.keyUserAge,
  ];

  /// Serialize all profile-related preferences to a JSON-friendly map.
  /// Missing keys are omitted (not included as null) so the backup is compact
  /// and restoring a backup without a key leaves the current value untouched.
  Map<String, Object?> captureAsMap() {
    final prefs = _preferences;
    final map = <String, Object?>{};
    for (final key in _allKeys) {
      if (!prefs.containsKey(key)) continue;
      map[key] = prefs.get(key);
    }
    return map;
  }

  /// Restore preferences from a backup map.
  /// Clears existing profile keys first (including theme and legacy),
  /// then writes every value from [data] using its runtime type.
  Future<void> restoreFromMap(Map<String, Object?> data) async {
    final prefs = _preferences;
    for (final key in _allKeys) {
      await prefs.remove(key);
    }
    for (final entry in data.entries) {
      final value = entry.value;
      if (value == null) continue;
      if (value is String) {
        await prefs.setString(entry.key, value);
      } else if (value is int) {
        await prefs.setInt(entry.key, value);
      } else if (value is double) {
        await prefs.setDouble(entry.key, value);
      } else if (value is bool) {
        await prefs.setBool(entry.key, value);
      } else if (value is List) {
        await prefs.setStringList(
          entry.key,
          value.map((e) => e.toString()).toList(),
        );
      }
    }
  }
}
