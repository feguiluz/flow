// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'month_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MonthSummary {
  /// Year (e.g., 2026)
  int get year => throw _privateConstructorUsedError;

  /// Month (1-12)
  int get month => throw _privateConstructorUsedError;

  /// Total hours registered in the month
  double get totalHours => throw _privateConstructorUsedError;

  /// Count of active Bible studies
  /// (all persons marked as isBibleStudy=true, regardless of visits this month)
  int get bibleStudiesCount => throw _privateConstructorUsedError;

  /// Goal for the month (if set manually - for auxiliary pioneers)
  Goal? get goal => throw _privateConstructorUsedError;

  /// Target hours for the month
  /// For regular/special pioneers: automatic based on privilege
  /// For publishers: from goal if set, otherwise 0
  double get targetHours => throw _privateConstructorUsedError;

  /// Progress percentage (0.0 to 100.0+)
  /// Calculated as (totalHours / targetHours) * 100
  /// If no goal, always 0.0
  double get progressPercentage => throw _privateConstructorUsedError;

  /// Whether the goal has been met
  /// If no goal, always false
  bool get isGoalMet => throw _privateConstructorUsedError;

  /// Create a copy of MonthSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MonthSummaryCopyWith<MonthSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MonthSummaryCopyWith<$Res> {
  factory $MonthSummaryCopyWith(
          MonthSummary value, $Res Function(MonthSummary) then) =
      _$MonthSummaryCopyWithImpl<$Res, MonthSummary>;
  @useResult
  $Res call(
      {int year,
      int month,
      double totalHours,
      int bibleStudiesCount,
      Goal? goal,
      double targetHours,
      double progressPercentage,
      bool isGoalMet});

  $GoalCopyWith<$Res>? get goal;
}

/// @nodoc
class _$MonthSummaryCopyWithImpl<$Res, $Val extends MonthSummary>
    implements $MonthSummaryCopyWith<$Res> {
  _$MonthSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MonthSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? year = null,
    Object? month = null,
    Object? totalHours = null,
    Object? bibleStudiesCount = null,
    Object? goal = freezed,
    Object? targetHours = null,
    Object? progressPercentage = null,
    Object? isGoalMet = null,
  }) {
    return _then(_value.copyWith(
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as int,
      totalHours: null == totalHours
          ? _value.totalHours
          : totalHours // ignore: cast_nullable_to_non_nullable
              as double,
      bibleStudiesCount: null == bibleStudiesCount
          ? _value.bibleStudiesCount
          : bibleStudiesCount // ignore: cast_nullable_to_non_nullable
              as int,
      goal: freezed == goal
          ? _value.goal
          : goal // ignore: cast_nullable_to_non_nullable
              as Goal?,
      targetHours: null == targetHours
          ? _value.targetHours
          : targetHours // ignore: cast_nullable_to_non_nullable
              as double,
      progressPercentage: null == progressPercentage
          ? _value.progressPercentage
          : progressPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      isGoalMet: null == isGoalMet
          ? _value.isGoalMet
          : isGoalMet // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  /// Create a copy of MonthSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GoalCopyWith<$Res>? get goal {
    if (_value.goal == null) {
      return null;
    }

    return $GoalCopyWith<$Res>(_value.goal!, (value) {
      return _then(_value.copyWith(goal: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MonthSummaryImplCopyWith<$Res>
    implements $MonthSummaryCopyWith<$Res> {
  factory _$$MonthSummaryImplCopyWith(
          _$MonthSummaryImpl value, $Res Function(_$MonthSummaryImpl) then) =
      __$$MonthSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int year,
      int month,
      double totalHours,
      int bibleStudiesCount,
      Goal? goal,
      double targetHours,
      double progressPercentage,
      bool isGoalMet});

  @override
  $GoalCopyWith<$Res>? get goal;
}

/// @nodoc
class __$$MonthSummaryImplCopyWithImpl<$Res>
    extends _$MonthSummaryCopyWithImpl<$Res, _$MonthSummaryImpl>
    implements _$$MonthSummaryImplCopyWith<$Res> {
  __$$MonthSummaryImplCopyWithImpl(
      _$MonthSummaryImpl _value, $Res Function(_$MonthSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of MonthSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? year = null,
    Object? month = null,
    Object? totalHours = null,
    Object? bibleStudiesCount = null,
    Object? goal = freezed,
    Object? targetHours = null,
    Object? progressPercentage = null,
    Object? isGoalMet = null,
  }) {
    return _then(_$MonthSummaryImpl(
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as int,
      totalHours: null == totalHours
          ? _value.totalHours
          : totalHours // ignore: cast_nullable_to_non_nullable
              as double,
      bibleStudiesCount: null == bibleStudiesCount
          ? _value.bibleStudiesCount
          : bibleStudiesCount // ignore: cast_nullable_to_non_nullable
              as int,
      goal: freezed == goal
          ? _value.goal
          : goal // ignore: cast_nullable_to_non_nullable
              as Goal?,
      targetHours: null == targetHours
          ? _value.targetHours
          : targetHours // ignore: cast_nullable_to_non_nullable
              as double,
      progressPercentage: null == progressPercentage
          ? _value.progressPercentage
          : progressPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      isGoalMet: null == isGoalMet
          ? _value.isGoalMet
          : isGoalMet // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$MonthSummaryImpl extends _MonthSummary {
  const _$MonthSummaryImpl(
      {required this.year,
      required this.month,
      required this.totalHours,
      required this.bibleStudiesCount,
      this.goal,
      this.targetHours = 0.0,
      required this.progressPercentage,
      required this.isGoalMet})
      : super._();

  /// Year (e.g., 2026)
  @override
  final int year;

  /// Month (1-12)
  @override
  final int month;

  /// Total hours registered in the month
  @override
  final double totalHours;

  /// Count of active Bible studies
  /// (all persons marked as isBibleStudy=true, regardless of visits this month)
  @override
  final int bibleStudiesCount;

  /// Goal for the month (if set manually - for auxiliary pioneers)
  @override
  final Goal? goal;

  /// Target hours for the month
  /// For regular/special pioneers: automatic based on privilege
  /// For publishers: from goal if set, otherwise 0
  @override
  @JsonKey()
  final double targetHours;

  /// Progress percentage (0.0 to 100.0+)
  /// Calculated as (totalHours / targetHours) * 100
  /// If no goal, always 0.0
  @override
  final double progressPercentage;

  /// Whether the goal has been met
  /// If no goal, always false
  @override
  final bool isGoalMet;

  @override
  String toString() {
    return 'MonthSummary(year: $year, month: $month, totalHours: $totalHours, bibleStudiesCount: $bibleStudiesCount, goal: $goal, targetHours: $targetHours, progressPercentage: $progressPercentage, isGoalMet: $isGoalMet)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MonthSummaryImpl &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.totalHours, totalHours) ||
                other.totalHours == totalHours) &&
            (identical(other.bibleStudiesCount, bibleStudiesCount) ||
                other.bibleStudiesCount == bibleStudiesCount) &&
            (identical(other.goal, goal) || other.goal == goal) &&
            (identical(other.targetHours, targetHours) ||
                other.targetHours == targetHours) &&
            (identical(other.progressPercentage, progressPercentage) ||
                other.progressPercentage == progressPercentage) &&
            (identical(other.isGoalMet, isGoalMet) ||
                other.isGoalMet == isGoalMet));
  }

  @override
  int get hashCode => Object.hash(runtimeType, year, month, totalHours,
      bibleStudiesCount, goal, targetHours, progressPercentage, isGoalMet);

  /// Create a copy of MonthSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MonthSummaryImplCopyWith<_$MonthSummaryImpl> get copyWith =>
      __$$MonthSummaryImplCopyWithImpl<_$MonthSummaryImpl>(this, _$identity);
}

abstract class _MonthSummary extends MonthSummary {
  const factory _MonthSummary(
      {required final int year,
      required final int month,
      required final double totalHours,
      required final int bibleStudiesCount,
      final Goal? goal,
      final double targetHours,
      required final double progressPercentage,
      required final bool isGoalMet}) = _$MonthSummaryImpl;
  const _MonthSummary._() : super._();

  /// Year (e.g., 2026)
  @override
  int get year;

  /// Month (1-12)
  @override
  int get month;

  /// Total hours registered in the month
  @override
  double get totalHours;

  /// Count of active Bible studies
  /// (all persons marked as isBibleStudy=true, regardless of visits this month)
  @override
  int get bibleStudiesCount;

  /// Goal for the month (if set manually - for auxiliary pioneers)
  @override
  Goal? get goal;

  /// Target hours for the month
  /// For regular/special pioneers: automatic based on privilege
  /// For publishers: from goal if set, otherwise 0
  @override
  double get targetHours;

  /// Progress percentage (0.0 to 100.0+)
  /// Calculated as (totalHours / targetHours) * 100
  /// If no goal, always 0.0
  @override
  double get progressPercentage;

  /// Whether the goal has been met
  /// If no goal, always false
  @override
  bool get isGoalMet;

  /// Create a copy of MonthSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MonthSummaryImplCopyWith<_$MonthSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
