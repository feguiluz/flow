import 'package:flutter/material.dart' show TimeOfDay;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../shared/providers/database_provider.dart';
import '../../../home/data/providers/activity_notifier.dart';
import '../../../home/data/providers/month_summary_provider.dart';
import '../../../people/data/providers/visit_notifier.dart';
import '../models/calendar_event.dart';
import '../services/event_recurrence_service.dart';

part 'event_provider.g.dart';

/// All events of the given month, ordered chronologically.
@riverpod
Future<List<CalendarEvent>> eventsByMonth(
  EventsByMonthRef ref,
  int year,
  int month,
) async {
  final dao = await ref.watch(eventDaoProvider.future);
  return dao.getByMonth(year, month);
}

/// All events for a single calendar day, ordered by time (NULLs at the end).
@riverpod
Future<List<CalendarEvent>> eventsByDay(
  EventsByDayRef ref,
  DateTime day,
) async {
  final normalized = DateTime(day.year, day.month, day.day);
  final dao = await ref.watch(eventDaoProvider.future);
  return dao.getByDate(normalized);
}

/// Pending events for a person, from today onwards.
@riverpod
Future<List<CalendarEvent>> upcomingEventsByPerson(
  UpcomingEventsByPersonRef ref,
  int personId,
) async {
  final dao = await ref.watch(eventDaoProvider.future);
  return dao.getUpcomingByPerson(personId);
}

/// Single event by id.
@riverpod
Future<CalendarEvent?> eventById(EventByIdRef ref, int id) async {
  final dao = await ref.watch(eventDaoProvider.future);
  return dao.getById(id);
}

/// Mutations for the calendar feature.
///
/// Methods invalidate every event-related provider so the UI refreshes
/// uniformly. `markCompleted` also invalidates visit providers because the
/// completion creates a Visit row that should appear in the person's history.
@riverpod
class EventNotifier extends _$EventNotifier {
  @override
  void build() {
    // Stateless notifier — providers above own the data.
  }

  EventRecurrenceService get _recurrence => EventRecurrenceService();

  /// Create a single event (no recurrence).
  Future<int> createSingle({
    required int personId,
    required DateTime date,
    TimeOfDay? time,
    String? notes,
  }) async {
    final dao = await ref.read(eventDaoProvider.future);
    final event = CalendarEvent(
      id: null,
      personId: personId,
      seriesId: null,
      date: _dateOnly(date),
      time: time,
      notes: notes,
      createdAt: DateTime.now(),
    );
    final id = await dao.insert(event);
    _invalidateEventProviders();
    return id;
  }

  /// Create a weekly recurring series. All instances share the same series_id.
  Future<int> createSeries({
    required int personId,
    required DateTime startDate,
    TimeOfDay? time,
    String? notes,
    required int weeks,
    required DateTime endDate,
  }) async {
    final dao = await ref.read(eventDaoProvider.future);
    final events = _recurrence.generateSeries(
      personId: personId,
      startDate: startDate,
      time: time,
      notes: notes,
      weeks: weeks,
      endDate: endDate,
      now: DateTime.now(),
    );
    if (events.isEmpty) return 0;
    final ids = await dao.insertAll(events);
    _invalidateEventProviders();
    return ids.length;
  }

  /// Update a single occurrence (does not affect siblings in the series).
  Future<void> editInstance(CalendarEvent updated) async {
    final dao = await ref.read(eventDaoProvider.future);
    await dao.update(updated);
    _invalidateEventProviders();
  }

  /// Apply non-date changes to all occurrences of [seriesId] from [fromDate]
  /// onwards. Person, time, notes and recurrence rule may change; the date of
  /// each row stays where it was.
  Future<int> editSeriesFrom({
    required String seriesId,
    required DateTime fromDate,
    required CalendarEvent template,
  }) async {
    final dao = await ref.read(eventDaoProvider.future);
    final updated = await dao.updateSeriesFrom(
      seriesId: seriesId,
      fromDate: fromDate,
      template: template,
    );
    _invalidateEventProviders();
    return updated;
  }

  /// Delete a single occurrence.
  Future<void> deleteInstance(int eventId) async {
    final dao = await ref.read(eventDaoProvider.future);
    await dao.delete(eventId);
    _invalidateEventProviders();
  }

  /// Delete every future occurrence of a series (inclusive of [fromDate]).
  Future<int> deleteSeriesFrom({
    required String seriesId,
    required DateTime fromDate,
  }) async {
    final dao = await ref.read(eventDaoProvider.future);
    final deleted = await dao.deleteSeriesFrom(
      seriesId: seriesId,
      fromDate: fromDate,
    );
    _invalidateEventProviders();
    return deleted;
  }

  /// Link an event to the visit row that just got created from it and
  /// transition its status to `completed`.
  Future<void> markCompleted({
    required int eventId,
    required int visitId,
  }) async {
    final dao = await ref.read(eventDaoProvider.future);
    await dao.markCompleted(eventId: eventId, visitId: visitId);
    _invalidateEventProviders();
    // Visit-side providers also need a refresh: the new visit row should
    // appear in the person's history and feed the monthly counters.
    ref.invalidate(visitsByPersonProvider);
    ref.invalidate(visitsByMonthProvider);
    ref.invalidate(bibleStudiesCountForMonthProvider);
    ref.invalidate(visitCountByPersonProvider);
    ref.invalidate(monthSummaryProvider);
    ref.invalidate(currentMonthSummaryProvider);
    ref.invalidate(activityNotifierProvider);
  }

  void _invalidateEventProviders() {
    ref.invalidate(eventsByMonthProvider);
    ref.invalidate(eventsByDayProvider);
    ref.invalidate(upcomingEventsByPersonProvider);
    ref.invalidate(eventByIdProvider);
  }

  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
}
