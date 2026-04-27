import 'package:flutter/material.dart' show TimeOfDay;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_event.freezed.dart';
part 'calendar_event.g.dart';

/// Lifecycle of a calendar event.
///
/// `pending`   — programado, aún no se ha cumplido
/// `completed` — convertido en revisita; `visitId` apunta al registro creado
enum EventStatus {
  pending,
  completed,
}

/// A scheduled calendar event linked to a person.
///
/// Recurring events are materialized: every occurrence is a separate row
/// sharing the same [seriesId]. This keeps month queries trivial and makes
/// "complete only this instance" / "edit series from here" straightforward.
@freezed
class CalendarEvent with _$CalendarEvent {
  const factory CalendarEvent({
    required int? id,
    required int personId,
    String? seriesId,
    required DateTime date,
    @JsonKey(fromJson: _timeFromJson, toJson: _timeToJson) TimeOfDay? time,
    String? notes,
    @Default(EventStatus.pending) EventStatus status,
    int? visitId,
    int? recurrenceWeeks,
    DateTime? recurrenceEndDate,
    required DateTime createdAt,
  }) = _CalendarEvent;

  factory CalendarEvent.fromJson(Map<String, dynamic> json) =>
      _$CalendarEventFromJson(json);
}

TimeOfDay? _timeFromJson(String? raw) {
  if (raw == null || raw.isEmpty) return null;
  final parts = raw.split(':');
  if (parts.length != 2) return null;
  final h = int.tryParse(parts[0]);
  final m = int.tryParse(parts[1]);
  if (h == null || m == null) return null;
  return TimeOfDay(hour: h, minute: m);
}

String? _timeToJson(TimeOfDay? value) {
  if (value == null) return null;
  return '${value.hour.toString().padLeft(2, '0')}:'
      '${value.minute.toString().padLeft(2, '0')}';
}

/// Helpers shared by the DAO and providers when crossing the SQLite boundary.
extension CalendarEventTimeCodec on CalendarEvent {
  static String? encodeTime(TimeOfDay? value) => _timeToJson(value);
  static TimeOfDay? decodeTime(String? raw) => _timeFromJson(raw);
}
