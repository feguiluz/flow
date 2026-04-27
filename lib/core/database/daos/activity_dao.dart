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

  /// Get total minutes for a specific date (excluding a specific activity ID)
  /// Used to validate that total minutes per day doesn't exceed 24 hours
  Future<int> getTotalMinutesForDate(DateTime date,
      {int? excludeActivityId}) async {
    final dateStr = DateFormatter.formatForDb(date);

    String query =
        'SELECT SUM(minutes) as total FROM activities WHERE date = ?';
    List<dynamic> args = [dateStr];

    if (excludeActivityId != null) {
      query += ' AND id != ?';
      args.add(excludeActivityId);
    }

    final result = await db.rawQuery(query, args);
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

  /// Get total minutes per day for a specific month.
  /// Returns a map of {day-of-month: minutes}. Days without activity are
  /// omitted, so a missing key means zero minutes that day.
  Future<Map<int, int>> getMinutesByDayForMonth(int year, int month) async {
    final monthStr = month.toString().padLeft(2, '0');
    final result = await db.rawQuery(
      '''
      SELECT
        CAST(strftime('%d', date) AS INTEGER) as day,
        SUM(minutes) as total
      FROM activities
      WHERE date LIKE ?
      GROUP BY day
      ''',
      ['$year-$monthStr-%'],
    );

    final byDay = <int, int>{};
    for (final row in result) {
      byDay[row['day'] as int] = (row['total'] as num).toInt();
    }
    return byDay;
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

  /// Get total minutes for a service year (Sep - Aug)
  /// startYear = 2025 means Sep 2025 - Aug 2026
  Future<int> getTotalMinutesForServiceYear(int startYear) async {
    final endYear = startYear + 1;

    final result = await db.rawQuery(
      '''
      SELECT SUM(minutes) as total 
      FROM activities 
      WHERE date >= ? AND date <= ?
      ''',
      [
        '$startYear-09-01', // September 1st of start year
        '$endYear-08-31', // August 31st of end year
      ],
    );

    return (result.first['total'] as num?)?.toInt() ?? 0;
  }

  /// Get total minutes for a service year UP TO a specific date
  /// Used for showing accumulated progress
  /// Example: startYear=2025, upToDate=DateTime(2026,1,31)
  ///          → Sep 2025 to Jan 2026
  Future<int> getTotalMinutesForServiceYearUpTo(
    int startYear,
    DateTime upToDate,
  ) async {
    final startDate = '$startYear-09-01';
    final endDate = DateFormatter.formatForDb(upToDate);

    final result = await db.rawQuery(
      '''
      SELECT SUM(minutes) as total 
      FROM activities 
      WHERE date >= ? AND date <= ?
      ''',
      [startDate, endDate],
    );

    return (result.first['total'] as num?)?.toInt() ?? 0;
  }

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
