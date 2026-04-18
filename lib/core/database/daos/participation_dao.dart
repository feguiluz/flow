import 'package:sqflite/sqflite.dart';

import '../../../shared/models/participation.dart';
import '../../utils/date_formatter.dart';

/// Data Access Object for Participation table
/// Manages monthly participation checkbox for publishers without goals
class ParticipationDao {
  const ParticipationDao(this.db);

  final Database db;

  // ==================== CRUD Operations ====================

  /// Insert or update participation (UPSERT)
  /// Only one participation record per month is allowed (UNIQUE constraint)
  Future<int> insertOrUpdate(Participation participation) async {
    // Try to get existing participation for this month
    final existing = await getByMonth(participation.year, participation.month);

    if (existing != null) {
      // Update existing participation
      await db.update(
        'participations',
        {
          'participated': participation.participated ? 1 : 0,
          'created_at': DateFormatter.formatForDb(participation.createdAt),
        },
        where: 'year = ? AND month = ?',
        whereArgs: [participation.year, participation.month],
      );
      return existing.id!;
    } else {
      // Insert new participation
      return await db.insert(
        'participations',
        {
          'year': participation.year,
          'month': participation.month,
          'participated': participation.participated ? 1 : 0,
          'created_at': DateFormatter.formatForDb(participation.createdAt),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  /// Delete participation for a specific month
  Future<void> delete(int year, int month) async {
    await db.delete(
      'participations',
      where: 'year = ? AND month = ?',
      whereArgs: [year, month],
    );
  }

  /// Get participation by ID
  Future<Participation?> getById(int id) async {
    final maps = await db.query(
      'participations',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) {
      return null;
    }

    return _mapToParticipation(maps.first);
  }

  // ==================== Query Operations ====================

  /// Get participation for a specific month
  Future<Participation?> getByMonth(int year, int month) async {
    final maps = await db.query(
      'participations',
      where: 'year = ? AND month = ?',
      whereArgs: [year, month],
      limit: 1,
    );

    if (maps.isEmpty) {
      return null;
    }

    return _mapToParticipation(maps.first);
  }

  /// Get all participations for a specific year
  Future<List<Participation>> getByYear(int year) async {
    final maps = await db.query(
      'participations',
      where: 'year = ?',
      whereArgs: [year],
      orderBy: 'month ASC',
    );

    return maps.map(_mapToParticipation).toList();
  }

  /// Count months where user participated in a specific year
  Future<int> countParticipatedMonths(int year) async {
    final result = await db.rawQuery(
      '''
      SELECT COUNT(*) as count 
      FROM participations 
      WHERE year = ? AND participated = 1
      ''',
      [year],
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Get all participations (for debugging/export purposes)
  Future<List<Participation>> getAll() async {
    final maps = await db.query(
      'participations',
      orderBy: 'year DESC, month DESC',
    );

    return maps.map(_mapToParticipation).toList();
  }

  // ==================== Helper Methods ====================

  /// Map a database row to a Participation object
  Participation _mapToParticipation(Map<String, dynamic> map) {
    return Participation(
      id: map['id'] as int,
      year: map['year'] as int,
      month: map['month'] as int,
      participated: (map['participated'] as int) == 1,
      createdAt: DateFormatter.parseFromDb(map['created_at'] as String),
    );
  }
}
