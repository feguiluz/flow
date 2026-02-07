// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$UserProfileData {
  String? get name => throw _privateConstructorUsedError;
  GoalType? get defaultGoalType => throw _privateConstructorUsedError;
  String? get gender => throw _privateConstructorUsedError;
  int? get age => throw _privateConstructorUsedError;

  /// Create a copy of UserProfileData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserProfileDataCopyWith<UserProfileData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileDataCopyWith<$Res> {
  factory $UserProfileDataCopyWith(
          UserProfileData value, $Res Function(UserProfileData) then) =
      _$UserProfileDataCopyWithImpl<$Res, UserProfileData>;
  @useResult
  $Res call(
      {String? name, GoalType? defaultGoalType, String? gender, int? age});
}

/// @nodoc
class _$UserProfileDataCopyWithImpl<$Res, $Val extends UserProfileData>
    implements $UserProfileDataCopyWith<$Res> {
  _$UserProfileDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserProfileData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? defaultGoalType = freezed,
    Object? gender = freezed,
    Object? age = freezed,
  }) {
    return _then(_value.copyWith(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      defaultGoalType: freezed == defaultGoalType
          ? _value.defaultGoalType
          : defaultGoalType // ignore: cast_nullable_to_non_nullable
              as GoalType?,
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String?,
      age: freezed == age
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserProfileDataImplCopyWith<$Res>
    implements $UserProfileDataCopyWith<$Res> {
  factory _$$UserProfileDataImplCopyWith(_$UserProfileDataImpl value,
          $Res Function(_$UserProfileDataImpl) then) =
      __$$UserProfileDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? name, GoalType? defaultGoalType, String? gender, int? age});
}

/// @nodoc
class __$$UserProfileDataImplCopyWithImpl<$Res>
    extends _$UserProfileDataCopyWithImpl<$Res, _$UserProfileDataImpl>
    implements _$$UserProfileDataImplCopyWith<$Res> {
  __$$UserProfileDataImplCopyWithImpl(
      _$UserProfileDataImpl _value, $Res Function(_$UserProfileDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserProfileData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? defaultGoalType = freezed,
    Object? gender = freezed,
    Object? age = freezed,
  }) {
    return _then(_$UserProfileDataImpl(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      defaultGoalType: freezed == defaultGoalType
          ? _value.defaultGoalType
          : defaultGoalType // ignore: cast_nullable_to_non_nullable
              as GoalType?,
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String?,
      age: freezed == age
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$UserProfileDataImpl implements _UserProfileData {
  const _$UserProfileDataImpl(
      {this.name, this.defaultGoalType, this.gender, this.age});

  @override
  final String? name;
  @override
  final GoalType? defaultGoalType;
  @override
  final String? gender;
  @override
  final int? age;

  @override
  String toString() {
    return 'UserProfileData(name: $name, defaultGoalType: $defaultGoalType, gender: $gender, age: $age)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileDataImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.defaultGoalType, defaultGoalType) ||
                other.defaultGoalType == defaultGoalType) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.age, age) || other.age == age));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, name, defaultGoalType, gender, age);

  /// Create a copy of UserProfileData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileDataImplCopyWith<_$UserProfileDataImpl> get copyWith =>
      __$$UserProfileDataImplCopyWithImpl<_$UserProfileDataImpl>(
          this, _$identity);
}

abstract class _UserProfileData implements UserProfileData {
  const factory _UserProfileData(
      {final String? name,
      final GoalType? defaultGoalType,
      final String? gender,
      final int? age}) = _$UserProfileDataImpl;

  @override
  String? get name;
  @override
  GoalType? get defaultGoalType;
  @override
  String? get gender;
  @override
  int? get age;

  /// Create a copy of UserProfileData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserProfileDataImplCopyWith<_$UserProfileDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
