import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:flow/core/database/daos/event_dao.dart';
import 'package:flow/core/database/database.dart';
import 'package:flow/features/calendar/data/models/calendar_event.dart';

/// In-memory schema mirroring the live DDL — no need to touch the
/// AppDatabase file path during tests. Keep aligned with database.dart.
Future<void> _createSchema(Database db, int _) async {
  await db.execute('''
    CREATE TABLE people (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      phone TEXT,
      address TEXT,
      notes TEXT,
      is_bible_study INTEGER NOT NULL DEFAULT 0,
      latitude REAL,
      longitude REAL,
      created_at TEXT NOT NULL
    )
  ''');
  await db.execute('''
    CREATE TABLE visits (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      person_id INTEGER NOT NULL,
      date TEXT NOT NULL,
      notes TEXT,
      created_at TEXT NOT NULL,
      FOREIGN KEY (person_id) REFERENCES people (id) ON DELETE CASCADE
    )
  ''');
  await db.execute('''
    CREATE TABLE events (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      person_id INTEGER NOT NULL,
      series_id TEXT,
      date TEXT NOT NULL,
      time TEXT,
      notes TEXT,
      status TEXT NOT NULL DEFAULT 'pending',
      visit_id INTEGER,
      recurrence_weeks INTEGER,
      recurrence_end_date TEXT,
      created_at TEXT NOT NULL,
      FOREIGN KEY (person_id) REFERENCES people (id) ON DELETE CASCADE,
      FOREIGN KEY (visit_id) REFERENCES visits (id) ON DELETE SET NULL
    )
  ''');
  await db.execute('CREATE INDEX idx_events_date ON events(date)');
  await db.execute('CREATE INDEX idx_events_person ON events(person_id)');
  await db.execute('CREATE INDEX idx_events_series ON events(series_id)');
}

Future<Database> _openInMemory() {
  return databaseFactoryFfi.openDatabase(
    inMemoryDatabasePath,
    options: OpenDatabaseOptions(
      version: AppDatabase.kDatabaseVersion,
      onCreate: _createSchema,
      onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
    ),
  );
}

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  late Database db;
  late EventDao dao;

  setUp(() async {
    db = await _openInMemory();
    dao = EventDao(db);
    // Two people available throughout.
    await db.insert('people', {
      'id': 1,
      'name': 'Ana',
      'is_bible_study': 0,
      'created_at': '2026-04-01',
    });
    await db.insert('people', {
      'id': 2,
      'name': 'Juan',
      'is_bible_study': 1,
      'created_at': '2026-04-01',
    });
  });

  tearDown(() async {
    await db.close();
  });

  CalendarEvent _puntual({
    required int personId,
    required DateTime date,
    TimeOfDay? time,
    String? notes,
    String? seriesId,
    int? recurrenceWeeks,
    DateTime? recurrenceEndDate,
  }) {
    return CalendarEvent(
      id: null,
      personId: personId,
      seriesId: seriesId,
      date: date,
      time: time,
      notes: notes,
      recurrenceWeeks: recurrenceWeeks,
      recurrenceEndDate: recurrenceEndDate,
      createdAt: DateTime(2026, 4, 18),
    );
  }

  group('CRUD', () {
    test('insert + getById round-trips all fields including time', () async {
      final id = await dao.insert(_puntual(
        personId: 1,
        date: DateTime(2026, 4, 20),
        time: const TimeOfDay(hour: 18, minute: 30),
        notes: 'recordatorio',
      ));

      final fetched = await dao.getById(id);
      expect(fetched, isNotNull);
      expect(fetched!.personId, 1);
      expect(fetched.date, DateTime(2026, 4, 20));
      expect(fetched.time, const TimeOfDay(hour: 18, minute: 30));
      expect(fetched.notes, 'recordatorio');
      expect(fetched.status, EventStatus.pending);
      expect(fetched.seriesId, isNull);
    });

    test('insertAll preserves seriesId across rows', () async {
      const seriesId = 'abc-123';
      await dao.insertAll([
        _puntual(
          personId: 1,
          date: DateTime(2026, 4, 6),
          seriesId: seriesId,
          recurrenceWeeks: 1,
          recurrenceEndDate: DateTime(2026, 4, 27),
        ),
        _puntual(
          personId: 1,
          date: DateTime(2026, 4, 13),
          seriesId: seriesId,
          recurrenceWeeks: 1,
          recurrenceEndDate: DateTime(2026, 4, 27),
        ),
      ]);

      final april = await dao.getByMonth(2026, 4);
      expect(april, hasLength(2));
      expect(april.every((e) => e.seriesId == seriesId), isTrue);
    });

    test('delete removes the row', () async {
      final id = await dao.insert(
          _puntual(personId: 1, date: DateTime(2026, 4, 10)));
      await dao.delete(id);
      expect(await dao.getById(id), isNull);
    });
  });

  group('Queries', () {
    setUp(() async {
      await dao.insertAll([
        _puntual(
            personId: 1,
            date: DateTime(2026, 4, 10),
            time: const TimeOfDay(hour: 9, minute: 0)),
        _puntual(
            personId: 1,
            date: DateTime(2026, 4, 10)), // sin hora — al final
        _puntual(
            personId: 2,
            date: DateTime(2026, 4, 10),
            time: const TimeOfDay(hour: 18, minute: 0)),
        _puntual(personId: 2, date: DateTime(2026, 5, 1)),
      ]);
    });

    test('getByMonth filters strictly by month and orders by date+time',
        () async {
      final april = await dao.getByMonth(2026, 4);
      expect(april, hasLength(3));
      expect(april.first.time, const TimeOfDay(hour: 9, minute: 0));
      expect(april[1].time, const TimeOfDay(hour: 18, minute: 0));
      expect(april.last.time, isNull);
    });

    test('getByDate orders timed entries first', () async {
      final day = await dao.getByDate(DateTime(2026, 4, 10));
      expect(day, hasLength(3));
      expect(day.first.time?.hour, 9);
      expect(day[1].time?.hour, 18);
      expect(day.last.time, isNull);
    });

    test('getUpcomingByPerson returns only pending events from "from" date',
        () async {
      // Mark Juan's May event as completed; his April event stays pending.
      final mayJuans = await dao.getByMonth(2026, 5);
      expect(mayJuans, hasLength(1));
      final visitId = await db.insert('visits', {
        'person_id': 2,
        'date': '2026-05-01',
        'notes': null,
        'created_at': '2026-05-01',
      });
      await dao.markCompleted(eventId: mayJuans.first.id!, visitId: visitId);

      // Juan: solo el de abril sigue pendiente.
      final juanUpcoming =
          await dao.getUpcomingByPerson(2, from: DateTime(2026, 4, 1));
      expect(juanUpcoming, hasLength(1));
      expect(juanUpcoming.first.date, DateTime(2026, 4, 10));

      // Ana: dos eventos pendientes.
      final anaUpcoming =
          await dao.getUpcomingByPerson(1, from: DateTime(2026, 4, 1));
      expect(anaUpcoming, hasLength(2));

      // 'from' filter respects strict >= comparison.
      final juanFromMay =
          await dao.getUpcomingByPerson(2, from: DateTime(2026, 4, 11));
      expect(juanFromMay, isEmpty);
    });
  });

  group('Series mutations', () {
    const seriesId = 'series-xyz';

    setUp(() async {
      await dao.insertAll([
        _puntual(
          personId: 1,
          date: DateTime(2026, 4, 6),
          time: const TimeOfDay(hour: 19, minute: 0),
          seriesId: seriesId,
          recurrenceWeeks: 1,
          recurrenceEndDate: DateTime(2026, 4, 27),
        ),
        _puntual(
          personId: 1,
          date: DateTime(2026, 4, 13),
          time: const TimeOfDay(hour: 19, minute: 0),
          seriesId: seriesId,
          recurrenceWeeks: 1,
          recurrenceEndDate: DateTime(2026, 4, 27),
        ),
        _puntual(
          personId: 1,
          date: DateTime(2026, 4, 20),
          time: const TimeOfDay(hour: 19, minute: 0),
          seriesId: seriesId,
          recurrenceWeeks: 1,
          recurrenceEndDate: DateTime(2026, 4, 27),
        ),
        _puntual(
          personId: 1,
          date: DateTime(2026, 4, 27),
          time: const TimeOfDay(hour: 19, minute: 0),
          seriesId: seriesId,
          recurrenceWeeks: 1,
          recurrenceEndDate: DateTime(2026, 4, 27),
        ),
      ]);
    });

    test('updateSeriesFrom changes time on rows >= cutoff only', () async {
      // Cutoff = 13 abril (incluido). Las del 6 abril deben permanecer 19:00.
      final cutoff = DateTime(2026, 4, 13);
      final tpl = _puntual(
        personId: 1,
        date: cutoff,
        time: const TimeOfDay(hour: 20, minute: 0),
        seriesId: seriesId,
        recurrenceWeeks: 1,
        recurrenceEndDate: DateTime(2026, 4, 27),
      );

      final affected = await dao.updateSeriesFrom(
        seriesId: seriesId,
        fromDate: cutoff,
        template: tpl,
      );
      expect(affected, 3);

      final april = await dao.getByMonth(2026, 4);
      final byDate = {
        for (final e in april) e.date: e.time,
      };
      expect(byDate[DateTime(2026, 4, 6)], const TimeOfDay(hour: 19, minute: 0));
      expect(byDate[DateTime(2026, 4, 13)],
          const TimeOfDay(hour: 20, minute: 0));
      expect(byDate[DateTime(2026, 4, 20)],
          const TimeOfDay(hour: 20, minute: 0));
      expect(byDate[DateTime(2026, 4, 27)],
          const TimeOfDay(hour: 20, minute: 0));
    });

    test('deleteSeriesFrom removes rows >= cutoff and leaves earlier intact',
        () async {
      final cutoff = DateTime(2026, 4, 20);
      final removed = await dao.deleteSeriesFrom(
        seriesId: seriesId,
        fromDate: cutoff,
      );
      expect(removed, 2);

      final remaining = await dao.getByMonth(2026, 4);
      expect(remaining, hasLength(2));
      expect(remaining.map((e) => e.date), [
        DateTime(2026, 4, 6),
        DateTime(2026, 4, 13),
      ]);
    });
  });

  group('markCompleted', () {
    test('sets status to completed and stores visit_id', () async {
      // Need a real visit row because of FK ON DELETE SET NULL.
      final visitId = await db.insert('visits', {
        'person_id': 1,
        'date': '2026-04-10',
        'notes': null,
        'created_at': '2026-04-10',
      });
      final eventId = await dao.insert(
          _puntual(personId: 1, date: DateTime(2026, 4, 10)));

      await dao.markCompleted(eventId: eventId, visitId: visitId);

      final fetched = await dao.getById(eventId);
      expect(fetched!.status, EventStatus.completed);
      expect(fetched.visitId, visitId);
    });

    test('deleting linked visit nulls visit_id but keeps status', () async {
      final visitId = await db.insert('visits', {
        'person_id': 1,
        'date': '2026-04-10',
        'notes': null,
        'created_at': '2026-04-10',
      });
      final eventId = await dao.insert(
          _puntual(personId: 1, date: DateTime(2026, 4, 10)));
      await dao.markCompleted(eventId: eventId, visitId: visitId);

      await db.delete('visits', where: 'id = ?', whereArgs: [visitId]);

      final fetched = await dao.getById(eventId);
      expect(fetched!.visitId, isNull);
      expect(fetched.status, EventStatus.completed);
    });

    test('deleting person cascades and removes the event', () async {
      final eventId = await dao.insert(
          _puntual(personId: 1, date: DateTime(2026, 4, 10)));
      await db.delete('people', where: 'id = ?', whereArgs: [1]);
      expect(await dao.getById(eventId), isNull);
    });
  });
}
