// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userProfileServiceHash() =>
    r'536095d084561b2a76ef1d2831e90c3f613bad4f';

/// Provider for user profile service instance
///
/// Copied from [userProfileService].
@ProviderFor(userProfileService)
final userProfileServiceProvider =
    AutoDisposeProvider<UserProfileService>.internal(
  userProfileService,
  name: r'userProfileServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userProfileServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserProfileServiceRef = AutoDisposeProviderRef<UserProfileService>;
String _$userProfileHash() => r'd0c31c80eb97215aa1f648898f10a963474bac45';

/// Provider for user profile data
///
/// Copied from [UserProfile].
@ProviderFor(UserProfile)
final userProfileProvider =
    AutoDisposeAsyncNotifierProvider<UserProfile, UserProfileData>.internal(
  UserProfile.new,
  name: r'userProfileProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userProfileHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UserProfile = AutoDisposeAsyncNotifier<UserProfileData>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
