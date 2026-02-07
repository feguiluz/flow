import 'package:sqflite/sqflite.dart';

import '../../../shared/models/goal.dart';
import '../../utils/date_formatter.dart';

/// Data Access Object for Goal table
class GoalDao {
  const GoalDao(this.db);

  final Database db;

  // ==================== CRUD Operations ====================

  /// Insert or update a goal (UPSERT)
  /// Only one goal per month is allowed (enforced by UNIQUE constraint)
  Future<int> insertOrUpdate(Goal goal) async {
    // Try to get existing goal for this month
    final existing = await getByMonth(goal.year, goal.month);

    if (existing != null) {
      // Update existing goal
      await db.update(
        'goals',
        {
          'goal_type': goal.goalType.name,
          'target_hours': goal.targetHours,
          'created_at': DateFormatter.formatForDb(goal.createdAt),
        },
        where: 'year = ? AND month = ?',
        whereArgs: [goal.year, goal.month],
      );
      return existing.id!;
    } else {
      // Insert new goal
      return await db.insert(
        'goals',
        {
          'year': goal.year,
          'month': goal.month,
          'goal_type': goal.goalType.name,
          'target_hours': goal.targetHours,
          'created_at': DateFormatter.formatForDb(goal.createdAt),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  /// Delete a goal for a specific month
  Future<void> delete(int year, int month) async {
    await db.delete(
      'goals',
      where: 'year = ? AND month = ?',
      whereArgs: [year, month],
    );
  }

  /// Get a goal by ID
  Future<Goal?> getById(int id) async {
    final maps = await db.query(
      'goals',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) {
      return null;
    }

    return _mapToGoal(maps.first);
  }

  // ==================== Query Operations ====================

  /// Get goal for a specific month
  Future<Goal?> getByMonth(int year, int month) async {
    final maps = await db.query(
      'goals',
      where: 'year = ? AND month = ?',
      whereArgs: [year, month],
      limit: 1,
    );

    if (maps.isEmpty) {
      return null;
    }

    return _mapToGoal(maps.first);
  }

  /// Get all goals for a specific year
  Future<List<Goal>> getByYear(int year) async {
    final maps = await db.query(
      'goals',
      where: 'year = ?',
      whereArgs: [year],
      orderBy: 'month ASC',
    );

    return maps.map(_mapToGoal).toList();
  }

  /// Get count of each goal type for a year
  /// Returns a map like {'auxiliaryPioneer30': 8, 'regularPioneer': 4}
  Future<Map<String, int>> getGoalTypeCountByYear(int year) async {
    final result = await db.rawQuery(
      '''
      SELECT goal_type, COUNT(*) as count
      FROM goals
      WHERE year = ?
      GROUP BY goal_type
      ''',
      [year],
    );

    final countMap = <String, int>{};

    for (final row in result) {
      final goalType = row['goal_type'] as String;
      final count = row['count'] as int;
      countMap[goalType] = count;
    }

    return countMap;
  }

  /// Get all goals (for debugging/export purposes)
  Future<List<Goal>> getAll() async {
    final maps = await db.query(
      'goals',
      orderBy: 'year DESC, month DESC',
    );

    return maps.map(_mapToGoal).toList();
  }

  /// Get count of months with goals set for a year
  Future<int> getMonthsWithGoalsCount(int year) async {
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM goals WHERE year = ?',
      [year],
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  // ==================== Helper Methods ====================

  /// Map a database row to a Goal object
  Goal _mapToGoal(Map<String, dynamic> map) {
    // Parse goal type from string
    final goalTypeStr = map['goal_type'] as String;
    final goalType = GoalType.values.firstWhere(
      (e) => e.name == goalTypeStr,
      orElse: () => GoalType.publisher,
    );

    return Goal(
      id: map['id'] as int,
      year: map['year'] as int,
      month: map['month'] as int,
      goalType: goalType,
      targetHours: (map['target_hours'] as num?)?.toDouble(),
      createdAt: DateFormatter.parseFromDb(map['created_at'] as String),
    );
  }
}
