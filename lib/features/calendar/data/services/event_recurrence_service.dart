import 'package:flutter/material.dart' show TimeOfDay;
import 'package:uuid/uuid.dart';

import '../models/calendar_event.dart';

/// Generates the materialized rows for a weekly-recurring event.
class EventRecurrenceService {
  EventRecurrenceService({Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final Uuid _uuid;

  /// Build the list of [CalendarEvent] rows that represent a single weekly
  /// recurrence (every [weeks] weeks) starting on [startDate] and not going
  /// past [endDate]. All instances share the returned `seriesId`.
  ///
  /// Returns an empty list when `endDate < startDate`.
  ///
  /// [weeks] must be >= 1 (1 = every week, 2 = every other week).
  List<CalendarEvent> generateSeries({
    required int personId,
    required DateTime startDate,
    TimeOfDay? time,
    String? notes,
    required int weeks,
    required DateTime endDate,
    required DateTime now,
  }) {
    if (weeks < 1) {
      throw ArgumentError.value(weeks, 'weeks', 'must be >= 1');
    }

    final start = _dateOnly(startDate);
    final end = _dateOnly(endDate);
    if (end.isBefore(start)) return const [];

    final seriesId = _uuid.v4();
    final endIso = end;
    final out = <CalendarEvent>[];
    for (var d = start; !d.isAfter(end); d = d.add(Duration(days: 7 * weeks))) {
      out.add(
        CalendarEvent(
          id: null,
          personId: personId,
          seriesId: seriesId,
          date: d,
          time: time,
          notes: notes,
          recurrenceWeeks: weeks,
          recurrenceEndDate: endIso,
          createdAt: now,
        ),
      );
    }
    return out;
  }

  /// Strip time-of-day from a [DateTime] so date math doesn't drift.
  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
}
