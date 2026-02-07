import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/services/user_profile_service.dart';
import '../models/goal.dart';

part 'user_profile_provider.freezed.dart';
part 'user_profile_provider.g.dart';

/// User profile data model
@freezed
class UserProfileData with _$UserProfileData {
  const factory UserProfileData({
    String? name,
    GoalType? defaultGoalType,
    String? gender,
    int? age,
  }) = _UserProfileData;
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
      defaultGoalType: _service.getDefaultGoalType(),
      gender: _service.getUserGender(),
      age: _service.getUserAge(),
    );
  }

  /// Update user name
  Future<void> updateName(String name) async {
    await _service.setUserName(name);
    ref.invalidateSelf();
  }

  /// Update default goal type
  Future<void> updateDefaultGoalType(GoalType type) async {
    await _service.setDefaultGoalType(type);
    ref.invalidateSelf();
  }

  /// Update user gender
  Future<void> updateGender(String gender) async {
    await _service.setUserGender(gender);
    ref.invalidateSelf();
  }

  /// Update user age
  Future<void> updateAge(int age) async {
    await _service.setUserAge(age);
    ref.invalidateSelf();
  }

  /// Clear all profile data
  Future<void> clearProfile() async {
    await _service.clearAll();
    ref.invalidateSelf();
  }
}
