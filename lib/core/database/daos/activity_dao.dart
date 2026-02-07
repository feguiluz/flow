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
        'hours': activity.hours,
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
        'hours': activity.hours,
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

  /// Get total hours for a specific month
  Future<double> getTotalHoursByMonth(int year, int month) async {
    final monthStr = month.toString().padLeft(2, '0');
    final pattern = '$year-$monthStr-%';

    final result = await db.rawQuery(
      'SELECT SUM(hours) as total FROM activities WHERE date LIKE ?',
      [pattern],
    );

    final total = result.first['total'];
    return (total as num?)?.toDouble() ?? 0.0;
  }

  /// Get hours by month for an entire year
  /// Returns a map of {month: hours} (e.g., {1: 45.5, 2: 30.0, 3: 50.0})
  Future<Map<int, double>> getHoursByMonthForYear(int year) async {
    final result = await db.rawQuery(
      '''
      SELECT 
        CAST(strftime('%m', date) AS INTEGER) as month,
        SUM(hours) as total
      FROM activities
      WHERE date LIKE ?
      GROUP BY month
      ORDER BY month
      ''',
      ['$year-%'],
    );

    final hoursMap = <int, double>{};

    for (final row in result) {
      final month = row['month'] as int;
      final total = (row['total'] as num).toDouble();
      hoursMap[month] = total;
    }

    return hoursMap;
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
      hours: (map['hours'] as num).toDouble(),
      notes: map['notes'] as String?,
      createdAt: DateFormatter.parseFromDb(map['created_at'] as String),
    );
  }
}
