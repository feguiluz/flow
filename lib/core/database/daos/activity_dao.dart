import 'package:sqflite/sqflite.dart';

import '../../../shared/models/activity.dart';
import '../../utils/date_formatter.dart';

/// Data Access Object for Activity table
class ActivityDao {
  const ActivityDao(this.db);

  final Database db;

  // ==================== CRUD Operations ====================

  /// Insert a new activity
  Future<int> insert(Activity activity) async {
    return await db.insert(
      'activities',
      {
        'date': DateFormatter.formatForDb(activity.date),
        'minutes': activity.minutes,
        'notes': activity.notes,
        'created_at': DateFormatter.formatForDb(activity.createdAt),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Update an existing activity
  Future<void> update(Activity activity) async {
    if (activity.id == null) {
      throw ArgumentError('Activity must have an ID to update');
    }

    await db.update(
      'activities',
      {
        'date': DateFormatter.formatForDb(activity.date),
        'minutes': activity.minutes,
        'notes': activity.notes,
        'created_at': DateFormatter.formatForDb(activity.createdAt),
      },
      where: 'id = ?',
      whereArgs: [activity.id],
    );
  }

  /// Delete an activity
  Future<void> delete(int id) async {
    await db.delete(
      'activities',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Get an activity by ID
  Future<Activity?> getById(int id) async {
    final maps = await db.query(
      'activities',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) {
      return null;
    }

    return _mapToActivity(maps.first);
  }

  // ==================== Query Operations ====================

  /// Get all activities for a specific month
  Future<List<Activity>> getByMonth(int year, int month) async {
    final monthStr = month.toString().padLeft(2, '0');
    final pattern = '$year-$monthStr-%';

    final maps = await db.query(
      'activities',
      where: 'date LIKE ?',
      whereArgs: [pattern],
      orderBy: 'date DESC',
    );

    return maps.map(_mapToActivity).toList();
  }

  /// Get recent activities (for display in home screen)
  Future<List<Activity>> getRecent({int limit = 10}) async {
    final maps = await db.query(
      'activities',
      orderBy: 'date DESC, created_at DESC',
      limit: limit,
    );

    return maps.map(_mapToActivity).toList();
  }

  /// Get total minutes for a specific month
  Future<int> getTotalMinutesByMonth(int year, int month) async {
    final monthStr = month.toString().padLeft(2, '0');
    final pattern = '$year-$monthStr-%';

    final result = await db.rawQuery(
      'SELECT SUM(minutes) as total FROM activities WHERE date LIKE ?',
      [pattern],
    );

    final total = result.first['total'];
    return (total as num?)?.toInt() ?? 0;
  }

  /// Get minutes by month for an entire year
  /// Returns a map of {month: minutes} (e.g., {1: 2730, 2: 1800, 3: 3000})
  Future<Map<int, int>> getMinutesByMonthForYear(int year) async {
    final result = await db.rawQuery(
      '''
      SELECT 
        CAST(strftime('%m', date) AS INTEGER) as month,
        SUM(minutes) as total
      FROM activities
      WHERE date LIKE ?
      GROUP BY month
      ORDER BY month
      ''',
      ['$year-%'],
    );

    final minutesMap = <int, int>{};

    for (final row in result) {
      final month = row['month'] as int;
      final total = (row['total'] as num).toInt();
      minutesMap[month] = total;
    }

    return minutesMap;
  }

  /// Get all activities for a date range
  Future<List<Activity>> getByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final maps = await db.query(
      'activities',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [
        DateFormatter.formatForDb(startDate),
        DateFormatter.formatForDb(endDate),
      ],
      orderBy: 'date DESC',
    );

    return maps.map(_mapToActivity).toList();
  }

  // ==================== Helper Methods ====================

  /// Map a database row to an Activity object
  Activity _mapToActivity(Map<String, dynamic> map) {
    return Activity(
      id: map['id'] as int,
      date: DateFormatter.parseFromDb(map['date'] as String),
      minutes: (map['minutes'] as num).toInt(),
      notes: map['notes'] as String?,
      createdAt: DateFormatter.parseFromDb(map['created_at'] as String),
    );
  }
}
