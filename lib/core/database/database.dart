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
      version: 2, // Incremented for migration to minutes
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
    if (oldVersion < 2) {
      // Migration from version 1 to 2: Change hours (REAL) to minutes (INTEGER)
      // ignore: avoid_print
      print('📦 Migrating database from v$oldVersion to v$newVersion');

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
      print('✅ Migration completed successfully');
    }
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
        counted_as_study INTEGER NOT NULL DEFAULT 0,
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

    // Create indexes for better query performance
    await db.execute('CREATE INDEX idx_activities_date ON activities(date)');
    await db.execute('CREATE INDEX idx_visits_person ON visits(person_id)');
    await db.execute('CREATE INDEX idx_visits_date ON visits(date)');
    await db.execute('CREATE INDEX idx_goals_year_month ON goals(year, month)');
  }

  /// Close database connection
  Future<void> close() async {
    final db = await instance.database;
    await db.close();
    _database = null;
  }
}
