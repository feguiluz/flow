// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calendar_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CalendarEvent _$CalendarEventFromJson(Map<String, dynamic> json) {
  return _CalendarEvent.fromJson(json);
}

/// @nodoc
mixin _$CalendarEvent {
  int? get id => throw _privateConstructorUsedError;
  int get personId => throw _privateConstructorUsedError;
  String? get seriesId => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timeFromJson, toJson: _timeToJson)
  TimeOfDay? get time => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  EventStatus get status => throw _privateConstructorUsedError;
  int? get visitId => throw _privateConstructorUsedError;
  int? get recurrenceWeeks => throw _privateConstructorUsedError;
  DateTime? get recurrenceEndDate => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this CalendarEvent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CalendarEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CalendarEventCopyWith<CalendarEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CalendarEventCopyWith<$Res> {
  factory $CalendarEventCopyWith(
          CalendarEvent value, $Res Function(CalendarEvent) then) =
      _$CalendarEventCopyWithImpl<$Res, CalendarEvent>;
  @useResult
  $Res call(
      {int? id,
      int personId,
      String? seriesId,
      DateTime date,
      @JsonKey(fromJson: _timeFromJson, toJson: _timeToJson) TimeOfDay? time,
      String? notes,
      EventStatus status,
      int? visitId,
      int? recurrenceWeeks,
      DateTime? recurrenceEndDate,
      DateTime createdAt});
}

/// @nodoc
class _$CalendarEventCopyWithImpl<$Res, $Val extends CalendarEvent>
    implements $CalendarEventCopyWith<$Res> {
  _$CalendarEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CalendarEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? personId = null,
    Object? seriesId = freezed,
    Object? date = null,
    Object? time = freezed,
    Object? notes = freezed,
    Object? status = null,
    Object? visitId = freezed,
    Object? recurrenceWeeks = freezed,
    Object? recurrenceEndDate = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      personId: null == personId
          ? _value.personId
          : personId // ignore: cast_nullable_to_non_nullable
              as int,
      seriesId: freezed == seriesId
          ? _value.seriesId
          : seriesId // ignore: cast_nullable_to_non_nullable
              as String?,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      time: freezed == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as TimeOfDay?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as EventStatus,
      visitId: freezed == visitId
          ? _value.visitId
          : visitId // ignore: cast_nullable_to_non_nullable
              as int?,
      recurrenceWeeks: freezed == recurrenceWeeks
          ? _value.recurrenceWeeks
          : recurrenceWeeks // ignore: cast_nullable_to_non_nullable
              as int?,
      recurrenceEndDate: freezed == recurrenceEndDate
          ? _value.recurrenceEndDate
          : recurrenceEndDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CalendarEventImplCopyWith<$Res>
    implements $CalendarEventCopyWith<$Res> {
  factory _$$CalendarEventImplCopyWith(
          _$CalendarEventImpl value, $Res Function(_$CalendarEventImpl) then) =
      __$$CalendarEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      int personId,
      String? seriesId,
      DateTime date,
      @JsonKey(fromJson: _timeFromJson, toJson: _timeToJson) TimeOfDay? time,
      String? notes,
      EventStatus status,
      int? visitId,
      int? recurrenceWeeks,
      DateTime? recurrenceEndDate,
      DateTime createdAt});
}

/// @nodoc
class __$$CalendarEventImplCopyWithImpl<$Res>
    extends _$CalendarEventCopyWithImpl<$Res, _$CalendarEventImpl>
    implements _$$CalendarEventImplCopyWith<$Res> {
  __$$CalendarEventImplCopyWithImpl(
      _$CalendarEventImpl _value, $Res Function(_$CalendarEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of CalendarEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? personId = null,
    Object? seriesId = freezed,
    Object? date = null,
    Object? time = freezed,
    Object? notes = freezed,
    Object? status = null,
    Object? visitId = freezed,
    Object? recurrenceWeeks = freezed,
    Object? recurrenceEndDate = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$CalendarEventImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      personId: null == personId
          ? _value.personId
          : personId // ignore: cast_nullable_to_non_nullable
              as int,
      seriesId: freezed == seriesId
          ? _value.seriesId
          : seriesId // ignore: cast_nullable_to_non_nullable
              as String?,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      time: freezed == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as TimeOfDay?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as EventStatus,
      visitId: freezed == visitId
          ? _value.visitId
          : visitId // ignore: cast_nullable_to_non_nullable
              as int?,
      recurrenceWeeks: freezed == recurrenceWeeks
          ? _value.recurrenceWeeks
          : recurrenceWeeks // ignore: cast_nullable_to_non_nullable
              as int?,
      recurrenceEndDate: freezed == recurrenceEndDate
          ? _value.recurrenceEndDate
          : recurrenceEndDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CalendarEventImpl implements _CalendarEvent {
  const _$CalendarEventImpl(
      {required this.id,
      required this.personId,
      this.seriesId,
      required this.date,
      @JsonKey(fromJson: _timeFromJson, toJson: _timeToJson) this.time,
      this.notes,
      this.status = EventStatus.pending,
      this.visitId,
      this.recurrenceWeeks,
      this.recurrenceEndDate,
      required this.createdAt});

  factory _$CalendarEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$CalendarEventImplFromJson(json);

  @override
  final int? id;
  @override
  final int personId;
  @override
  final String? seriesId;
  @override
  final DateTime date;
  @override
  @JsonKey(fromJson: _timeFromJson, toJson: _timeToJson)
  final TimeOfDay? time;
  @override
  final String? notes;
  @override
  @JsonKey()
  final EventStatus status;
  @override
  final int? visitId;
  @override
  final int? recurrenceWeeks;
  @override
  final DateTime? recurrenceEndDate;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'CalendarEvent(id: $id, personId: $personId, seriesId: $seriesId, date: $date, time: $time, notes: $notes, status: $status, visitId: $visitId, recurrenceWeeks: $recurrenceWeeks, recurrenceEndDate: $recurrenceEndDate, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CalendarEventImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.personId, personId) ||
                other.personId == personId) &&
            (identical(other.seriesId, seriesId) ||
                other.seriesId == seriesId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.visitId, visitId) || other.visitId == visitId) &&
            (identical(other.recurrenceWeeks, recurrenceWeeks) ||
                other.recurrenceWeeks == recurrenceWeeks) &&
            (identical(other.recurrenceEndDate, recurrenceEndDate) ||
                other.recurrenceEndDate == recurrenceEndDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      personId,
      seriesId,
      date,
      time,
      notes,
      status,
      visitId,
      recurrenceWeeks,
      recurrenceEndDate,
      createdAt);

  /// Create a copy of CalendarEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CalendarEventImplCopyWith<_$CalendarEventImpl> get copyWith =>
      __$$CalendarEventImplCopyWithImpl<_$CalendarEventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CalendarEventImplToJson(
      this,
    );
  }
}

abstract class _CalendarEvent implements CalendarEvent {
  const factory _CalendarEvent(
      {required final int? id,
      required final int personId,
      final String? seriesId,
      required final DateTime date,
      @JsonKey(fromJson: _timeFromJson, toJson: _timeToJson)
      final TimeOfDay? time,
      final String? notes,
      final EventStatus status,
      final int? visitId,
      final int? recurrenceWeeks,
      final DateTime? recurrenceEndDate,
      required final DateTime createdAt}) = _$CalendarEventImpl;

  factory _CalendarEvent.fromJson(Map<String, dynamic> json) =
      _$CalendarEventImpl.fromJson;

  @override
  int? get id;
  @override
  int get personId;
  @override
  String? get seriesId;
  @override
  DateTime get date;
  @override
  @JsonKey(fromJson: _timeFromJson, toJson: _timeToJson)
  TimeOfDay? get time;
  @override
  String? get notes;
  @override
  EventStatus get status;
  @override
  int? get visitId;
  @override
  int? get recurrenceWeeks;
  @override
  DateTime? get recurrenceEndDate;
  @override
  DateTime get createdAt;

  /// Create a copy of CalendarEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CalendarEventImplCopyWith<_$CalendarEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
