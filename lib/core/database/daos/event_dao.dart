import 'package:sqflite/sqflite.dart';

import '../../../features/calendar/data/models/calendar_event.dart';
import '../../utils/date_formatter.dart';

/// Data Access Object for the events table.
///
/// Recurring events are materialized: each occurrence is its own row sharing
/// a `series_id`. Mutations on a series filter by `series_id` AND `date >= ?`
/// so that past occurrences (already completed or simply elapsed) stay
/// untouched when the user edits/deletes "from this point on".
class EventDao {
  const EventDao(this.db);

  final Database db;

  // ==================== CRUD ====================

  /// Insert a single event row. Returns the new id.
  Future<int> insert(CalendarEvent event) async {
    return await db.insert(
      'events',
      _toRow(event),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Insert all rows in a single transaction. Used to materialize a series.
  Future<List<int>> insertAll(List<CalendarEvent> events) async {
    final ids = <int>[];
    await db.transaction((txn) async {
      for (final event in events) {
        ids.add(await txn.insert(
          'events',
          _toRow(event),
          conflictAlgorithm: ConflictAlgorithm.replace,
        ));
      }
    });
    return ids;
  }

  /// Update a single event by id.
  Future<void> update(CalendarEvent event) async {
    if (event.id == null) {
      throw ArgumentError('CalendarEvent must have an ID to update');
    }
    await db.update(
      'events',
      _toRow(event),
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  /// Apply changes to all instances of a series whose date is on or after
  /// [fromDate]. Date is intentionally not propagated — only the editable
  /// fields. The series_id is preserved.
  Future<int> updateSeriesFrom({
    required String seriesId,
    required DateTime fromDate,
    required CalendarEvent template,
  }) async {
    return await db.update(
      'events',
      {
        'person_id': template.personId,
        'time': CalendarEventTimeCodec.encodeTime(template.time),
        'notes': template.notes,
        'recurrence_weeks': template.recurrenceWeeks,
        'recurrence_end_date': template.recurrenceEndDate == null
            ? null
            : DateFormatter.formatForDb(template.recurrenceEndDate!),
      },
      where: 'series_id = ? AND date >= ?',
      whereArgs: [seriesId, DateFormatter.formatForDb(fromDate)],
    );
  }

  /// Delete a single event row.
  Future<void> delete(int id) async {
    await db.delete(
      'events',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Delete every instance of a series with date >= fromDate.
  Future<int> deleteSeriesFrom({
    required String seriesId,
    required DateTime fromDate,
  }) async {
    return await db.delete(
      'events',
      where: 'series_id = ? AND date >= ?',
      whereArgs: [seriesId, DateFormatter.formatForDb(fromDate)],
    );
  }

  /// Mark a single instance as completed and link it to the visit row that
  /// was created from it.
  Future<void> markCompleted({
    required int eventId,
    required int visitId,
  }) async {
    await db.update(
      'events',
      {
        'status': EventStatus.completed.name,
        'visit_id': visitId,
      },
      where: 'id = ?',
      whereArgs: [eventId],
    );
  }

  // ==================== Queries ====================

  Future<CalendarEvent?> getById(int id) async {
    final maps = await db.query(
      'events',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return _fromRow(maps.first);
  }

  /// All events of a calendar month, ordered chronologically.
  /// Events without a time appear after the timed ones for the same day.
  Future<List<CalendarEvent>> getByMonth(int year, int month) async {
    final monthStr = month.toString().padLeft(2, '0');
    final pattern = '$year-$monthStr-%';

    final maps = await db.query(
      'events',
      where: 'date LIKE ?',
      whereArgs: [pattern],
      orderBy: 'date ASC, time IS NULL, time ASC',
    );

    return maps.map(_fromRow).toList();
  }

  /// All events for a single day, ordered by time (NULLs at the end).
  Future<List<CalendarEvent>> getByDate(DateTime day) async {
    final maps = await db.query(
      'events',
      where: 'date = ?',
      whereArgs: [DateFormatter.formatForDb(day)],
      orderBy: 'time IS NULL, time ASC',
    );
    return maps.map(_fromRow).toList();
  }

  /// Pending events for a given person from [from] onwards (inclusive).
  /// Used in the person-detail screen.
  Future<List<CalendarEvent>> getUpcomingByPerson(
    int personId, {
    DateTime? from,
  }) async {
    final fromStr = DateFormatter.formatForDb(
      from ?? DateTime.now(),
    );
    final maps = await db.query(
      'events',
      where: 'person_id = ? AND status = ? AND date >= ?',
      whereArgs: [personId, EventStatus.pending.name, fromStr],
      orderBy: 'date ASC, time IS NULL, time ASC',
    );
    return maps.map(_fromRow).toList();
  }

  // ==================== Mapping ====================

  Map<String, Object?> _toRow(CalendarEvent event) {
    return {
      if (event.id != null) 'id': event.id,
      'person_id': event.personId,
      'series_id': event.seriesId,
      'date': DateFormatter.formatForDb(event.date),
      'time': CalendarEventTimeCodec.encodeTime(event.time),
      'notes': event.notes,
      'status': event.status.name,
      'visit_id': event.visitId,
      'recurrence_weeks': event.recurrenceWeeks,
      'recurrence_end_date': event.recurrenceEndDate == null
          ? null
          : DateFormatter.formatForDb(event.recurrenceEndDate!),
      'created_at': DateFormatter.formatForDb(event.createdAt),
    };
  }

  CalendarEvent _fromRow(Map<String, Object?> row) {
    return CalendarEvent(
      id: row['id'] as int?,
      personId: row['person_id'] as int,
      seriesId: row['series_id'] as String?,
      date: DateFormatter.parseFromDb(row['date'] as String),
      time: CalendarEventTimeCodec.decodeTime(row['time'] as String?),
      notes: row['notes'] as String?,
      status: _decodeStatus(row['status'] as String?),
      visitId: row['visit_id'] as int?,
      recurrenceWeeks: row['recurrence_weeks'] as int?,
      recurrenceEndDate: row['recurrence_end_date'] == null
          ? null
          : DateFormatter.parseFromDb(row['recurrence_end_date'] as String),
      createdAt: DateFormatter.parseFromDb(row['created_at'] as String),
    );
  }

  EventStatus _decodeStatus(String? raw) {
    return EventStatus.values.firstWhere(
      (s) => s.name == raw,
      orElse: () => EventStatus.pending,
    );
  }
}
