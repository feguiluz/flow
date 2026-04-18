// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'export_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$generateTextReportHash() =>
    r'2dc824040022b644f7d8f17c7c4c95fb3b70d379';

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

/// Generate text report for a specific month
///
/// Copied from [generateTextReport].
@ProviderFor(generateTextReport)
const generateTextReportProvider = GenerateTextReportFamily();

/// Generate text report for a specific month
///
/// Copied from [generateTextReport].
class GenerateTextReportFamily extends Family<AsyncValue<String>> {
  /// Generate text report for a specific month
  ///
  /// Copied from [generateTextReport].
  const GenerateTextReportFamily();

  /// Generate text report for a specific month
  ///
  /// Copied from [generateTextReport].
  GenerateTextReportProvider call(
    int year,
    int month,
  ) {
    return GenerateTextReportProvider(
      year,
      month,
    );
  }

  @override
  GenerateTextReportProvider getProviderOverride(
    covariant GenerateTextReportProvider provider,
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
  String? get name => r'generateTextReportProvider';
}

/// Generate text report for a specific month
///
/// Copied from [generateTextReport].
class GenerateTextReportProvider extends AutoDisposeFutureProvider<String> {
  /// Generate text report for a specific month
  ///
  /// Copied from [generateTextReport].
  GenerateTextReportProvider(
    int year,
    int month,
  ) : this._internal(
          (ref) => generateTextReport(
            ref as GenerateTextReportRef,
            year,
            month,
          ),
          from: generateTextReportProvider,
          name: r'generateTextReportProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$generateTextReportHash,
          dependencies: GenerateTextReportFamily._dependencies,
          allTransitiveDependencies:
              GenerateTextReportFamily._allTransitiveDependencies,
          year: year,
          month: month,
        );

  GenerateTextReportProvider._internal(
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
    FutureOr<String> Function(GenerateTextReportRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GenerateTextReportProvider._internal(
        (ref) => create(ref as GenerateTextReportRef),
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
  AutoDisposeFutureProviderElement<String> createElement() {
    return _GenerateTextReportProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GenerateTextReportProvider &&
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
mixin GenerateTextReportRef on AutoDisposeFutureProviderRef<String> {
  /// The parameter `year` of this provider.
  int get year;

  /// The parameter `month` of this provider.
  int get month;
}

class _GenerateTextReportProviderElement
    extends AutoDisposeFutureProviderElement<String>
    with GenerateTextReportRef {
  _GenerateTextReportProviderElement(super.provider);

  @override
  int get year => (origin as GenerateTextReportProvider).year;
  @override
  int get month => (origin as GenerateTextReportProvider).month;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
