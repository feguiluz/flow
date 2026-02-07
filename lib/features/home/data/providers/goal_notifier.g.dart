// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentMonthGoalHash() => r'66bbdffaa4eb58c73dde4c882bd852ee8539d9c0';

/// Provider for current month's goal
///
/// Copied from [currentMonthGoal].
@ProviderFor(currentMonthGoal)
final currentMonthGoalProvider = AutoDisposeFutureProvider<Goal?>.internal(
  currentMonthGoal,
  name: r'currentMonthGoalProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentMonthGoalHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentMonthGoalRef = AutoDisposeFutureProviderRef<Goal?>;
String _$goalNotifierHash() => r'3f5d64648858ea4610e89a67fc86d56a1eb81662';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$GoalNotifier extends BuildlessAutoDisposeAsyncNotifier<Goal?> {
  late final int year;
  late final int month;

  FutureOr<Goal?> build(
    int year,
    int month,
  );
}

/// Provider for managing monthly goals
///
/// Copied from [GoalNotifier].
@ProviderFor(GoalNotifier)
const goalNotifierProvider = GoalNotifierFamily();

/// Provider for managing monthly goals
///
/// Copied from [GoalNotifier].
class GoalNotifierFamily extends Family<AsyncValue<Goal?>> {
  /// Provider for managing monthly goals
  ///
  /// Copied from [GoalNotifier].
  const GoalNotifierFamily();

  /// Provider for managing monthly goals
  ///
  /// Copied from [GoalNotifier].
  GoalNotifierProvider call(
    int year,
    int month,
  ) {
    return GoalNotifierProvider(
      year,
      month,
    );
  }

  @override
  GoalNotifierProvider getProviderOverride(
    covariant GoalNotifierProvider provider,
  ) {
    return call(
      provider.year,
      provider.month,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'goalNotifierProvider';
}

/// Provider for managing monthly goals
///
/// Copied from [GoalNotifier].
class GoalNotifierProvider
    extends AutoDisposeAsyncNotifierProviderImpl<GoalNotifier, Goal?> {
  /// Provider for managing monthly goals
  ///
  /// Copied from [GoalNotifier].
  GoalNotifierProvider(
    int year,
    int month,
  ) : this._internal(
          () => GoalNotifier()
            ..year = year
            ..month = month,
          from: goalNotifierProvider,
          name: r'goalNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$goalNotifierHash,
          dependencies: GoalNotifierFamily._dependencies,
          allTransitiveDependencies:
              GoalNotifierFamily._allTransitiveDependencies,
          year: year,
          month: month,
        );

  GoalNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.year,
    required this.month,
  }) : super.internal();

  final int year;
  final int month;

  @override
  FutureOr<Goal?> runNotifierBuild(
    covariant GoalNotifier notifier,
  ) {
    return notifier.build(
      year,
      month,
    );
  }

  @override
  Override overrideWith(GoalNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: GoalNotifierProvider._internal(
        () => create()
          ..year = year
          ..month = month,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        year: year,
        month: month,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<GoalNotifier, Goal?> createElement() {
    return _GoalNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GoalNotifierProvider &&
        other.year == year &&
        other.month == month;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, year.hashCode);
    hash = _SystemHash.combine(hash, month.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GoalNotifierRef on AutoDisposeAsyncNotifierProviderRef<Goal?> {
  /// The parameter `year` of this provider.
  int get year;

  /// The parameter `month` of this provider.
  int get month;
}

class _GoalNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<GoalNotifier, Goal?>
    with GoalNotifierRef {
  _GoalNotifierProviderElement(super.provider);

  @override
  int get year => (origin as GoalNotifierProvider).year;
  @override
  int get month => (origin as GoalNotifierProvider).month;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
