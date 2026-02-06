// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GoalImpl _$$GoalImplFromJson(Map<String, dynamic> json) => _$GoalImpl(
      id: (json['id'] as num?)?.toInt(),
      year: (json['year'] as num).toInt(),
      month: (json['month'] as num).toInt(),
      goalType: $enumDecode(_$GoalTypeEnumMap, json['goalType']),
      targetHours: (json['targetHours'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$GoalImplToJson(_$GoalImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'year': instance.year,
      'month': instance.month,
      'goalType': _$GoalTypeEnumMap[instance.goalType]!,
      'targetHours': instance.targetHours,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$GoalTypeEnumMap = {
  GoalType.publisher: 'publisher',
  GoalType.auxiliaryPioneer15: 'auxiliaryPioneer15',
  GoalType.auxiliaryPioneer30: 'auxiliaryPioneer30',
  GoalType.regularPioneer: 'regularPioneer',
  GoalType.specialPioneer: 'specialPioneer',
  GoalType.missionary: 'missionary',
};
