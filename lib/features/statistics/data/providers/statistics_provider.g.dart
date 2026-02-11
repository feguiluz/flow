// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$serviceYearStatisticsHash() =>
    r'28d29319247f892bbcf73721a7dbdc0b048aff81';

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

/// Provider for service year statistics
/// startYear = 2025 means September 2025 to August 2026
///
/// Copied from [serviceYearStatistics].
@ProviderFor(serviceYearStatistics)
const serviceYearStatisticsProvider = ServiceYearStatisticsFamily();

/// Provider for service year statistics
/// startYear = 2025 means September 2025 to August 2026
///
/// Copied from [serviceYearStatistics].
class ServiceYearStatisticsFamily
    extends Family<AsyncValue<ServiceYearStatistics>> {
  /// Provider for service year statistics
  /// startYear = 2025 means September 2025 to August 2026
  ///
  /// Copied from [serviceYearStatistics].
  const ServiceYearStatisticsFamily();

  /// Provider for service year statistics
  /// startYear = 2025 means September 2025 to August 2026
  ///
  /// Copied from [serviceYearStatistics].
  ServiceYearStatisticsProvider call(
    int startYear,
  ) {
    return ServiceYearStatisticsProvider(
      startYear,
    );
  }

  @override
  ServiceYearStatisticsProvider getProviderOverride(
    covariant ServiceYearStatisticsProvider provider,
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
  String? get name => r'serviceYearStatisticsProvider';
}

/// Provider for service year statistics
/// startYear = 2025 means September 2025 to August 2026
///
/// Copied from [serviceYearStatistics].
class ServiceYearStatisticsProvider
    extends AutoDisposeFutureProvider<ServiceYearStatistics> {
  /// Provider for service year statistics
  /// startYear = 2025 means September 2025 to August 2026
  ///
  /// Copied from [serviceYearStatistics].
  ServiceYearStatisticsProvider(
    int startYear,
  ) : this._internal(
          (ref) => serviceYearStatistics(
            ref as ServiceYearStatisticsRef,
            startYear,
          ),
          from: serviceYearStatisticsProvider,
          name: r'serviceYearStatisticsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$serviceYearStatisticsHash,
          dependencies: ServiceYearStatisticsFamily._dependencies,
          allTransitiveDependencies:
              ServiceYearStatisticsFamily._allTransitiveDependencies,
          startYear: startYear,
        );

  ServiceYearStatisticsProvider._internal(
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
    FutureOr<ServiceYearStatistics> Function(ServiceYearStatisticsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ServiceYearStatisticsProvider._internal(
        (ref) => create(ref as ServiceYearStatisticsRef),
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
  AutoDisposeFutureProviderElement<ServiceYearStatistics> createElement() {
    return _ServiceYearStatisticsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ServiceYearStatisticsProvider &&
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
mixin ServiceYearStatisticsRef
    on AutoDisposeFutureProviderRef<ServiceYearStatistics> {
  /// The parameter `startYear` of this provider.
  int get startYear;
}

class _ServiceYearStatisticsProviderElement
    extends AutoDisposeFutureProviderElement<ServiceYearStatistics>
    with ServiceYearStatisticsRef {
  _ServiceYearStatisticsProviderElement(super.provider);

  @override
  int get startYear => (origin as ServiceYearStatisticsProvider).startYear;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
