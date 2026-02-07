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
    _database = await _initDB('flow.db');
    return _database!;
  }

  /// Initialize database with schema
  Future<Database> _initDB(String filePath) async {
    String path;

    if (kIsWeb) {
      // For web, use a simple database name (stored in IndexedDB)
      path = filePath;
    } else {
      // For mobile/desktop, use the standard databases path
      final dbPath = await getDatabasesPath();
      path = join(dbPath, filePath);
    }

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onConfigure: _onConfigure,
    );
  }

  /// Configure database settings
  Future<void> _onConfigure(Database db) async {
    // Enable foreign keys
    await db.execute('PRAGMA foreign_keys = ON');
  }

  /// Create database schema
  Future<void> _createDB(Database db, int version) async {
    // Activities table - stores daily ministry hours
    await db.execute('''
      CREATE TABLE activities (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        hours REAL NOT NULL,
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
