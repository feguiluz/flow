import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:flow/core/database/database.dart';
import 'package:flow/core/services/user_profile_service.dart';
import 'package:flow/features/backup/data/models/flow_backup.dart';
import 'package:flow/features/backup/data/services/backup_service.dart';

/// Schema creator matching the DDL in lib/core/database/database.dart.
/// Kept inline so tests don't depend on AppDatabase's file-based init.
Future<void> _createSchema(Database db, int _) async {
  await db.execute('''
    CREATE TABLE activities (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      date TEXT NOT NULL,
      minutes INTEGER NOT NULL,
      notes TEXT,
      created_at TEXT NOT NULL
    )
  ''');
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
    CREATE TABLE goals (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      year INTEGER NOT NULL,
      month INTEGER NOT NULL,
      goal_type TEXT NOT NULL,
      target_hours REAL,
      created_at TEXT NOT NULL,
      UNIQUE(year, month)
    )
  ''');
  await db.execute('''
    CREATE TABLE participations (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      year INTEGER NOT NULL,
      month INTEGER NOT NULL,
      participated INTEGER NOT NULL DEFAULT 0,
      created_at TEXT NOT NULL,
      UNIQUE(year, month)
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
  late Directory tempDir;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('flow_backup_test_');
  });

  tearDown(() async {
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  Future<BackupService> buildService(Database db) async {
    SharedPreferences.setMockInitialValues({
      'user_name': 'Juan',
      'user_publisher_type': 'regularPioneer',
      'user_gender': 'male',
      'user_birth_date': '1990-05-20',
      'theme_mode': 'dark',
    });
    final profile = UserProfileService.instance;
    await profile.init();

    return BackupService(
      resolveDatabase: () async => db,
      profileService: profile,
      exportDirProvider: () async => tempDir,
      snapshotDirProvider: () async => tempDir,
      clock: () => DateTime.utc(2026, 4, 18, 17, 30),
    );
  }

  Future<void> _seed(Database db) async {
    await db.insert('activities', {
      'id': 1,
      'date': '2026-04-10',
      'minutes': 120,
      'notes': 'morning',
      'created_at': '2026-04-10T09:00:00.000',
    });
    await db.insert('people', {
      'id': 1,
      'name': 'Ana',
      'phone': '555-1234',
      'address': null,
      'notes': null,
      'is_bible_study': 1,
      'latitude': 40.4168,
      'longitude': -3.7038,
      'created_at': '2026-03-01T10:00:00.000',
    });
    await db.insert('visits', {
      'id': 1,
      'person_id': 1,
      'date': '2026-04-05',
      'notes': 'first visit',
      'created_at': '2026-04-05T15:00:00.000',
    });
    await db.insert('goals', {
      'id': 1,
      'year': 2026,
      'month': 4,
      'goal_type': 'regularPioneer',
      'target_hours': 50.0,
      'created_at': '2026-04-01T00:00:00.000',
    });
    await db.insert('participations', {
      'id': 1,
      'year': 2026,
      'month': 4,
      'participated': 1,
      'created_at': '2026-04-01T00:00:00.000',
    });
    // One single + a 2-instance series + one already completed (linked to visit 1).
    await db.insert('events', {
      'id': 1,
      'person_id': 1,
      'series_id': null,
      'date': '2026-04-20',
      'time': '18:30',
      'notes': 'one-off',
      'status': 'pending',
      'visit_id': null,
      'recurrence_weeks': null,
      'recurrence_end_date': null,
      'created_at': '2026-04-18T17:30:00.000',
    });
    await db.insert('events', {
      'id': 2,
      'person_id': 1,
      'series_id': 'series-abc',
      'date': '2026-05-04',
      'time': '19:00',
      'notes': null,
      'status': 'pending',
      'visit_id': null,
      'recurrence_weeks': 1,
      'recurrence_end_date': '2026-05-11',
      'created_at': '2026-04-18T17:30:00.000',
    });
    await db.insert('events', {
      'id': 3,
      'person_id': 1,
      'series_id': 'series-abc',
      'date': '2026-05-11',
      'time': '19:00',
      'notes': null,
      'status': 'pending',
      'visit_id': null,
      'recurrence_weeks': 1,
      'recurrence_end_date': '2026-05-11',
      'created_at': '2026-04-18T17:30:00.000',
    });
    await db.insert('events', {
      'id': 4,
      'person_id': 1,
      'series_id': null,
      'date': '2026-04-05',
      'time': null,
      'notes': 'past — became visit 1',
      'status': 'completed',
      'visit_id': 1,
      'recurrence_weeks': null,
      'recurrence_end_date': null,
      'created_at': '2026-04-04T10:00:00.000',
    });
  }

  group('BackupService', () {
    test('exportToTempFile writes a valid .flow file with all rows', () async {
      final db = await _openInMemory();
      await _seed(db);
      final service = await buildService(db);

      final file = await service.exportToTempFile();

      expect(await file.exists(), isTrue);
      expect(file.path.endsWith('.flow'), isTrue);

      final content = await file.readAsString();
      expect(content, contains('"format": "flow-backup-v1"'));
      expect(content, contains('"schemaVersion": ${AppDatabase.kDatabaseVersion}'));
      expect(content, contains('"user_name": "Juan"'));
      expect(content, contains('"name": "Ana"'));
      // Calendar events are also exported.
      expect(content, contains('"events"'));
      expect(content, contains('"series_id": "series-abc"'));
      expect(content, contains('"time": "18:30"'));
      expect(content, contains('"status": "completed"'));

      await db.close();
    });

    test('importFromFile replaces DB rows and preferences with backup contents',
        () async {
      // 1. Seed original state and export
      final db = await _openInMemory();
      await _seed(db);
      final service = await buildService(db);
      final exported = await service.exportToTempFile();

      // 2. Wipe everything and replace profile values
      // Order matters because events FK to visits and people.
      await db.delete('events');
      await db.delete('activities');
      await db.delete('visits');
      await db.delete('people');
      await db.delete('goals');
      await db.delete('participations');

      SharedPreferences.setMockInitialValues({});
      await UserProfileService.instance.init();
      expect(UserProfileService.instance.getUserName(), isNull);

      // 3. Import — should restore rows and profile
      await service.importFromFile(exported);

      final activities = await db.query('activities');
      final people = await db.query('people');
      final visits = await db.query('visits');
      final goals = await db.query('goals');
      final parts = await db.query('participations');
      final events = await db.query('events', orderBy: 'id');

      expect(activities, hasLength(1));
      expect(activities.first['id'], 1);
      expect(activities.first['minutes'], 120);

      expect(people, hasLength(1));
      expect(people.first['name'], 'Ana');
      expect(people.first['is_bible_study'], 1);
      expect(people.first['latitude'], 40.4168);

      expect(visits, hasLength(1));
      expect(visits.first['person_id'], 1);

      expect(goals, hasLength(1));
      expect(goals.first['target_hours'], 50.0);

      expect(parts, hasLength(1));
      expect(parts.first['participated'], 1);

      expect(events, hasLength(4));
      expect(events.first['id'], 1);
      expect(events.first['date'], '2026-04-20');
      expect(events.first['time'], '18:30');
      expect(events[1]['series_id'], 'series-abc');
      expect(events[1]['recurrence_weeks'], 1);
      expect(events.last['status'], 'completed');
      expect(events.last['visit_id'], 1);

      expect(UserProfileService.instance.getUserName(), 'Juan');
      expect(UserProfileService.instance.getBirthDate(),
          DateTime(1990, 5, 20));

      await db.close();
    });

    test('imports an old backup that lacks the events key without errors',
        () async {
      // Forge a legacy backup payload (schemaVersion 5, no `events`) on disk
      // and try to import it. The service must default events to [] and not
      // crash, leaving the rest of the state restored.
      final db = await _openInMemory();
      final service = await buildService(db);

      final legacy = '''
{
  "meta": {
    "format": "flow-backup-v1",
    "appVersion": "1.1.0",
    "schemaVersion": 5,
    "createdAt": "2026-03-01T00:00:00.000Z"
  },
  "preferences": {
    "user_name": "Maria",
    "user_publisher_type": "publisher",
    "user_gender": "female",
    "user_birth_date": "1985-01-01"
  },
  "data": {
    "activities": [],
    "people": [],
    "visits": [],
    "goals": [],
    "participations": []
  }
}
''';
      final legacyFile = File('${tempDir.path}/legacy.flow');
      await legacyFile.writeAsString(legacy);

      await service.importFromFile(legacyFile);

      final events = await db.query('events');
      expect(events, isEmpty);
      expect(UserProfileService.instance.getUserName(), 'Maria');

      await db.close();
    });

    test('buildBackup snapshot reflects current state (not stale)', () async {
      final db = await _openInMemory();
      final service = await buildService(db);

      var backup = await service.buildBackup();
      expect(backup.data.activities, isEmpty);

      await db.insert('activities', {
        'date': '2026-01-01',
        'minutes': 30,
        'notes': null,
        'created_at': '2026-01-01T00:00:00.000',
      });

      backup = await service.buildBackup();
      expect(backup.data.activities, hasLength(1));
      expect(backup.meta.format, BackupMeta.kFormat);
      expect(backup.meta.schemaVersion, AppDatabase.kDatabaseVersion);

      await db.close();
    });

    test('importFromFile writes a pre-import snapshot', () async {
      final db = await _openInMemory();
      await _seed(db);
      final service = await buildService(db);
      final exported = await service.exportToTempFile();

      await service.importFromFile(exported);

      final snapshot = File('${tempDir.path}/$kPreImportSnapshotName');
      expect(await snapshot.exists(), isTrue);

      await db.close();
    });
  });

  group('BackupService.validateCompleteProfile', () {
    FlowBackup withPreferences(Map<String, Object?> prefs) {
      return FlowBackup(
        meta: BackupMeta(
          format: BackupMeta.kFormat,
          appVersion: '1.0.0',
          schemaVersion: AppDatabase.kDatabaseVersion,
          createdAt: '2026-04-18T17:30:00.000Z',
        ),
        preferences: prefs,
        data: const BackupData(),
      );
    }

    late BackupService service;

    setUp(() async {
      final db = await _openInMemory();
      service = await buildService(db);
    });

    test('passes when all four required keys are present', () {
      final backup = withPreferences({
        'user_name': 'Juan',
        'user_publisher_type': 'publisher',
        'user_gender': 'male',
        'user_birth_date': '1990-05-20',
      });

      expect(() => service.validateCompleteProfile(backup), returnsNormally);
    });

    test('throws when user_name is missing', () {
      final backup = withPreferences({
        'user_publisher_type': 'publisher',
        'user_gender': 'male',
        'user_birth_date': '1990-05-20',
      });

      expect(
        () => service.validateCompleteProfile(backup),
        throwsA(
          isA<BackupIncompleteProfileException>().having(
            (e) => e.missingKeys,
            'missingKeys',
            contains('user_name'),
          ),
        ),
      );
    });

    test('throws when a required key is present but empty string', () {
      final backup = withPreferences({
        'user_name': 'Juan',
        'user_publisher_type': '',
        'user_gender': 'male',
        'user_birth_date': '1990-05-20',
      });

      expect(
        () => service.validateCompleteProfile(backup),
        throwsA(
          isA<BackupIncompleteProfileException>().having(
            (e) => e.missingKeys,
            'missingKeys',
            ['user_publisher_type'],
          ),
        ),
      );
    });

    test('throws when preferences map is empty', () {
      final backup = withPreferences({});

      expect(
        () => service.validateCompleteProfile(backup),
        throwsA(
          isA<BackupIncompleteProfileException>().having(
            (e) => e.missingKeys,
            'missingKeys',
            containsAll([
              'user_name',
              'user_publisher_type',
              'user_gender',
              'user_birth_date',
            ]),
          ),
        ),
      );
    });
  });
}
