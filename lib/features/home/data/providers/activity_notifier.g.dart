// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentMonthTotalMinutesHash() =>
    r'f4a451e2d1e7ad2a51f8bd46278935bcbaf7fc87';

/// Provider for calculating total minutes in the current month
///
/// Copied from [currentMonthTotalMinutes].
@ProviderFor(currentMonthTotalMinutes)
final currentMonthTotalMinutesProvider =
    AutoDisposeFutureProvider<int>.internal(
  currentMonthTotalMinutes,
  name: r'currentMonthTotalMinutesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentMonthTotalMinutesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentMonthTotalMinutesRef = AutoDisposeFutureProviderRef<int>;
String _$activitiesByMonthHash() => r'ca4930a0d34a751d44f62d9051cfcd0b1049de42';

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

/// Provider for activities of a specific month
///
/// Copied from [activitiesByMonth].
@ProviderFor(activitiesByMonth)
const activitiesByMonthProvider = ActivitiesByMonthFamily();

/// Provider for activities of a specific month
///
/// Copied from [activitiesByMonth].
class ActivitiesByMonthFamily extends Family<AsyncValue<List<Activity>>> {
  /// Provider for activities of a specific month
  ///
  /// Copied from [activitiesByMonth].
  const ActivitiesByMonthFamily();

  /// Provider for activities of a specific month
  ///
  /// Copied from [activitiesByMonth].
  ActivitiesByMonthProvider call(
    int year,
    int month,
  ) {
    return ActivitiesByMonthProvider(
      year,
      month,
    );
  }

  @override
  ActivitiesByMonthProvider getProviderOverride(
    covariant ActivitiesByMonthProvider provider,
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
  String? get name => r'activitiesByMonthProvider';
}

/// Provider for activities of a specific month
///
/// Copied from [activitiesByMonth].
class ActivitiesByMonthProvider
    extends AutoDisposeFutureProvider<List<Activity>> {
  /// Provider for activities of a specific month
  ///
  /// Copied from [activitiesByMonth].
  ActivitiesByMonthProvider(
    int year,
    int month,
  ) : this._internal(
          (ref) => activitiesByMonth(
            ref as ActivitiesByMonthRef,
            year,
            month,
          ),
          from: activitiesByMonthProvider,
          name: r'activitiesByMonthProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$activitiesByMonthHash,
          dependencies: ActivitiesByMonthFamily._dependencies,
          allTransitiveDependencies:
              ActivitiesByMonthFamily._allTransitiveDependencies,
          year: year,
          month: month,
        );

  ActivitiesByMonthProvider._internal(
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
  Override overrideWith(
    FutureOr<List<Activity>> Function(ActivitiesByMonthRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ActivitiesByMonthProvider._internal(
        (ref) => create(ref as ActivitiesByMonthRef),
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
  AutoDisposeFutureProviderElement<List<Activity>> createElement() {
    return _ActivitiesByMonthProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ActivitiesByMonthProvider &&
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
mixin ActivitiesByMonthRef on AutoDisposeFutureProviderRef<List<Activity>> {
  /// The parameter `year` of this provider.
  int get year;

  /// The parameter `month` of this provider.
  int get month;
}

class _ActivitiesByMonthProviderElement
    extends AutoDisposeFutureProviderElement<List<Activity>>
    with ActivitiesByMonthRef {
  _ActivitiesByMonthProviderElement(super.provider);

  @override
  int get year => (origin as ActivitiesByMonthProvider).year;
  @override
  int get month => (origin as ActivitiesByMonthProvider).month;
}

String _$yearlyMinutesByMonthHash() =>
    r'88a15e58ec1ccceffcb2fea6379dc1e380018330';

/// Provider for total minutes by month in a specific year
///
/// Copied from [yearlyMinutesByMonth].
@ProviderFor(yearlyMinutesByMonth)
const yearlyMinutesByMonthProvider = YearlyMinutesByMonthFamily();

/// Provider for total minutes by month in a specific year
///
/// Copied from [yearlyMinutesByMonth].
class YearlyMinutesByMonthFamily extends Family<AsyncValue<Map<int, int>>> {
  /// Provider for total minutes by month in a specific year
  ///
  /// Copied from [yearlyMinutesByMonth].
  const YearlyMinutesByMonthFamily();

  /// Provider for total minutes by month in a specific year
  ///
  /// Copied from [yearlyMinutesByMonth].
  YearlyMinutesByMonthProvider call(
    int year,
  ) {
    return YearlyMinutesByMonthProvider(
      year,
    );
  }

  @override
  YearlyMinutesByMonthProvider getProviderOverride(
    covariant YearlyMinutesByMonthProvider provider,
  ) {
    return call(
      provider.year,
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
  String? get name => r'yearlyMinutesByMonthProvider';
}

/// Provider for total minutes by month in a specific year
///
/// Copied from [yearlyMinutesByMonth].
class YearlyMinutesByMonthProvider
    extends AutoDisposeFutureProvider<Map<int, int>> {
  /// Provider for total minutes by month in a specific year
  ///
  /// Copied from [yearlyMinutesByMonth].
  YearlyMinutesByMonthProvider(
    int year,
  ) : this._internal(
          (ref) => yearlyMinutesByMonth(
            ref as YearlyMinutesByMonthRef,
            year,
          ),
          from: yearlyMinutesByMonthProvider,
          name: r'yearlyMinutesByMonthProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$yearlyMinutesByMonthHash,
          dependencies: YearlyMinutesByMonthFamily._dependencies,
          allTransitiveDependencies:
              YearlyMinutesByMonthFamily._allTransitiveDependencies,
          year: year,
        );

  YearlyMinutesByMonthProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.year,
  }) : super.internal();

  final int year;

  @override
  Override overrideWith(
    FutureOr<Map<int, int>> Function(YearlyMinutesByMonthRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: YearlyMinutesByMonthProvider._internal(
        (ref) => create(ref as YearlyMinutesByMonthRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        year: year,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<int, int>> createElement() {
    return _YearlyMinutesByMonthProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is YearlyMinutesByMonthProvider && other.year == year;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, year.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin YearlyMinutesByMonthRef on AutoDisposeFutureProviderRef<Map<int, int>> {
  /// The parameter `year` of this provider.
  int get year;
}

class _YearlyMinutesByMonthProviderElement
    extends AutoDisposeFutureProviderElement<Map<int, int>>
    with YearlyMinutesByMonthRef {
  _YearlyMinutesByMonthProviderElement(super.provider);

  @override
  int get year => (origin as YearlyMinutesByMonthProvider).year;
}

String _$activityNotifierHash() => r'be8d5081e1f962e370eac4d01d437808643cda7e';

/// Provider for managing activity data for the current month
///
/// Copied from [ActivityNotifier].
@ProviderFor(ActivityNotifier)
final activityNotifierProvider =
    AutoDisposeAsyncNotifierProvider<ActivityNotifier, List<Activity>>.internal(
  ActivityNotifier.new,
  name: r'activityNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$activityNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ActivityNotifier = AutoDisposeAsyncNotifier<List<Activity>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
