// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VisitImpl _$$VisitImplFromJson(Map<String, dynamic> json) => _$VisitImpl(
      id: (json['id'] as num?)?.toInt(),
      personId: (json['personId'] as num).toInt(),
      date: DateTime.parse(json['date'] as String),
      notes: json['notes'] as String?,
      countedAsStudy: json['countedAsStudy'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$VisitImplToJson(_$VisitImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'personId': instance.personId,
      'date': instance.date.toIso8601String(),
      'notes': instance.notes,
      'countedAsStudy': instance.countedAsStudy,
      'createdAt': instance.createdAt.toIso8601String(),
    };
