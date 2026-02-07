// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bibleStudiesHash() => r'27064fb7d76e8b787be9f5fbb186965dd916bea7';

/// Provider for Bible studies only
///
/// Copied from [bibleStudies].
@ProviderFor(bibleStudies)
final bibleStudiesProvider = AutoDisposeFutureProvider<List<Person>>.internal(
  bibleStudies,
  name: r'bibleStudiesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$bibleStudiesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BibleStudiesRef = AutoDisposeFutureProviderRef<List<Person>>;
String _$interestedPersonsHash() => r'a09a858037ba3745478f16b8b7947a165042c049';

/// Provider for interested persons only (not Bible studies)
///
/// Copied from [interestedPersons].
@ProviderFor(interestedPersons)
final interestedPersonsProvider =
    AutoDisposeFutureProvider<List<Person>>.internal(
  interestedPersons,
  name: r'interestedPersonsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$interestedPersonsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef InterestedPersonsRef = AutoDisposeFutureProviderRef<List<Person>>;
String _$bibleStudiesCountHash() => r'a39efb0e1c4bec26924cd84ef10c5667a935997a';

/// Provider for Bible studies count
///
/// Copied from [bibleStudiesCount].
@ProviderFor(bibleStudiesCount)
final bibleStudiesCountProvider = AutoDisposeFutureProvider<int>.internal(
  bibleStudiesCount,
  name: r'bibleStudiesCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$bibleStudiesCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BibleStudiesCountRef = AutoDisposeFutureProviderRef<int>;
String _$interestedPersonsCountHash() =>
    r'2d7497250b196a3c5d207ccec76f3608ddfc1eef';

/// Provider for interested persons count
///
/// Copied from [interestedPersonsCount].
@ProviderFor(interestedPersonsCount)
final interestedPersonsCountProvider = AutoDisposeFutureProvider<int>.internal(
  interestedPersonsCount,
  name: r'interestedPersonsCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$interestedPersonsCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef InterestedPersonsCountRef = AutoDisposeFutureProviderRef<int>;
String _$personByIdHash() => r'3731aa6fe3ca054d0e2670dde8ace36c0b549522';

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

/// Provider for a specific person by ID
///
/// Copied from [personById].
@ProviderFor(personById)
const personByIdProvider = PersonByIdFamily();

/// Provider for a specific person by ID
///
/// Copied from [personById].
class PersonByIdFamily extends Family<AsyncValue<Person?>> {
  /// Provider for a specific person by ID
  ///
  /// Copied from [personById].
  const PersonByIdFamily();

  /// Provider for a specific person by ID
  ///
  /// Copied from [personById].
  PersonByIdProvider call(
    int id,
  ) {
    return PersonByIdProvider(
      id,
    );
  }

  @override
  PersonByIdProvider getProviderOverride(
    covariant PersonByIdProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'personByIdProvider';
}

/// Provider for a specific person by ID
///
/// Copied from [personById].
class PersonByIdProvider extends AutoDisposeFutureProvider<Person?> {
  /// Provider for a specific person by ID
  ///
  /// Copied from [personById].
  PersonByIdProvider(
    int id,
  ) : this._internal(
          (ref) => personById(
            ref as PersonByIdRef,
            id,
          ),
          from: personByIdProvider,
          name: r'personByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$personByIdHash,
          dependencies: PersonByIdFamily._dependencies,
          allTransitiveDependencies:
              PersonByIdFamily._allTransitiveDependencies,
          id: id,
        );

  PersonByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  Override overrideWith(
    FutureOr<Person?> Function(PersonByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PersonByIdProvider._internal(
        (ref) => create(ref as PersonByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Person?> createElement() {
    return _PersonByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PersonByIdProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PersonByIdRef on AutoDisposeFutureProviderRef<Person?> {
  /// The parameter `id` of this provider.
  int get id;
}

class _PersonByIdProviderElement
    extends AutoDisposeFutureProviderElement<Person?> with PersonByIdRef {
  _PersonByIdProviderElement(super.provider);

  @override
  int get id => (origin as PersonByIdProvider).id;
}

String _$personNotifierHash() => r'6738497238eb5597d1946f611723b72e6cdec505';

/// Provider for managing person data (Bible studies and interested persons)
///
/// Copied from [PersonNotifier].
@ProviderFor(PersonNotifier)
final personNotifierProvider =
    AutoDisposeAsyncNotifierProvider<PersonNotifier, List<Person>>.internal(
  PersonNotifier.new,
  name: r'personNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$personNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PersonNotifier = AutoDisposeAsyncNotifier<List<Person>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
