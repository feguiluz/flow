// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$backupServiceHash() => r'9ba40a180ea12b5d6f80fa527966377c3d3c4dea';

/// Provider for the singleton [BackupService].
///
/// Copied from [backupService].
@ProviderFor(backupService)
final backupServiceProvider = AutoDisposeProvider<BackupService>.internal(
  backupService,
  name: r'backupServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$backupServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BackupServiceRef = AutoDisposeProviderRef<BackupService>;
String _$backupNotifierHash() => r'bb84ea47e64d5c1eba13d223dc37d9799a94afe6';

/// Orchestrates export/import flows from the UI. Exposes async methods
/// rather than state because the operations are one-shot and the UI
/// already uses dialogs / banners to communicate progress and outcome.
///
/// Copied from [BackupNotifier].
@ProviderFor(BackupNotifier)
final backupNotifierProvider =
    AutoDisposeAsyncNotifierProvider<BackupNotifier, void>.internal(
  BackupNotifier.new,
  name: r'backupNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$backupNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BackupNotifier = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
