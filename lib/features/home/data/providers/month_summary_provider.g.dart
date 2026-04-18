// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'month_summary_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$monthSummaryHash() => r'824bfc8a8685259b3e1b1370813187e214dfa459';

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

/// Provider for calculating month summary for a specific month
///
/// Copied from [monthSummary].
@ProviderFor(monthSummary)
const monthSummaryProvider = MonthSummaryFamily();

/// Provider for calculating month summary for a specific month
///
/// Copied from [monthSummary].
class MonthSummaryFamily extends Family<AsyncValue<MonthSummary>> {
  /// Provider for calculating month summary for a specific month
  ///
  /// Copied from [monthSummary].
  const MonthSummaryFamily();

  /// Provider for calculating month summary for a specific month
  ///
  /// Copied from [monthSummary].
  MonthSummaryProvider call(
    int year,
    int month,
  ) {
    return MonthSummaryProvider(
      year,
      month,
    );
  }

  @override
  MonthSummaryProvider getProviderOverride(
    covariant MonthSummaryProvider provider,
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
  String? get name => r'monthSummaryProvider';
}

/// Provider for calculating month summary for a specific month
///
/// Copied from [monthSummary].
class MonthSummaryProvider extends AutoDisposeFutureProvider<MonthSummary> {
  /// Provider for calculating month summary for a specific month
  ///
  /// Copied from [monthSummary].
  MonthSummaryProvider(
    int year,
    int month,
  ) : this._internal(
          (ref) => monthSummary(
            ref as MonthSummaryRef,
            year,
            month,
          ),
          from: monthSummaryProvider,
          name: r'monthSummaryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$monthSummaryHash,
          dependencies: MonthSummaryFamily._dependencies,
          allTransitiveDependencies:
              MonthSummaryFamily._allTransitiveDependencies,
          year: year,
          month: month,
        );

  MonthSummaryProvider._internal(
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
    FutureOr<MonthSummary> Function(MonthSummaryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MonthSummaryProvider._internal(
        (ref) => create(ref as MonthSummaryRef),
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
  AutoDisposeFutureProviderElement<MonthSummary> createElement() {
    return _MonthSummaryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MonthSummaryProvider &&
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
mixin MonthSummaryRef on AutoDisposeFutureProviderRef<MonthSummary> {
  /// The parameter `year` of this provider.
  int get year;

  /// The parameter `month` of this provider.
  int get month;
}

class _MonthSummaryProviderElement
    extends AutoDisposeFutureProviderElement<MonthSummary>
    with MonthSummaryRef {
  _MonthSummaryProviderElement(super.provider);

  @override
  int get year => (origin as MonthSummaryProvider).year;
  @override
  int get month => (origin as MonthSummaryProvider).month;
}

String _$currentMonthSummaryHash() =>
    r'337973ade11039b09d327d7fc501de3d7f987517';

/// Provider for current month summary
///
/// Copied from [currentMonthSummary].
@ProviderFor(currentMonthSummary)
final currentMonthSummaryProvider =
    AutoDisposeFutureProvider<MonthSummary>.internal(
  currentMonthSummary,
  name: r'currentMonthSummaryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentMonthSummaryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentMonthSummaryRef = AutoDisposeFutureProviderRef<MonthSummary>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
