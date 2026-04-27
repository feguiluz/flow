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
String _$activitiesByMonthHash() => r'af481a33207806a3d4354a990e980150b95c877a';

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
    r'96f8c4a47446325738832833e59ea7d2f858dde5';

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

String _$minutesByDayForMonthHash() =>
    r'8f7a8cf53311eb9e8cca91b364194ae4b7d9b8ca';

/// Provider for minutes per day inside a specific month.
/// Used by the calendar to mark active days and show per-day totals.
///
/// Copied from [minutesByDayForMonth].
@ProviderFor(minutesByDayForMonth)
const minutesByDayForMonthProvider = MinutesByDayForMonthFamily();

/// Provider for minutes per day inside a specific month.
/// Used by the calendar to mark active days and show per-day totals.
///
/// Copied from [minutesByDayForMonth].
class MinutesByDayForMonthFamily extends Family<AsyncValue<Map<int, int>>> {
  /// Provider for minutes per day inside a specific month.
  /// Used by the calendar to mark active days and show per-day totals.
  ///
  /// Copied from [minutesByDayForMonth].
  const MinutesByDayForMonthFamily();

  /// Provider for minutes per day inside a specific month.
  /// Used by the calendar to mark active days and show per-day totals.
  ///
  /// Copied from [minutesByDayForMonth].
  MinutesByDayForMonthProvider call(
    int year,
    int month,
  ) {
    return MinutesByDayForMonthProvider(
      year,
      month,
    );
  }

  @override
  MinutesByDayForMonthProvider getProviderOverride(
    covariant MinutesByDayForMonthProvider provider,
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
  String? get name => r'minutesByDayForMonthProvider';
}

/// Provider for minutes per day inside a specific month.
/// Used by the calendar to mark active days and show per-day totals.
///
/// Copied from [minutesByDayForMonth].
class MinutesByDayForMonthProvider
    extends AutoDisposeFutureProvider<Map<int, int>> {
  /// Provider for minutes per day inside a specific month.
  /// Used by the calendar to mark active days and show per-day totals.
  ///
  /// Copied from [minutesByDayForMonth].
  MinutesByDayForMonthProvider(
    int year,
    int month,
  ) : this._internal(
          (ref) => minutesByDayForMonth(
            ref as MinutesByDayForMonthRef,
            year,
            month,
          ),
          from: minutesByDayForMonthProvider,
          name: r'minutesByDayForMonthProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$minutesByDayForMonthHash,
          dependencies: MinutesByDayForMonthFamily._dependencies,
          allTransitiveDependencies:
              MinutesByDayForMonthFamily._allTransitiveDependencies,
          year: year,
          month: month,
        );

  MinutesByDayForMonthProvider._internal(
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
    FutureOr<Map<int, int>> Function(MinutesByDayForMonthRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MinutesByDayForMonthProvider._internal(
        (ref) => create(ref as MinutesByDayForMonthRef),
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
  AutoDisposeFutureProviderElement<Map<int, int>> createElement() {
    return _MinutesByDayForMonthProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MinutesByDayForMonthProvider &&
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
mixin MinutesByDayForMonthRef on AutoDisposeFutureProviderRef<Map<int, int>> {
  /// The parameter `year` of this provider.
  int get year;

  /// The parameter `month` of this provider.
  int get month;
}

class _MinutesByDayForMonthProviderElement
    extends AutoDisposeFutureProviderElement<Map<int, int>>
    with MinutesByDayForMonthRef {
  _MinutesByDayForMonthProviderElement(super.provider);

  @override
  int get year => (origin as MinutesByDayForMonthProvider).year;
  @override
  int get month => (origin as MinutesByDayForMonthProvider).month;
}

String _$getTotalMinutesForMonthHash() =>
    r'f00e0c3ca5351106fe4417dee7e305eca57f7fb8';

/// Provider for total minutes in a specific month
///
/// Copied from [getTotalMinutesForMonth].
@ProviderFor(getTotalMinutesForMonth)
const getTotalMinutesForMonthProvider = GetTotalMinutesForMonthFamily();

/// Provider for total minutes in a specific month
///
/// Copied from [getTotalMinutesForMonth].
class GetTotalMinutesForMonthFamily extends Family<AsyncValue<int>> {
  /// Provider for total minutes in a specific month
  ///
  /// Copied from [getTotalMinutesForMonth].
  const GetTotalMinutesForMonthFamily();

  /// Provider for total minutes in a specific month
  ///
  /// Copied from [getTotalMinutesForMonth].
  GetTotalMinutesForMonthProvider call({
    required int year,
    required int month,
  }) {
    return GetTotalMinutesForMonthProvider(
      year: year,
      month: month,
    );
  }

  @override
  GetTotalMinutesForMonthProvider getProviderOverride(
    covariant GetTotalMinutesForMonthProvider provider,
  ) {
    return call(
      year: provider.year,
      month: provider.month,
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
  String? get name => r'getTotalMinutesForMonthProvider';
}

/// Provider for total minutes in a specific month
///
/// Copied from [getTotalMinutesForMonth].
class GetTotalMinutesForMonthProvider extends AutoDisposeFutureProvider<int> {
  /// Provider for total minutes in a specific month
  ///
  /// Copied from [getTotalMinutesForMonth].
  GetTotalMinutesForMonthProvider({
    required int year,
    required int month,
  }) : this._internal(
          (ref) => getTotalMinutesForMonth(
            ref as GetTotalMinutesForMonthRef,
            year: year,
            month: month,
          ),
          from: getTotalMinutesForMonthProvider,
          name: r'getTotalMinutesForMonthProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getTotalMinutesForMonthHash,
          dependencies: GetTotalMinutesForMonthFamily._dependencies,
          allTransitiveDependencies:
              GetTotalMinutesForMonthFamily._allTransitiveDependencies,
          year: year,
          month: month,
        );

  GetTotalMinutesForMonthProvider._internal(
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
    FutureOr<int> Function(GetTotalMinutesForMonthRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetTotalMinutesForMonthProvider._internal(
        (ref) => create(ref as GetTotalMinutesForMonthRef),
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
  AutoDisposeFutureProviderElement<int> createElement() {
    return _GetTotalMinutesForMonthProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetTotalMinutesForMonthProvider &&
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
mixin GetTotalMinutesForMonthRef on AutoDisposeFutureProviderRef<int> {
  /// The parameter `year` of this provider.
  int get year;

  /// The parameter `month` of this provider.
  int get month;
}

class _GetTotalMinutesForMonthProviderElement
    extends AutoDisposeFutureProviderElement<int>
    with GetTotalMinutesForMonthRef {
  _GetTotalMinutesForMonthProviderElement(super.provider);

  @override
  int get year => (origin as GetTotalMinutesForMonthProvider).year;
  @override
  int get month => (origin as GetTotalMinutesForMonthProvider).month;
}

String _$serviceYearTotalMinutesHash() =>
    r'8305b7d1b517f3ca9d934da5673f041b4dd13e37';

/// Provider for service year total minutes
/// startYear = 2025 means Sep 2025 - Aug 2026
///
/// Copied from [serviceYearTotalMinutes].
@ProviderFor(serviceYearTotalMinutes)
const serviceYearTotalMinutesProvider = ServiceYearTotalMinutesFamily();

/// Provider for service year total minutes
/// startYear = 2025 means Sep 2025 - Aug 2026
///
/// Copied from [serviceYearTotalMinutes].
class ServiceYearTotalMinutesFamily extends Family<AsyncValue<int>> {
  /// Provider for service year total minutes
  /// startYear = 2025 means Sep 2025 - Aug 2026
  ///
  /// Copied from [serviceYearTotalMinutes].
  const ServiceYearTotalMinutesFamily();

  /// Provider for service year total minutes
  /// startYear = 2025 means Sep 2025 - Aug 2026
  ///
  /// Copied from [serviceYearTotalMinutes].
  ServiceYearTotalMinutesProvider call(
    int startYear,
  ) {
    return ServiceYearTotalMinutesProvider(
      startYear,
    );
  }

  @override
  ServiceYearTotalMinutesProvider getProviderOverride(
    covariant ServiceYearTotalMinutesProvider provider,
  ) {
    return call(
      provider.startYear,
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
  String? get name => r'serviceYearTotalMinutesProvider';
}

/// Provider for service year total minutes
/// startYear = 2025 means Sep 2025 - Aug 2026
///
/// Copied from [serviceYearTotalMinutes].
class ServiceYearTotalMinutesProvider extends AutoDisposeFutureProvider<int> {
  /// Provider for service year total minutes
  /// startYear = 2025 means Sep 2025 - Aug 2026
  ///
  /// Copied from [serviceYearTotalMinutes].
  ServiceYearTotalMinutesProvider(
    int startYear,
  ) : this._internal(
          (ref) => serviceYearTotalMinutes(
            ref as ServiceYearTotalMinutesRef,
            startYear,
          ),
          from: serviceYearTotalMinutesProvider,
          name: r'serviceYearTotalMinutesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$serviceYearTotalMinutesHash,
          dependencies: ServiceYearTotalMinutesFamily._dependencies,
          allTransitiveDependencies:
              ServiceYearTotalMinutesFamily._allTransitiveDependencies,
          startYear: startYear,
        );

  ServiceYearTotalMinutesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.startYear,
  }) : super.internal();

  final int startYear;

  @override
  Override overrideWith(
    FutureOr<int> Function(ServiceYearTotalMinutesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ServiceYearTotalMinutesProvider._internal(
        (ref) => create(ref as ServiceYearTotalMinutesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        startYear: startYear,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<int> createElement() {
    return _ServiceYearTotalMinutesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ServiceYearTotalMinutesProvider &&
        other.startYear == startYear;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, startYear.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ServiceYearTotalMinutesRef on AutoDisposeFutureProviderRef<int> {
  /// The parameter `startYear` of this provider.
  int get startYear;
}

class _ServiceYearTotalMinutesProviderElement
    extends AutoDisposeFutureProviderElement<int>
    with ServiceYearTotalMinutesRef {
  _ServiceYearTotalMinutesProviderElement(super.provider);

  @override
  int get startYear => (origin as ServiceYearTotalMinutesProvider).startYear;
}

String _$serviceYearTotalUpToHash() =>
    r'33ce8adb6edf1682c143425f03f6243d4211f8cd';

/// Provider for service year total UP TO a specific date
/// Used for showing accumulated progress
///
/// Copied from [serviceYearTotalUpTo].
@ProviderFor(serviceYearTotalUpTo)
const serviceYearTotalUpToProvider = ServiceYearTotalUpToFamily();

/// Provider for service year total UP TO a specific date
/// Used for showing accumulated progress
///
/// Copied from [serviceYearTotalUpTo].
class ServiceYearTotalUpToFamily extends Family<AsyncValue<int>> {
  /// Provider for service year total UP TO a specific date
  /// Used for showing accumulated progress
  ///
  /// Copied from [serviceYearTotalUpTo].
  const ServiceYearTotalUpToFamily();

  /// Provider for service year total UP TO a specific date
  /// Used for showing accumulated progress
  ///
  /// Copied from [serviceYearTotalUpTo].
  ServiceYearTotalUpToProvider call({
    required int startYear,
    required DateTime upToDate,
  }) {
    return ServiceYearTotalUpToProvider(
      startYear: startYear,
      upToDate: upToDate,
    );
  }

  @override
  ServiceYearTotalUpToProvider getProviderOverride(
    covariant ServiceYearTotalUpToProvider provider,
  ) {
    return call(
      startYear: provider.startYear,
      upToDate: provider.upToDate,
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
  String? get name => r'serviceYearTotalUpToProvider';
}

/// Provider for service year total UP TO a specific date
/// Used for showing accumulated progress
///
/// Copied from [serviceYearTotalUpTo].
class ServiceYearTotalUpToProvider extends AutoDisposeFutureProvider<int> {
  /// Provider for service year total UP TO a specific date
  /// Used for showing accumulated progress
  ///
  /// Copied from [serviceYearTotalUpTo].
  ServiceYearTotalUpToProvider({
    required int startYear,
    required DateTime upToDate,
  }) : this._internal(
          (ref) => serviceYearTotalUpTo(
            ref as ServiceYearTotalUpToRef,
            startYear: startYear,
            upToDate: upToDate,
          ),
          from: serviceYearTotalUpToProvider,
          name: r'serviceYearTotalUpToProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$serviceYearTotalUpToHash,
          dependencies: ServiceYearTotalUpToFamily._dependencies,
          allTransitiveDependencies:
              ServiceYearTotalUpToFamily._allTransitiveDependencies,
          startYear: startYear,
          upToDate: upToDate,
        );

  ServiceYearTotalUpToProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.startYear,
    required this.upToDate,
  }) : super.internal();

  final int startYear;
  final DateTime upToDate;

  @override
  Override overrideWith(
    FutureOr<int> Function(ServiceYearTotalUpToRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ServiceYearTotalUpToProvider._internal(
        (ref) => create(ref as ServiceYearTotalUpToRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        startYear: startYear,
        upToDate: upToDate,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<int> createElement() {
    return _ServiceYearTotalUpToProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ServiceYearTotalUpToProvider &&
        other.startYear == startYear &&
        other.upToDate == upToDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, startYear.hashCode);
    hash = _SystemHash.combine(hash, upToDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ServiceYearTotalUpToRef on AutoDisposeFutureProviderRef<int> {
  /// The parameter `startYear` of this provider.
  int get startYear;

  /// The parameter `upToDate` of this provider.
  DateTime get upToDate;
}

class _ServiceYearTotalUpToProviderElement
    extends AutoDisposeFutureProviderElement<int> with ServiceYearTotalUpToRef {
  _ServiceYearTotalUpToProviderElement(super.provider);

  @override
  int get startYear => (origin as ServiceYearTotalUpToProvider).startYear;
  @override
  DateTime get upToDate => (origin as ServiceYearTotalUpToProvider).upToDate;
}

String _$activityNotifierHash() => r'c4412892ec1e62e46d52f3a1d991effedf989958';

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
