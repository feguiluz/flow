// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'participation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Participation _$ParticipationFromJson(Map<String, dynamic> json) {
  return _Participation.fromJson(json);
}

/// @nodoc
mixin _$Participation {
  /// Database ID
  int? get id => throw _privateConstructorUsedError;

  /// Year (e.g., 2026)
  int get year => throw _privateConstructorUsedError;

  /// Month (1-12)
  int get month => throw _privateConstructorUsedError;

  /// Whether the publisher participated in ministry this month
  bool get participated => throw _privateConstructorUsedError;

  /// When this participation was created/updated
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Participation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Participation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ParticipationCopyWith<Participation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ParticipationCopyWith<$Res> {
  factory $ParticipationCopyWith(
          Participation value, $Res Function(Participation) then) =
      _$ParticipationCopyWithImpl<$Res, Participation>;
  @useResult
  $Res call(
      {int? id, int year, int month, bool participated, DateTime createdAt});
}

/// @nodoc
class _$ParticipationCopyWithImpl<$Res, $Val extends Participation>
    implements $ParticipationCopyWith<$Res> {
  _$ParticipationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Participation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? year = null,
    Object? month = null,
    Object? participated = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as int,
      participated: null == participated
          ? _value.participated
          : participated // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ParticipationImplCopyWith<$Res>
    implements $ParticipationCopyWith<$Res> {
  factory _$$ParticipationImplCopyWith(
          _$ParticipationImpl value, $Res Function(_$ParticipationImpl) then) =
      __$$ParticipationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id, int year, int month, bool participated, DateTime createdAt});
}

/// @nodoc
class __$$ParticipationImplCopyWithImpl<$Res>
    extends _$ParticipationCopyWithImpl<$Res, _$ParticipationImpl>
    implements _$$ParticipationImplCopyWith<$Res> {
  __$$ParticipationImplCopyWithImpl(
      _$ParticipationImpl _value, $Res Function(_$ParticipationImpl) _then)
      : super(_value, _then);

  /// Create a copy of Participation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? year = null,
    Object? month = null,
    Object? participated = null,
    Object? createdAt = null,
  }) {
    return _then(_$ParticipationImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as int,
      participated: null == participated
          ? _value.participated
          : participated // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ParticipationImpl implements _Participation {
  const _$ParticipationImpl(
      {this.id,
      required this.year,
      required this.month,
      required this.participated,
      required this.createdAt});

  factory _$ParticipationImpl.fromJson(Map<String, dynamic> json) =>
      _$$ParticipationImplFromJson(json);

  /// Database ID
  @override
  final int? id;

  /// Year (e.g., 2026)
  @override
  final int year;

  /// Month (1-12)
  @override
  final int month;

  /// Whether the publisher participated in ministry this month
  @override
  final bool participated;

  /// When this participation was created/updated
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'Participation(id: $id, year: $year, month: $month, participated: $participated, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ParticipationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.participated, participated) ||
                other.participated == participated) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, year, month, participated, createdAt);

  /// Create a copy of Participation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ParticipationImplCopyWith<_$ParticipationImpl> get copyWith =>
      __$$ParticipationImplCopyWithImpl<_$ParticipationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ParticipationImplToJson(
      this,
    );
  }
}

abstract class _Participation implements Participation {
  const factory _Participation(
      {final int? id,
      required final int year,
      required final int month,
      required final bool participated,
      required final DateTime createdAt}) = _$ParticipationImpl;

  factory _Participation.fromJson(Map<String, dynamic> json) =
      _$ParticipationImpl.fromJson;

  /// Database ID
  @override
  int? get id;

  /// Year (e.g., 2026)
  @override
  int get year;

  /// Month (1-12)
  @override
  int get month;

  /// Whether the publisher participated in ministry this month
  @override
  bool get participated;

  /// When this participation was created/updated
  @override
  DateTime get createdAt;

  /// Create a copy of Participation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ParticipationImplCopyWith<_$ParticipationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
