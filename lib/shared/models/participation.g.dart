// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ParticipationImpl _$$ParticipationImplFromJson(Map<String, dynamic> json) =>
    _$ParticipationImpl(
      id: (json['id'] as num?)?.toInt(),
      year: (json['year'] as num).toInt(),
      month: (json['month'] as num).toInt(),
      participated: json['participated'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$ParticipationImplToJson(_$ParticipationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'year': instance.year,
      'month': instance.month,
      'participated': instance.participated,
      'createdAt': instance.createdAt.toIso8601String(),
    };
