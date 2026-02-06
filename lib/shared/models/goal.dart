import 'package:freezed_annotation/freezed_annotation.dart';

part 'goal.freezed.dart';
part 'goal.g.dart';

/// Goal types for ministry service
enum GoalType {
  publisher,
  auxiliaryPioneer15,
  auxiliaryPioneer30,
  regularPioneer,
  specialPioneer,
  missionary,
}

/// Goal model representing a monthly service goal
@freezed
class Goal with _$Goal {
  const factory Goal({
    required int? id,
    required int year,
    required int month,
    required GoalType goalType,
    double? targetHours,
    required DateTime createdAt,
  }) = _Goal;

  factory Goal.fromJson(Map<String, dynamic> json) => _$GoalFromJson(json);
}
