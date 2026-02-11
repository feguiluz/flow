import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flow/core/services/user_profile_service.dart';
import 'package:flow/shared/models/gender.dart';
import 'package:flow/shared/models/goal.dart';
import 'package:flow/shared/models/publisher_type.dart';

part 'user_profile_provider.freezed.dart';
part 'user_profile_provider.g.dart';

/// User profile data model
@freezed
class UserProfileData with _$UserProfileData {
  const UserProfileData._();

  const factory UserProfileData({
    String? name,
    PublisherType? publisherType,
    Gender? gender,
    DateTime? birthDate,
    int? age,
    DateTime? regularPioneerStartDate,
    DateTime? specialPioneerStartDate,
    // Deprecated fields for backward compatibility
    @Deprecated('Use publisherType instead') GoalType? defaultGoalType,
  }) = _UserProfileData;

  /// Get monthly goal hours based on publisher type
  double? get monthlyGoalHours {
    switch (publisherType) {
      case PublisherType.publisher:
        return null; // Publishers don't have automatic goals
      case PublisherType.regularPioneer:
        return 50.0;
      case PublisherType.specialPioneer:
        if (gender == Gender.male) return 100.0;
        if (age != null && age! >= 40) return 90.0;
        return 100.0;
      default:
        return null;
    }
  }
}

/// Provider for user profile service instance
@riverpod
UserProfileService userProfileService(UserProfileServiceRef ref) {
  return UserProfileService.instance;
}

/// Provider for user profile data
@riverpod
class UserProfile extends _$UserProfile {
  late UserProfileService _service;

  @override
  Future<UserProfileData> build() async {
    _service = ref.watch(userProfileServiceProvider);
    await _service.init();

    return UserProfileData(
      name: _service.getUserName(),
      publisherType: _service.getPublisherType(),
      gender: _service.getGender(),
      birthDate: _service.getBirthDate(),
      age: _service.age,
      regularPioneerStartDate: _service.getRegularPioneerStartDate(),
      specialPioneerStartDate: _service.getSpecialPioneerStartDate(),
      defaultGoalType: _service.getDefaultGoalType(),
    );
  }

  /// Update user name
  Future<void> updateName(String name) async {
    await _service.setUserName(name);
    ref.invalidateSelf();
  }

  /// Update publisher type
  Future<void> updatePublisherType(PublisherType type) async {
    await _service.setPublisherType(type);
    ref.invalidateSelf();
  }

  /// Update gender
  Future<void> updateGender(Gender gender) async {
    await _service.setGender(gender);
    ref.invalidateSelf();
  }

  /// Update birth date
  Future<void> updateBirthDate(DateTime birthDate) async {
    await _service.setBirthDate(birthDate);
    ref.invalidateSelf();
  }

  /// Update default goal type (deprecated)
  @Deprecated('Use updatePublisherType instead')
  Future<void> updateDefaultGoalType(GoalType type) async {
    await _service.setDefaultGoalType(type);
    ref.invalidateSelf();
  }

  /// Clear all profile data
  Future<void> clearProfile() async {
    await _service.clearAll();
    ref.invalidateSelf();
  }
}
