import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter_test/flutter_test.dart';

import 'package:flow/features/calendar/data/services/event_recurrence_service.dart';

void main() {
  final service = EventRecurrenceService();
  final now = DateTime(2026, 4, 18, 17, 30);

  group('EventRecurrenceService.generateSeries', () {
    test('weekly cadence — generates one row per week up to endDate', () {
      final start = DateTime(2026, 4, 6); // Monday
      final end = DateTime(2026, 5, 4); // 4 weeks later, Monday

      final events = service.generateSeries(
        personId: 7,
        startDate: start,
        time: const TimeOfDay(hour: 18, minute: 30),
        notes: 'Llevar publicación',
        weeks: 1,
        endDate: end,
        now: now,
      );

      expect(events, hasLength(5));
      expect(events.first.date, DateTime(2026, 4, 6));
      expect(events[1].date, DateTime(2026, 4, 13));
      expect(events.last.date, DateTime(2026, 5, 4));
      expect(events.every((e) => e.personId == 7), isTrue);
      expect(events.every((e) => e.recurrenceWeeks == 1), isTrue);
      expect(events.every((e) => e.time?.hour == 18), isTrue);
      // All instances share the same series id.
      final seriesIds = events.map((e) => e.seriesId).toSet();
      expect(seriesIds, hasLength(1));
      expect(seriesIds.first, isNotNull);
    });

    test('biweekly cadence — every other week only', () {
      final start = DateTime(2026, 4, 6);
      final end = DateTime(2026, 6, 1); // ~8 weeks

      final events = service.generateSeries(
        personId: 7,
        startDate: start,
        weeks: 2,
        endDate: end,
        now: now,
      );

      expect(events.map((e) => e.date), [
        DateTime(2026, 4, 6),
        DateTime(2026, 4, 20),
        DateTime(2026, 5, 4),
        DateTime(2026, 5, 18),
        DateTime(2026, 6, 1),
      ]);
      expect(events.every((e) => e.recurrenceWeeks == 2), isTrue);
    });

    test('endDate before startDate → empty list', () {
      final events = service.generateSeries(
        personId: 1,
        startDate: DateTime(2026, 4, 10),
        weeks: 1,
        endDate: DateTime(2026, 4, 1),
        now: now,
      );

      expect(events, isEmpty);
    });

    test('endDate equal to startDate → exactly one row', () {
      final events = service.generateSeries(
        personId: 1,
        startDate: DateTime(2026, 4, 10),
        weeks: 1,
        endDate: DateTime(2026, 4, 10),
        now: now,
      );

      expect(events, hasLength(1));
      expect(events.first.date, DateTime(2026, 4, 10));
    });

    test('weeks < 1 throws', () {
      expect(
        () => service.generateSeries(
          personId: 1,
          startDate: DateTime(2026, 4, 10),
          weeks: 0,
          endDate: DateTime(2026, 4, 24),
          now: now,
        ),
        throwsArgumentError,
      );
    });

    test('strips time from startDate so cadence is exact', () {
      // Pass startDate with hours; cadence should still land on the same
      // wall-clock day each step (no DST drift, no off-by-hours).
      final start = DateTime(2026, 4, 6, 23, 59);
      final events = service.generateSeries(
        personId: 1,
        startDate: start,
        weeks: 1,
        endDate: DateTime(2026, 4, 27),
        now: now,
      );
      expect(events.map((e) => e.date), [
        DateTime(2026, 4, 6),
        DateTime(2026, 4, 13),
        DateTime(2026, 4, 20),
        DateTime(2026, 4, 27),
      ]);
    });
  });
}
