// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentMonthTotalHoursHash() =>
    r'd09e6ee991fec14ec330a299fd6872dd87b20f9b';

/// Provider for calculating total hours in the current month
///
/// Copied from [currentMonthTotalHours].
@ProviderFor(currentMonthTotalHours)
final currentMonthTotalHoursProvider =
    AutoDisposeFutureProvider<double>.internal(
  currentMonthTotalHours,
  name: r'currentMonthTotalHoursProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentMonthTotalHoursHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentMonthTotalHoursRef = AutoDisposeFutureProviderRef<double>;
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

String _$yearlyHoursByMonthHash() =>
    r'a5d4e3457fae9c088fb3f310e48f5148bd69428c';

/// Provider for total hours by month in a specific year
///
/// Copied from [yearlyHoursByMonth].
@ProviderFor(yearlyHoursByMonth)
const yearlyHoursByMonthProvider = YearlyHoursByMonthFamily();

/// Provider for total hours by month in a specific year
///
/// Copied from [yearlyHoursByMonth].
class YearlyHoursByMonthFamily extends Family<AsyncValue<Map<int, double>>> {
  /// Provider for total hours by month in a specific year
  ///
  /// Copied from [yearlyHoursByMonth].
  const YearlyHoursByMonthFamily();

  /// Provider for total hours by month in a specific year
  ///
  /// Copied from [yearlyHoursByMonth].
  YearlyHoursByMonthProvider call(
    int year,
  ) {
    return YearlyHoursByMonthProvider(
      year,
    );
  }

  @override
  YearlyHoursByMonthProvider getProviderOverride(
    covariant YearlyHoursByMonthProvider provider,
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
  String? get name => r'yearlyHoursByMonthProvider';
}

/// Provider for total hours by month in a specific year
///
/// Copied from [yearlyHoursByMonth].
class YearlyHoursByMonthProvider
    extends AutoDisposeFutureProvider<Map<int, double>> {
  /// Provider for total hours by month in a specific year
  ///
  /// Copied from [yearlyHoursByMonth].
  YearlyHoursByMonthProvider(
    int year,
  ) : this._internal(
          (ref) => yearlyHoursByMonth(
            ref as YearlyHoursByMonthRef,
            year,
          ),
          from: yearlyHoursByMonthProvider,
          name: r'yearlyHoursByMonthProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$yearlyHoursByMonthHash,
          dependencies: YearlyHoursByMonthFamily._dependencies,
          allTransitiveDependencies:
              YearlyHoursByMonthFamily._allTransitiveDependencies,
          year: year,
        );

  YearlyHoursByMonthProvider._internal(
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
    FutureOr<Map<int, double>> Function(YearlyHoursByMonthRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: YearlyHoursByMonthProvider._internal(
        (ref) => create(ref as YearlyHoursByMonthRef),
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
  AutoDisposeFutureProviderElement<Map<int, double>> createElement() {
    return _YearlyHoursByMonthProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is YearlyHoursByMonthProvider && other.year == year;
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
mixin YearlyHoursByMonthRef on AutoDisposeFutureProviderRef<Map<int, double>> {
  /// The parameter `year` of this provider.
  int get year;
}

class _YearlyHoursByMonthProviderElement
    extends AutoDisposeFutureProviderElement<Map<int, double>>
    with YearlyHoursByMonthRef {
  _YearlyHoursByMonthProviderElement(super.provider);

  @override
  int get year => (origin as YearlyHoursByMonthProvider).year;
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
