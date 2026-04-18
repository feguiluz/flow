// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participation_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentMonthParticipationHash() =>
    r'04e5fd26d0c8cb659e01f5c624fd383472f2c96e';

/// Provider for current month's participation
///
/// Copied from [currentMonthParticipation].
@ProviderFor(currentMonthParticipation)
final currentMonthParticipationProvider =
    AutoDisposeFutureProvider<Participation?>.internal(
  currentMonthParticipation,
  name: r'currentMonthParticipationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentMonthParticipationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentMonthParticipationRef
    = AutoDisposeFutureProviderRef<Participation?>;
String _$participationNotifierHash() =>
    r'037b3e898268974d970f3cd43a64bf766c4e02d1';

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

abstract class _$ParticipationNotifier
    extends BuildlessAutoDisposeAsyncNotifier<Participation?> {
  late final int year;
  late final int month;

  FutureOr<Participation?> build(
    int year,
    int month,
  );
}

/// Provider for managing monthly participation
///
/// Copied from [ParticipationNotifier].
@ProviderFor(ParticipationNotifier)
const participationNotifierProvider = ParticipationNotifierFamily();

/// Provider for managing monthly participation
///
/// Copied from [ParticipationNotifier].
class ParticipationNotifierFamily extends Family<AsyncValue<Participation?>> {
  /// Provider for managing monthly participation
  ///
  /// Copied from [ParticipationNotifier].
  const ParticipationNotifierFamily();

  /// Provider for managing monthly participation
  ///
  /// Copied from [ParticipationNotifier].
  ParticipationNotifierProvider call(
    int year,
    int month,
  ) {
    return ParticipationNotifierProvider(
      year,
      month,
    );
  }

  @override
  ParticipationNotifierProvider getProviderOverride(
    covariant ParticipationNotifierProvider provider,
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
  String? get name => r'participationNotifierProvider';
}

/// Provider for managing monthly participation
///
/// Copied from [ParticipationNotifier].
class ParticipationNotifierProvider
    extends AutoDisposeAsyncNotifierProviderImpl<ParticipationNotifier,
        Participation?> {
  /// Provider for managing monthly participation
  ///
  /// Copied from [ParticipationNotifier].
  ParticipationNotifierProvider(
    int year,
    int month,
  ) : this._internal(
          () => ParticipationNotifier()
            ..year = year
            ..month = month,
          from: participationNotifierProvider,
          name: r'participationNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$participationNotifierHash,
          dependencies: ParticipationNotifierFamily._dependencies,
          allTransitiveDependencies:
              ParticipationNotifierFamily._allTransitiveDependencies,
          year: year,
          month: month,
        );

  ParticipationNotifierProvider._internal(
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
  FutureOr<Participation?> runNotifierBuild(
    covariant ParticipationNotifier notifier,
  ) {
    return notifier.build(
      year,
      month,
    );
  }

  @override
  Override overrideWith(ParticipationNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: ParticipationNotifierProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<ParticipationNotifier, Participation?>
      createElement() {
    return _ParticipationNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ParticipationNotifierProvider &&
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
mixin ParticipationNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<Participation?> {
  /// The parameter `year` of this provider.
  int get year;

  /// The parameter `month` of this provider.
  int get month;
}

class _ParticipationNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ParticipationNotifier,
        Participation?> with ParticipationNotifierRef {
  _ParticipationNotifierProviderElement(super.provider);

  @override
  int get year => (origin as ParticipationNotifierProvider).year;
  @override
  int get month => (origin as ParticipationNotifierProvider).month;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
