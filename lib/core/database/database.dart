import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Local database for Flow app using sqflite.
///
/// Provides offline-first data storage for ministry activity tracking.
/// Current schema version: 1
class AppDatabase {
  AppDatabase._init();

  static const int kDatabaseVersion = 6;
  static const List<String> kTableNames = [
    'activities',
    'people',
    'visits',
    'goals',
    'participations',
    'events',
  ];

  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  /// Get database instance, creating it if it doesn't exist
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(kIsWeb ? 'flow_app.db' : 'flow.db');
    return _database!;
  }

  /// Initialize database with schema
  Future<Database> _initDB(String filePath) async {
    String path;

    if (kIsWeb) {
      // For web, use a simple database name (stored in IndexedDB)
      path = filePath;
      // ignore: avoid_print
      print('📦 Opening database for web: $path');
    } else {
      // For mobile/desktop, use the standard databases path
      final dbPath = await getDatabasesPath();
      path = join(dbPath, filePath);
      // ignore: avoid_print
      print('📦 Opening database at: $path');
    }

    final db = await openDatabase(
      path,
      version: kDatabaseVersion,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
      onConfigure: _onConfigure,
    );

    // ignore: avoid_print
    print('✅ Database opened successfully');
    return db;
  }

  /// Configure database settings
  Future<void> _onConfigure(Database db) async {
    // Enable foreign keys
    await db.execute('PRAGMA foreign_keys = ON');
  }

  /// Upgrade database schema
  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    // ignore: avoid_print
    print('📦 Migrating database from v$oldVersion to v$newVersion');

    if (oldVersion < 2) {
      // Migration from version 1 to 2: Change hours (REAL) to minutes (INTEGER)
      // 1. Create new table with minutes
      await db.execute('''
        CREATE TABLE activities_new (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          date TEXT NOT NULL,
          minutes INTEGER NOT NULL,
          notes TEXT,
          created_at TEXT NOT NULL
        )
      ''');

      // 2. Copy data, converting hours to minutes
      await db.execute('''
        INSERT INTO activities_new (id, date, minutes, notes, created_at)
        SELECT id, date, CAST(hours * 60 AS INTEGER), notes, created_at
        FROM activities
      ''');

      // 3. Drop old table
      await db.execute('DROP TABLE activities');

      // 4. Rename new table
      await db.execute('ALTER TABLE activities_new RENAME TO activities');

      // ignore: avoid_print
      print('✅ Migration to v2 completed');
    }

    if (oldVersion < 3) {
      // Migration from version 2 to 3: Remove counted_as_study from visits
      // 1. Create new visits table without counted_as_study
      await db.execute('''
        CREATE TABLE visits_new (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          person_id INTEGER NOT NULL,
          date TEXT NOT NULL,
          notes TEXT,
          created_at TEXT NOT NULL,
          FOREIGN KEY (person_id) REFERENCES people (id) ON DELETE CASCADE
        )
      ''');

      // 2. Copy data (all visits, regardless of counted_as_study value)
      await db.execute('''
        INSERT INTO visits_new (id, person_id, date, notes, created_at)
        SELECT id, person_id, date, notes, created_at
        FROM visits
      ''');

      // 3. Drop old table
      await db.execute('DROP TABLE visits');

      // 4. Rename new table
      await db.execute('ALTER TABLE visits_new RENAME TO visits');

      // 5. Recreate indexes
      await db.execute('CREATE INDEX idx_visits_person ON visits(person_id)');
      await db.execute('CREATE INDEX idx_visits_date ON visits(date)');

      // ignore: avoid_print
      print('✅ Migration to v3 completed');
    }

    if (oldVersion < 4) {
      // Migration from version 3 to 4: Add location fields to people
      // SQLite doesn't support multiple ADD COLUMN in one statement
      await db.execute('ALTER TABLE people ADD COLUMN latitude REAL');
      await db.execute('ALTER TABLE people ADD COLUMN longitude REAL');

      // ignore: avoid_print
      print('✅ Migration to v4 completed');
    }

    if (oldVersion < 5) {
      // Migration from version 4 to 5: Add participations table
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

      await db.execute(
        'CREATE INDEX idx_participations_year_month ON participations(year, month)',
      );

      // ignore: avoid_print
      print('✅ Migration to v5 completed');
    }

    if (oldVersion < 6) {
      // Migration from version 5 to 6: Add events table for the calendar
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

      // ignore: avoid_print
      print('✅ Migration to v6 completed');
    }

    // ignore: avoid_print
    print('✅ All migrations completed successfully');
  }

  /// Create database schema
  Future<void> _createDB(Database db, int version) async {
    // Activities table - stores daily ministry hours (now in minutes)
    await db.execute('''
      CREATE TABLE activities (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        minutes INTEGER NOT NULL,
        notes TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    // People table - stores interested persons
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

    // Visits table - stores return visits to interested persons
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

    // Goals table - stores monthly service goals
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

    // Participations table - stores monthly participation for publishers
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

    // Events table - calendar events linked to a person, optionally recurring
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

    // Create indexes for better query performance
    await db.execute('CREATE INDEX idx_activities_date ON activities(date)');
    await db.execute('CREATE INDEX idx_visits_person ON visits(person_id)');
    await db.execute('CREATE INDEX idx_visits_date ON visits(date)');
    await db.execute('CREATE INDEX idx_goals_year_month ON goals(year, month)');
    await db.execute(
      'CREATE INDEX idx_participations_year_month ON participations(year, month)',
    );
    await db.execute('CREATE INDEX idx_events_date ON events(date)');
    await db.execute('CREATE INDEX idx_events_person ON events(person_id)');
    await db.execute('CREATE INDEX idx_events_series ON events(series_id)');
  }

  /// Close database connection
  Future<void> close() async {
    final db = await instance.database;
    await db.close();
    _database = null;
  }

  /// Delete all rows from all application tables within a single transaction.
  /// Leaves the schema intact. Used before restoring a backup.
  Future<void> deleteAllData() async {
    final db = await database;
    await db.transaction((txn) async {
      for (final table in kTableNames) {
        await txn.delete(table);
      }
    });
  }
}
