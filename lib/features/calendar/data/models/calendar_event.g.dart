// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CalendarEventImpl _$$CalendarEventImplFromJson(Map<String, dynamic> json) =>
    _$CalendarEventImpl(
      id: (json['id'] as num?)?.toInt(),
      personId: (json['personId'] as num).toInt(),
      seriesId: json['seriesId'] as String?,
      date: DateTime.parse(json['date'] as String),
      time: _timeFromJson(json['time'] as String?),
      notes: json['notes'] as String?,
      status: $enumDecodeNullable(_$EventStatusEnumMap, json['status']) ??
          EventStatus.pending,
      visitId: (json['visitId'] as num?)?.toInt(),
      recurrenceWeeks: (json['recurrenceWeeks'] as num?)?.toInt(),
      recurrenceEndDate: json['recurrenceEndDate'] == null
          ? null
          : DateTime.parse(json['recurrenceEndDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$CalendarEventImplToJson(_$CalendarEventImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'personId': instance.personId,
      'seriesId': instance.seriesId,
      'date': instance.date.toIso8601String(),
      'time': _timeToJson(instance.time),
      'notes': instance.notes,
      'status': _$EventStatusEnumMap[instance.status]!,
      'visitId': instance.visitId,
      'recurrenceWeeks': instance.recurrenceWeeks,
      'recurrenceEndDate': instance.recurrenceEndDate?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$EventStatusEnumMap = {
  EventStatus.pending: 'pending',
  EventStatus.completed: 'completed',
};
