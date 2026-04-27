// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$visitsByPersonHash() => r'6a18c2ec239ce4b1a1bb119c5bc6e67344505130';

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

/// Provider for visits by person
///
/// Copied from [visitsByPerson].
@ProviderFor(visitsByPerson)
const visitsByPersonProvider = VisitsByPersonFamily();

/// Provider for visits by person
///
/// Copied from [visitsByPerson].
class VisitsByPersonFamily extends Family<AsyncValue<List<Visit>>> {
  /// Provider for visits by person
  ///
  /// Copied from [visitsByPerson].
  const VisitsByPersonFamily();

  /// Provider for visits by person
  ///
  /// Copied from [visitsByPerson].
  VisitsByPersonProvider call(
    int personId,
  ) {
    return VisitsByPersonProvider(
      personId,
    );
  }

  @override
  VisitsByPersonProvider getProviderOverride(
    covariant VisitsByPersonProvider provider,
  ) {
    return call(
      provider.personId,
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
  String? get name => r'visitsByPersonProvider';
}

/// Provider for visits by person
///
/// Copied from [visitsByPerson].
class VisitsByPersonProvider extends AutoDisposeFutureProvider<List<Visit>> {
  /// Provider for visits by person
  ///
  /// Copied from [visitsByPerson].
  VisitsByPersonProvider(
    int personId,
  ) : this._internal(
          (ref) => visitsByPerson(
            ref as VisitsByPersonRef,
            personId,
          ),
          from: visitsByPersonProvider,
          name: r'visitsByPersonProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$visitsByPersonHash,
          dependencies: VisitsByPersonFamily._dependencies,
          allTransitiveDependencies:
              VisitsByPersonFamily._allTransitiveDependencies,
          personId: personId,
        );

  VisitsByPersonProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.personId,
  }) : super.internal();

  final int personId;

  @override
  Override overrideWith(
    FutureOr<List<Visit>> Function(VisitsByPersonRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: VisitsByPersonProvider._internal(
        (ref) => create(ref as VisitsByPersonRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        personId: personId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Visit>> createElement() {
    return _VisitsByPersonProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VisitsByPersonProvider && other.personId == personId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, personId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin VisitsByPersonRef on AutoDisposeFutureProviderRef<List<Visit>> {
  /// The parameter `personId` of this provider.
  int get personId;
}

class _VisitsByPersonProviderElement
    extends AutoDisposeFutureProviderElement<List<Visit>>
    with VisitsByPersonRef {
  _VisitsByPersonProviderElement(super.provider);

  @override
  int get personId => (origin as VisitsByPersonProvider).personId;
}

String _$visitsByMonthHash() => r'e804973a30da42b3336d045ad90992c5062dc05a';

/// Provider for visits by month
///
/// Copied from [visitsByMonth].
@ProviderFor(visitsByMonth)
const visitsByMonthProvider = VisitsByMonthFamily();

/// Provider for visits by month
///
/// Copied from [visitsByMonth].
class VisitsByMonthFamily extends Family<AsyncValue<List<Visit>>> {
  /// Provider for visits by month
  ///
  /// Copied from [visitsByMonth].
  const VisitsByMonthFamily();

  /// Provider for visits by month
  ///
  /// Copied from [visitsByMonth].
  VisitsByMonthProvider call(
    int year,
    int month,
  ) {
    return VisitsByMonthProvider(
      year,
      month,
    );
  }

  @override
  VisitsByMonthProvider getProviderOverride(
    covariant VisitsByMonthProvider provider,
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
  String? get name => r'visitsByMonthProvider';
}

/// Provider for visits by month
///
/// Copied from [visitsByMonth].
class VisitsByMonthProvider extends AutoDisposeFutureProvider<List<Visit>> {
  /// Provider for visits by month
  ///
  /// Copied from [visitsByMonth].
  VisitsByMonthProvider(
    int year,
    int month,
  ) : this._internal(
          (ref) => visitsByMonth(
            ref as VisitsByMonthRef,
            year,
            month,
          ),
          from: visitsByMonthProvider,
          name: r'visitsByMonthProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$visitsByMonthHash,
          dependencies: VisitsByMonthFamily._dependencies,
          allTransitiveDependencies:
              VisitsByMonthFamily._allTransitiveDependencies,
          year: year,
          month: month,
        );

  VisitsByMonthProvider._internal(
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
    FutureOr<List<Visit>> Function(VisitsByMonthRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: VisitsByMonthProvider._internal(
        (ref) => create(ref as VisitsByMonthRef),
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
  AutoDisposeFutureProviderElement<List<Visit>> createElement() {
    return _VisitsByMonthProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VisitsByMonthProvider &&
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
mixin VisitsByMonthRef on AutoDisposeFutureProviderRef<List<Visit>> {
  /// The parameter `year` of this provider.
  int get year;

  /// The parameter `month` of this provider.
  int get month;
}

class _VisitsByMonthProviderElement
    extends AutoDisposeFutureProviderElement<List<Visit>>
    with VisitsByMonthRef {
  _VisitsByMonthProviderElement(super.provider);

  @override
  int get year => (origin as VisitsByMonthProvider).year;
  @override
  int get month => (origin as VisitsByMonthProvider).month;
}

String _$bibleStudiesCountForMonthHash() =>
    r'9809e6cebde0cf2346e28126f2f75119abf19c5f';

/// Provider for Bible studies count
/// A Bible study is counted if the person has is_bible_study = true
/// Note: Month parameters are kept for consistency but not used in the query
/// All active Bible studies are counted regardless of visits that month
///
/// Copied from [bibleStudiesCountForMonth].
@ProviderFor(bibleStudiesCountForMonth)
const bibleStudiesCountForMonthProvider = BibleStudiesCountForMonthFamily();

/// Provider for Bible studies count
/// A Bible study is counted if the person has is_bible_study = true
/// Note: Month parameters are kept for consistency but not used in the query
/// All active Bible studies are counted regardless of visits that month
///
/// Copied from [bibleStudiesCountForMonth].
class BibleStudiesCountForMonthFamily extends Family<AsyncValue<int>> {
  /// Provider for Bible studies count
  /// A Bible study is counted if the person has is_bible_study = true
  /// Note: Month parameters are kept for consistency but not used in the query
  /// All active Bible studies are counted regardless of visits that month
  ///
  /// Copied from [bibleStudiesCountForMonth].
  const BibleStudiesCountForMonthFamily();

  /// Provider for Bible studies count
  /// A Bible study is counted if the person has is_bible_study = true
  /// Note: Month parameters are kept for consistency but not used in the query
  /// All active Bible studies are counted regardless of visits that month
  ///
  /// Copied from [bibleStudiesCountForMonth].
  BibleStudiesCountForMonthProvider call(
    int year,
    int month,
  ) {
    return BibleStudiesCountForMonthProvider(
      year,
      month,
    );
  }

  @override
  BibleStudiesCountForMonthProvider getProviderOverride(
    covariant BibleStudiesCountForMonthProvider provider,
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
  String? get name => r'bibleStudiesCountForMonthProvider';
}

/// Provider for Bible studies count
/// A Bible study is counted if the person has is_bible_study = true
/// Note: Month parameters are kept for consistency but not used in the query
/// All active Bible studies are counted regardless of visits that month
///
/// Copied from [bibleStudiesCountForMonth].
class BibleStudiesCountForMonthProvider extends AutoDisposeFutureProvider<int> {
  /// Provider for Bible studies count
  /// A Bible study is counted if the person has is_bible_study = true
  /// Note: Month parameters are kept for consistency but not used in the query
  /// All active Bible studies are counted regardless of visits that month
  ///
  /// Copied from [bibleStudiesCountForMonth].
  BibleStudiesCountForMonthProvider(
    int year,
    int month,
  ) : this._internal(
          (ref) => bibleStudiesCountForMonth(
            ref as BibleStudiesCountForMonthRef,
            year,
            month,
          ),
          from: bibleStudiesCountForMonthProvider,
          name: r'bibleStudiesCountForMonthProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$bibleStudiesCountForMonthHash,
          dependencies: BibleStudiesCountForMonthFamily._dependencies,
          allTransitiveDependencies:
              BibleStudiesCountForMonthFamily._allTransitiveDependencies,
          year: year,
          month: month,
        );

  BibleStudiesCountForMonthProvider._internal(
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
    FutureOr<int> Function(BibleStudiesCountForMonthRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BibleStudiesCountForMonthProvider._internal(
        (ref) => create(ref as BibleStudiesCountForMonthRef),
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
    return _BibleStudiesCountForMonthProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BibleStudiesCountForMonthProvider &&
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
mixin BibleStudiesCountForMonthRef on AutoDisposeFutureProviderRef<int> {
  /// The parameter `year` of this provider.
  int get year;

  /// The parameter `month` of this provider.
  int get month;
}

class _BibleStudiesCountForMonthProviderElement
    extends AutoDisposeFutureProviderElement<int>
    with BibleStudiesCountForMonthRef {
  _BibleStudiesCountForMonthProviderElement(super.provider);

  @override
  int get year => (origin as BibleStudiesCountForMonthProvider).year;
  @override
  int get month => (origin as BibleStudiesCountForMonthProvider).month;
}

String _$visitCountByPersonHash() =>
    r'71500102e99a3c6d7cb49b1cc22d93c6ba28e37e';

/// Provider for visit count by person
///
/// Copied from [visitCountByPerson].
@ProviderFor(visitCountByPerson)
const visitCountByPersonProvider = VisitCountByPersonFamily();

/// Provider for visit count by person
///
/// Copied from [visitCountByPerson].
class VisitCountByPersonFamily extends Family<AsyncValue<int>> {
  /// Provider for visit count by person
  ///
  /// Copied from [visitCountByPerson].
  const VisitCountByPersonFamily();

  /// Provider for visit count by person
  ///
  /// Copied from [visitCountByPerson].
  VisitCountByPersonProvider call(
    int personId,
  ) {
    return VisitCountByPersonProvider(
      personId,
    );
  }

  @override
  VisitCountByPersonProvider getProviderOverride(
    covariant VisitCountByPersonProvider provider,
  ) {
    return call(
      provider.personId,
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
  String? get name => r'visitCountByPersonProvider';
}

/// Provider for visit count by person
///
/// Copied from [visitCountByPerson].
class VisitCountByPersonProvider extends AutoDisposeFutureProvider<int> {
  /// Provider for visit count by person
  ///
  /// Copied from [visitCountByPerson].
  VisitCountByPersonProvider(
    int personId,
  ) : this._internal(
          (ref) => visitCountByPerson(
            ref as VisitCountByPersonRef,
            personId,
          ),
          from: visitCountByPersonProvider,
          name: r'visitCountByPersonProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$visitCountByPersonHash,
          dependencies: VisitCountByPersonFamily._dependencies,
          allTransitiveDependencies:
              VisitCountByPersonFamily._allTransitiveDependencies,
          personId: personId,
        );

  VisitCountByPersonProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.personId,
  }) : super.internal();

  final int personId;

  @override
  Override overrideWith(
    FutureOr<int> Function(VisitCountByPersonRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: VisitCountByPersonProvider._internal(
        (ref) => create(ref as VisitCountByPersonRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        personId: personId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<int> createElement() {
    return _VisitCountByPersonProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VisitCountByPersonProvider && other.personId == personId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, personId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin VisitCountByPersonRef on AutoDisposeFutureProviderRef<int> {
  /// The parameter `personId` of this provider.
  int get personId;
}

class _VisitCountByPersonProviderElement
    extends AutoDisposeFutureProviderElement<int> with VisitCountByPersonRef {
  _VisitCountByPersonProviderElement(super.provider);

  @override
  int get personId => (origin as VisitCountByPersonProvider).personId;
}

String _$visitByIdHash() => r'612c165dfea2f0f92504ccb50a5d1fa090437da9';

/// Provider for a specific visit by ID
///
/// Copied from [visitById].
@ProviderFor(visitById)
const visitByIdProvider = VisitByIdFamily();

/// Provider for a specific visit by ID
///
/// Copied from [visitById].
class VisitByIdFamily extends Family<AsyncValue<Visit?>> {
  /// Provider for a specific visit by ID
  ///
  /// Copied from [visitById].
  const VisitByIdFamily();

  /// Provider for a specific visit by ID
  ///
  /// Copied from [visitById].
  VisitByIdProvider call(
    int id,
  ) {
    return VisitByIdProvider(
      id,
    );
  }

  @override
  VisitByIdProvider getProviderOverride(
    covariant VisitByIdProvider provider,
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
  String? get name => r'visitByIdProvider';
}

/// Provider for a specific visit by ID
///
/// Copied from [visitById].
class VisitByIdProvider extends AutoDisposeFutureProvider<Visit?> {
  /// Provider for a specific visit by ID
  ///
  /// Copied from [visitById].
  VisitByIdProvider(
    int id,
  ) : this._internal(
          (ref) => visitById(
            ref as VisitByIdRef,
            id,
          ),
          from: visitByIdProvider,
          name: r'visitByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$visitByIdHash,
          dependencies: VisitByIdFamily._dependencies,
          allTransitiveDependencies: VisitByIdFamily._allTransitiveDependencies,
          id: id,
        );

  VisitByIdProvider._internal(
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
    FutureOr<Visit?> Function(VisitByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: VisitByIdProvider._internal(
        (ref) => create(ref as VisitByIdRef),
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
  AutoDisposeFutureProviderElement<Visit?> createElement() {
    return _VisitByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VisitByIdProvider && other.id == id;
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
mixin VisitByIdRef on AutoDisposeFutureProviderRef<Visit?> {
  /// The parameter `id` of this provider.
  int get id;
}

class _VisitByIdProviderElement extends AutoDisposeFutureProviderElement<Visit?>
    with VisitByIdRef {
  _VisitByIdProviderElement(super.provider);

  @override
  int get id => (origin as VisitByIdProvider).id;
}

String _$visitNotifierHash() => r'4335380b0a0a7d249fa0659e3d9eb405aafd9e51';

abstract class _$VisitNotifier
    extends BuildlessAutoDisposeAsyncNotifier<List<Visit>> {
  late final int personId;

  FutureOr<List<Visit>> build(
    int personId,
  );
}

/// Provider for managing visit data for a specific person
///
/// Copied from [VisitNotifier].
@ProviderFor(VisitNotifier)
const visitNotifierProvider = VisitNotifierFamily();

/// Provider for managing visit data for a specific person
///
/// Copied from [VisitNotifier].
class VisitNotifierFamily extends Family<AsyncValue<List<Visit>>> {
  /// Provider for managing visit data for a specific person
  ///
  /// Copied from [VisitNotifier].
  const VisitNotifierFamily();

  /// Provider for managing visit data for a specific person
  ///
  /// Copied from [VisitNotifier].
  VisitNotifierProvider call(
    int personId,
  ) {
    return VisitNotifierProvider(
      personId,
    );
  }

  @override
  VisitNotifierProvider getProviderOverride(
    covariant VisitNotifierProvider provider,
  ) {
    return call(
      provider.personId,
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
  String? get name => r'visitNotifierProvider';
}

/// Provider for managing visit data for a specific person
///
/// Copied from [VisitNotifier].
class VisitNotifierProvider
    extends AutoDisposeAsyncNotifierProviderImpl<VisitNotifier, List<Visit>> {
  /// Provider for managing visit data for a specific person
  ///
  /// Copied from [VisitNotifier].
  VisitNotifierProvider(
    int personId,
  ) : this._internal(
          () => VisitNotifier()..personId = personId,
          from: visitNotifierProvider,
          name: r'visitNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$visitNotifierHash,
          dependencies: VisitNotifierFamily._dependencies,
          allTransitiveDependencies:
              VisitNotifierFamily._allTransitiveDependencies,
          personId: personId,
        );

  VisitNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.personId,
  }) : super.internal();

  final int personId;

  @override
  FutureOr<List<Visit>> runNotifierBuild(
    covariant VisitNotifier notifier,
  ) {
    return notifier.build(
      personId,
    );
  }

  @override
  Override overrideWith(VisitNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: VisitNotifierProvider._internal(
        () => create()..personId = personId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        personId: personId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<VisitNotifier, List<Visit>>
      createElement() {
    return _VisitNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VisitNotifierProvider && other.personId == personId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, personId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin VisitNotifierRef on AutoDisposeAsyncNotifierProviderRef<List<Visit>> {
  /// The parameter `personId` of this provider.
  int get personId;
}

class _VisitNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<VisitNotifier, List<Visit>>
    with VisitNotifierRef {
  _VisitNotifierProviderElement(super.provider);

  @override
  int get personId => (origin as VisitNotifierProvider).personId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
