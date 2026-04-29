// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'people_sort_option_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$peopleSortOptionNotifierHash() =>
    r'1eefdc4229c2630890a456b1613f5ec7a51723e5';

/// Holds and persists the user's chosen sort option for the people list.
/// Mirrors the [ThemeNotifier] pattern: reads from SharedPreferences on
/// build, writes through on every mutation.
///
/// Copied from [PeopleSortOptionNotifier].
@ProviderFor(PeopleSortOptionNotifier)
final peopleSortOptionNotifierProvider = AutoDisposeNotifierProvider<
    PeopleSortOptionNotifier, PeopleSortOption>.internal(
  PeopleSortOptionNotifier.new,
  name: r'peopleSortOptionNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$peopleSortOptionNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PeopleSortOptionNotifier = AutoDisposeNotifier<PeopleSortOption>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
