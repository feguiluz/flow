// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$eventsByMonthHash() => r'0d7a56989f24f9166281b1cc07728e5d6374097b';

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

/// All events of the given month, ordered chronologically.
///
/// Copied from [eventsByMonth].
@ProviderFor(eventsByMonth)
const eventsByMonthProvider = EventsByMonthFamily();

/// All events of the given month, ordered chronologically.
///
/// Copied from [eventsByMonth].
class EventsByMonthFamily extends Family<AsyncValue<List<CalendarEvent>>> {
  /// All events of the given month, ordered chronologically.
  ///
  /// Copied from [eventsByMonth].
  const EventsByMonthFamily();

  /// All events of the given month, ordered chronologically.
  ///
  /// Copied from [eventsByMonth].
  EventsByMonthProvider call(
    int year,
    int month,
  ) {
    return EventsByMonthProvider(
      year,
      month,
    );
  }

  @override
  EventsByMonthProvider getProviderOverride(
    covariant EventsByMonthProvider provider,
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
  String? get name => r'eventsByMonthProvider';
}

/// All events of the given month, ordered chronologically.
///
/// Copied from [eventsByMonth].
class EventsByMonthProvider
    extends AutoDisposeFutureProvider<List<CalendarEvent>> {
  /// All events of the given month, ordered chronologically.
  ///
  /// Copied from [eventsByMonth].
  EventsByMonthProvider(
    int year,
    int month,
  ) : this._internal(
          (ref) => eventsByMonth(
            ref as EventsByMonthRef,
            year,
            month,
          ),
          from: eventsByMonthProvider,
          name: r'eventsByMonthProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$eventsByMonthHash,
          dependencies: EventsByMonthFamily._dependencies,
          allTransitiveDependencies:
              EventsByMonthFamily._allTransitiveDependencies,
          year: year,
          month: month,
        );

  EventsByMonthProvider._internal(
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
    FutureOr<List<CalendarEvent>> Function(EventsByMonthRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: EventsByMonthProvider._internal(
        (ref) => create(ref as EventsByMonthRef),
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
  AutoDisposeFutureProviderElement<List<CalendarEvent>> createElement() {
    return _EventsByMonthProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EventsByMonthProvider &&
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
mixin EventsByMonthRef on AutoDisposeFutureProviderRef<List<CalendarEvent>> {
  /// The parameter `year` of this provider.
  int get year;

  /// The parameter `month` of this provider.
  int get month;
}

class _EventsByMonthProviderElement
    extends AutoDisposeFutureProviderElement<List<CalendarEvent>>
    with EventsByMonthRef {
  _EventsByMonthProviderElement(super.provider);

  @override
  int get year => (origin as EventsByMonthProvider).year;
  @override
  int get month => (origin as EventsByMonthProvider).month;
}

String _$eventsByDayHash() => r'3e3db8e70379a5607960afc9e57b45276e275dad';

/// All events for a single calendar day, ordered by time (NULLs at the end).
///
/// Copied from [eventsByDay].
@ProviderFor(eventsByDay)
const eventsByDayProvider = EventsByDayFamily();

/// All events for a single calendar day, ordered by time (NULLs at the end).
///
/// Copied from [eventsByDay].
class EventsByDayFamily extends Family<AsyncValue<List<CalendarEvent>>> {
  /// All events for a single calendar day, ordered by time (NULLs at the end).
  ///
  /// Copied from [eventsByDay].
  const EventsByDayFamily();

  /// All events for a single calendar day, ordered by time (NULLs at the end).
  ///
  /// Copied from [eventsByDay].
  EventsByDayProvider call(
    DateTime day,
  ) {
    return EventsByDayProvider(
      day,
    );
  }

  @override
  EventsByDayProvider getProviderOverride(
    covariant EventsByDayProvider provider,
  ) {
    return call(
      provider.day,
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
  String? get name => r'eventsByDayProvider';
}

/// All events for a single calendar day, ordered by time (NULLs at the end).
///
/// Copied from [eventsByDay].
class EventsByDayProvider
    extends AutoDisposeFutureProvider<List<CalendarEvent>> {
  /// All events for a single calendar day, ordered by time (NULLs at the end).
  ///
  /// Copied from [eventsByDay].
  EventsByDayProvider(
    DateTime day,
  ) : this._internal(
          (ref) => eventsByDay(
            ref as EventsByDayRef,
            day,
          ),
          from: eventsByDayProvider,
          name: r'eventsByDayProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$eventsByDayHash,
          dependencies: EventsByDayFamily._dependencies,
          allTransitiveDependencies:
              EventsByDayFamily._allTransitiveDependencies,
          day: day,
        );

  EventsByDayProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.day,
  }) : super.internal();

  final DateTime day;

  @override
  Override overrideWith(
    FutureOr<List<CalendarEvent>> Function(EventsByDayRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: EventsByDayProvider._internal(
        (ref) => create(ref as EventsByDayRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        day: day,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<CalendarEvent>> createElement() {
    return _EventsByDayProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EventsByDayProvider && other.day == day;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, day.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin EventsByDayRef on AutoDisposeFutureProviderRef<List<CalendarEvent>> {
  /// The parameter `day` of this provider.
  DateTime get day;
}

class _EventsByDayProviderElement
    extends AutoDisposeFutureProviderElement<List<CalendarEvent>>
    with EventsByDayRef {
  _EventsByDayProviderElement(super.provider);

  @override
  DateTime get day => (origin as EventsByDayProvider).day;
}

String _$upcomingEventsByPersonHash() =>
    r'f0af4e1b37bb837317bd8570c7064a84781951dd';

/// Pending events for a person, from today onwards.
///
/// Copied from [upcomingEventsByPerson].
@ProviderFor(upcomingEventsByPerson)
const upcomingEventsByPersonProvider = UpcomingEventsByPersonFamily();

/// Pending events for a person, from today onwards.
///
/// Copied from [upcomingEventsByPerson].
class UpcomingEventsByPersonFamily
    extends Family<AsyncValue<List<CalendarEvent>>> {
  /// Pending events for a person, from today onwards.
  ///
  /// Copied from [upcomingEventsByPerson].
  const UpcomingEventsByPersonFamily();

  /// Pending events for a person, from today onwards.
  ///
  /// Copied from [upcomingEventsByPerson].
  UpcomingEventsByPersonProvider call(
    int personId,
  ) {
    return UpcomingEventsByPersonProvider(
      personId,
    );
  }

  @override
  UpcomingEventsByPersonProvider getProviderOverride(
    covariant UpcomingEventsByPersonProvider provider,
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
  String? get name => r'upcomingEventsByPersonProvider';
}

/// Pending events for a person, from today onwards.
///
/// Copied from [upcomingEventsByPerson].
class UpcomingEventsByPersonProvider
    extends AutoDisposeFutureProvider<List<CalendarEvent>> {
  /// Pending events for a person, from today onwards.
  ///
  /// Copied from [upcomingEventsByPerson].
  UpcomingEventsByPersonProvider(
    int personId,
  ) : this._internal(
          (ref) => upcomingEventsByPerson(
            ref as UpcomingEventsByPersonRef,
            personId,
          ),
          from: upcomingEventsByPersonProvider,
          name: r'upcomingEventsByPersonProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$upcomingEventsByPersonHash,
          dependencies: UpcomingEventsByPersonFamily._dependencies,
          allTransitiveDependencies:
              UpcomingEventsByPersonFamily._allTransitiveDependencies,
          personId: personId,
        );

  UpcomingEventsByPersonProvider._internal(
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
    FutureOr<List<CalendarEvent>> Function(UpcomingEventsByPersonRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UpcomingEventsByPersonProvider._internal(
        (ref) => create(ref as UpcomingEventsByPersonRef),
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
  AutoDisposeFutureProviderElement<List<CalendarEvent>> createElement() {
    return _UpcomingEventsByPersonProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UpcomingEventsByPersonProvider &&
        other.personId == personId;
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
mixin UpcomingEventsByPersonRef
    on AutoDisposeFutureProviderRef<List<CalendarEvent>> {
  /// The parameter `personId` of this provider.
  int get personId;
}

class _UpcomingEventsByPersonProviderElement
    extends AutoDisposeFutureProviderElement<List<CalendarEvent>>
    with UpcomingEventsByPersonRef {
  _UpcomingEventsByPersonProviderElement(super.provider);

  @override
  int get personId => (origin as UpcomingEventsByPersonProvider).personId;
}

String _$eventByIdHash() => r'344b1f8d72cad4a22c07a06a867f99cfc8bc8f49';

/// Single event by id.
///
/// Copied from [eventById].
@ProviderFor(eventById)
const eventByIdProvider = EventByIdFamily();

/// Single event by id.
///
/// Copied from [eventById].
class EventByIdFamily extends Family<AsyncValue<CalendarEvent?>> {
  /// Single event by id.
  ///
  /// Copied from [eventById].
  const EventByIdFamily();

  /// Single event by id.
  ///
  /// Copied from [eventById].
  EventByIdProvider call(
    int id,
  ) {
    return EventByIdProvider(
      id,
    );
  }

  @override
  EventByIdProvider getProviderOverride(
    covariant EventByIdProvider provider,
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
  String? get name => r'eventByIdProvider';
}

/// Single event by id.
///
/// Copied from [eventById].
class EventByIdProvider extends AutoDisposeFutureProvider<CalendarEvent?> {
  /// Single event by id.
  ///
  /// Copied from [eventById].
  EventByIdProvider(
    int id,
  ) : this._internal(
          (ref) => eventById(
            ref as EventByIdRef,
            id,
          ),
          from: eventByIdProvider,
          name: r'eventByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$eventByIdHash,
          dependencies: EventByIdFamily._dependencies,
          allTransitiveDependencies: EventByIdFamily._allTransitiveDependencies,
          id: id,
        );

  EventByIdProvider._internal(
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
    FutureOr<CalendarEvent?> Function(EventByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: EventByIdProvider._internal(
        (ref) => create(ref as EventByIdRef),
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
  AutoDisposeFutureProviderElement<CalendarEvent?> createElement() {
    return _EventByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EventByIdProvider && other.id == id;
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
mixin EventByIdRef on AutoDisposeFutureProviderRef<CalendarEvent?> {
  /// The parameter `id` of this provider.
  int get id;
}

class _EventByIdProviderElement
    extends AutoDisposeFutureProviderElement<CalendarEvent?> with EventByIdRef {
  _EventByIdProviderElement(super.provider);

  @override
  int get id => (origin as EventByIdProvider).id;
}

String _$eventNotifierHash() => r'233100b7deb35c27869c11c250d797f53dc0934c';

/// Mutations for the calendar feature.
///
/// Methods invalidate every event-related provider so the UI refreshes
/// uniformly. `markCompleted` also invalidates visit providers because the
/// completion creates a Visit row that should appear in the person's history.
///
/// Copied from [EventNotifier].
@ProviderFor(EventNotifier)
final eventNotifierProvider =
    AutoDisposeNotifierProvider<EventNotifier, void>.internal(
  EventNotifier.new,
  name: r'eventNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$eventNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$EventNotifier = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
