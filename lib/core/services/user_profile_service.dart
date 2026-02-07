import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/models/goal.dart';
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

  /// Get user name
  String? getUserName() {
    return _preferences.getString(AppConstants.keyUserName);
  }

  /// Get default goal type
  GoalType? getDefaultGoalType() {
    final value = _preferences.getString(AppConstants.keyDefaultGoalType);
    if (value == null) return null;

    try {
      return GoalType.values.firstWhere((e) => e.name == value);
    } catch (_) {
      return null;
    }
  }

  /// Get user gender ('male' or 'female')
  String? getUserGender() {
    return _preferences.getString(AppConstants.keyUserGender);
  }

  /// Get user age
  int? getUserAge() {
    return _preferences.getInt(AppConstants.keyUserAge);
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

  // ==================== Setters ====================

  /// Set user name
  Future<void> setUserName(String name) async {
    await _preferences.setString(AppConstants.keyUserName, name);
  }

  /// Set default goal type
  Future<void> setDefaultGoalType(GoalType type) async {
    await _preferences.setString(AppConstants.keyDefaultGoalType, type.name);
  }

  /// Set user gender
  Future<void> setUserGender(String gender) async {
    if (gender != AppConstants.genderMale &&
        gender != AppConstants.genderFemale) {
      throw ArgumentError('Gender must be "male" or "female"');
    }
    await _preferences.setString(AppConstants.keyUserGender, gender);
  }

  /// Set user age
  Future<void> setUserAge(int age) async {
    if (age < 0 || age > 150) {
      throw ArgumentError('Age must be between 0 and 150');
    }
    await _preferences.setInt(AppConstants.keyUserAge, age);
  }

  /// Set theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    await _preferences.setString(AppConstants.keyThemeMode, mode.name);
  }

  // ==================== Utility Methods ====================

  /// Get target hours for a given goal type
  /// Takes into account user's gender and age for special pioneer/missionary
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

  /// Calculate special pioneer/missionary hours based on gender and age
  double _getSpecialPioneerHours() {
    final gender = getUserGender();
    final age = getUserAge();

    // If no gender set, default to 100 hours
    if (gender == null) {
      return AppConstants.specialPioneerMaleHours;
    }

    // Male: always 100 hours
    if (gender == AppConstants.genderMale) {
      return AppConstants.specialPioneerMaleHours;
    }

    // Female: check age
    if (gender == AppConstants.genderFemale) {
      // If no age set, default to 100 hours
      if (age == null) {
        return AppConstants.specialPioneerFemaleUnder40Hours;
      }

      // 40 or older: 90 hours
      if (age >= AppConstants.specialPioneerAgeThreshold) {
        return AppConstants.specialPioneerFemaleOver40Hours;
      }

      // Under 40: 100 hours
      return AppConstants.specialPioneerFemaleUnder40Hours;
    }

    // Fallback
    return AppConstants.specialPioneerMaleHours;
  }

  /// Clear all user profile data
  Future<void> clearAll() async {
    await _preferences.remove(AppConstants.keyUserName);
    await _preferences.remove(AppConstants.keyDefaultGoalType);
    await _preferences.remove(AppConstants.keyUserGender);
    await _preferences.remove(AppConstants.keyUserAge);
    // Don't clear theme mode - keep user preference
  }
}
