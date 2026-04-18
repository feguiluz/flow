/// Gender for user profile
/// Used to calculate special pioneer hours (women 40+ have reduced hours)
enum Gender {
  /// Male
  male,

  /// Female
  female,
}

extension GenderExtension on Gender {
  /// Display name in Spanish for UI
  String get displayName {
    switch (this) {
      case Gender.male:
        return 'Hombre';
      case Gender.female:
        return 'Mujer';
    }
  }

  /// Serialization key for storage
  String get key {
    switch (this) {
      case Gender.male:
        return 'male';
      case Gender.female:
        return 'female';
    }
  }

  /// Parse from storage key
  static Gender fromKey(String key) {
    switch (key) {
      case 'male':
        return Gender.male;
      case 'female':
        return Gender.female;
      default:
        throw ArgumentError('Unknown gender key: $key');
    }
  }
}
