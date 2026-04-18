// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'statistics_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ServiceYearStatistics {
  int get startYear => throw _privateConstructorUsedError;
  Map<int, double> get hoursByMonth =>
      throw _privateConstructorUsedError; // month (1-12) -> hours
  double get totalHours => throw _privateConstructorUsedError;
  double get averageHours => throw _privateConstructorUsedError;
  int get totalBibleStudies => throw _privateConstructorUsedError;
  int get monthsWithData => throw _privateConstructorUsedError;

  /// Create a copy of ServiceYearStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ServiceYearStatisticsCopyWith<ServiceYearStatistics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServiceYearStatisticsCopyWith<$Res> {
  factory $ServiceYearStatisticsCopyWith(ServiceYearStatistics value,
          $Res Function(ServiceYearStatistics) then) =
      _$ServiceYearStatisticsCopyWithImpl<$Res, ServiceYearStatistics>;
  @useResult
  $Res call(
      {int startYear,
      Map<int, double> hoursByMonth,
      double totalHours,
      double averageHours,
      int totalBibleStudies,
      int monthsWithData});
}

/// @nodoc
class _$ServiceYearStatisticsCopyWithImpl<$Res,
        $Val extends ServiceYearStatistics>
    implements $ServiceYearStatisticsCopyWith<$Res> {
  _$ServiceYearStatisticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ServiceYearStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startYear = null,
    Object? hoursByMonth = null,
    Object? totalHours = null,
    Object? averageHours = null,
    Object? totalBibleStudies = null,
    Object? monthsWithData = null,
  }) {
    return _then(_value.copyWith(
      startYear: null == startYear
          ? _value.startYear
          : startYear // ignore: cast_nullable_to_non_nullable
              as int,
      hoursByMonth: null == hoursByMonth
          ? _value.hoursByMonth
          : hoursByMonth // ignore: cast_nullable_to_non_nullable
              as Map<int, double>,
      totalHours: null == totalHours
          ? _value.totalHours
          : totalHours // ignore: cast_nullable_to_non_nullable
              as double,
      averageHours: null == averageHours
          ? _value.averageHours
          : averageHours // ignore: cast_nullable_to_non_nullable
              as double,
      totalBibleStudies: null == totalBibleStudies
          ? _value.totalBibleStudies
          : totalBibleStudies // ignore: cast_nullable_to_non_nullable
              as int,
      monthsWithData: null == monthsWithData
          ? _value.monthsWithData
          : monthsWithData // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ServiceYearStatisticsImplCopyWith<$Res>
    implements $ServiceYearStatisticsCopyWith<$Res> {
  factory _$$ServiceYearStatisticsImplCopyWith(
          _$ServiceYearStatisticsImpl value,
          $Res Function(_$ServiceYearStatisticsImpl) then) =
      __$$ServiceYearStatisticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int startYear,
      Map<int, double> hoursByMonth,
      double totalHours,
      double averageHours,
      int totalBibleStudies,
      int monthsWithData});
}

/// @nodoc
class __$$ServiceYearStatisticsImplCopyWithImpl<$Res>
    extends _$ServiceYearStatisticsCopyWithImpl<$Res,
        _$ServiceYearStatisticsImpl>
    implements _$$ServiceYearStatisticsImplCopyWith<$Res> {
  __$$ServiceYearStatisticsImplCopyWithImpl(_$ServiceYearStatisticsImpl _value,
      $Res Function(_$ServiceYearStatisticsImpl) _then)
      : super(_value, _then);

  /// Create a copy of ServiceYearStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startYear = null,
    Object? hoursByMonth = null,
    Object? totalHours = null,
    Object? averageHours = null,
    Object? totalBibleStudies = null,
    Object? monthsWithData = null,
  }) {
    return _then(_$ServiceYearStatisticsImpl(
      startYear: null == startYear
          ? _value.startYear
          : startYear // ignore: cast_nullable_to_non_nullable
              as int,
      hoursByMonth: null == hoursByMonth
          ? _value._hoursByMonth
          : hoursByMonth // ignore: cast_nullable_to_non_nullable
              as Map<int, double>,
      totalHours: null == totalHours
          ? _value.totalHours
          : totalHours // ignore: cast_nullable_to_non_nullable
              as double,
      averageHours: null == averageHours
          ? _value.averageHours
          : averageHours // ignore: cast_nullable_to_non_nullable
              as double,
      totalBibleStudies: null == totalBibleStudies
          ? _value.totalBibleStudies
          : totalBibleStudies // ignore: cast_nullable_to_non_nullable
              as int,
      monthsWithData: null == monthsWithData
          ? _value.monthsWithData
          : monthsWithData // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$ServiceYearStatisticsImpl implements _ServiceYearStatistics {
  const _$ServiceYearStatisticsImpl(
      {required this.startYear,
      required final Map<int, double> hoursByMonth,
      required this.totalHours,
      required this.averageHours,
      required this.totalBibleStudies,
      required this.monthsWithData})
      : _hoursByMonth = hoursByMonth;

  @override
  final int startYear;
  final Map<int, double> _hoursByMonth;
  @override
  Map<int, double> get hoursByMonth {
    if (_hoursByMonth is EqualUnmodifiableMapView) return _hoursByMonth;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_hoursByMonth);
  }

// month (1-12) -> hours
  @override
  final double totalHours;
  @override
  final double averageHours;
  @override
  final int totalBibleStudies;
  @override
  final int monthsWithData;

  @override
  String toString() {
    return 'ServiceYearStatistics(startYear: $startYear, hoursByMonth: $hoursByMonth, totalHours: $totalHours, averageHours: $averageHours, totalBibleStudies: $totalBibleStudies, monthsWithData: $monthsWithData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServiceYearStatisticsImpl &&
            (identical(other.startYear, startYear) ||
                other.startYear == startYear) &&
            const DeepCollectionEquality()
                .equals(other._hoursByMonth, _hoursByMonth) &&
            (identical(other.totalHours, totalHours) ||
                other.totalHours == totalHours) &&
            (identical(other.averageHours, averageHours) ||
                other.averageHours == averageHours) &&
            (identical(other.totalBibleStudies, totalBibleStudies) ||
                other.totalBibleStudies == totalBibleStudies) &&
            (identical(other.monthsWithData, monthsWithData) ||
                other.monthsWithData == monthsWithData));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      startYear,
      const DeepCollectionEquality().hash(_hoursByMonth),
      totalHours,
      averageHours,
      totalBibleStudies,
      monthsWithData);

  /// Create a copy of ServiceYearStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServiceYearStatisticsImplCopyWith<_$ServiceYearStatisticsImpl>
      get copyWith => __$$ServiceYearStatisticsImplCopyWithImpl<
          _$ServiceYearStatisticsImpl>(this, _$identity);
}

abstract class _ServiceYearStatistics implements ServiceYearStatistics {
  const factory _ServiceYearStatistics(
      {required final int startYear,
      required final Map<int, double> hoursByMonth,
      required final double totalHours,
      required final double averageHours,
      required final int totalBibleStudies,
      required final int monthsWithData}) = _$ServiceYearStatisticsImpl;

  @override
  int get startYear;
  @override
  Map<int, double> get hoursByMonth; // month (1-12) -> hours
  @override
  double get totalHours;
  @override
  double get averageHours;
  @override
  int get totalBibleStudies;
  @override
  int get monthsWithData;

  /// Create a copy of ServiceYearStatistics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServiceYearStatisticsImplCopyWith<_$ServiceYearStatisticsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
