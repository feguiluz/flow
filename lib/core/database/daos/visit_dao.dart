import 'package:sqflite/sqflite.dart';

import '../../../shared/models/visit.dart';
import '../../utils/date_formatter.dart';

/// Data Access Object for Visit table
class VisitDao {
  const VisitDao(this.db);

  final Database db;

  // ==================== CRUD Operations ====================

  /// Insert a new visit
  Future<int> insert(Visit visit) async {
    return await db.insert(
      'visits',
      {
        'person_id': visit.personId,
        'date': DateFormatter.formatForDb(visit.date),
        'notes': visit.notes,
        'created_at': DateFormatter.formatForDb(visit.createdAt),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Update an existing visit
  Future<void> update(Visit visit) async {
    if (visit.id == null) {
      throw ArgumentError('Visit must have an ID to update');
    }

    await db.update(
      'visits',
      {
        'person_id': visit.personId,
        'date': DateFormatter.formatForDb(visit.date),
        'notes': visit.notes,
        'created_at': DateFormatter.formatForDb(visit.createdAt),
      },
      where: 'id = ?',
      whereArgs: [visit.id],
    );
  }

  /// Delete a visit
  Future<void> delete(int id) async {
    await db.delete(
      'visits',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Get a visit by ID
  Future<Visit?> getById(int id) async {
    final maps = await db.query(
      'visits',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) {
      return null;
    }

    return _mapToVisit(maps.first);
  }

  // ==================== Query Operations ====================

  /// Get all visits for a specific person
  Future<List<Visit>> getByPerson(int personId) async {
    final maps = await db.query(
      'visits',
      where: 'person_id = ?',
      whereArgs: [personId],
      orderBy: 'date DESC',
    );

    return maps.map(_mapToVisit).toList();
  }

  /// Get all visits for a specific month
  Future<List<Visit>> getByMonth(int year, int month) async {
    final monthStr = month.toString().padLeft(2, '0');
    final pattern = '$year-$monthStr-%';

    final maps = await db.query(
      'visits',
      where: 'date LIKE ?',
      whereArgs: [pattern],
      orderBy: 'date DESC',
    );

    return maps.map(_mapToVisit).toList();
  }

  /// Count Bible studies who had visits in a specific month
  /// A Bible study is counted if:
  /// - The person has is_bible_study = true
  /// - AND they had at least one visit that month
  /// Returns the count of unique people who meet this criteria
  ///
  /// Note: This method is kept for potential future use (e.g., statistics)
  /// The main monthly summary uses PersonDao.getBibleStudiesCount() instead
  Future<int> countBibleStudiesInMonth(int year, int month) async {
    final monthStr = month.toString().padLeft(2, '0');
    final pattern = '$year-$monthStr-%';

    final result = await db.rawQuery(
      '''
      SELECT COUNT(DISTINCT v.person_id) as count
      FROM visits v
      INNER JOIN people p ON v.person_id = p.id
      WHERE v.date LIKE ? AND p.is_bible_study = 1
      ''',
      [pattern],
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Get the last visit date for each person
  /// Returns a map of {personId: lastVisitDate}
  Future<Map<int, DateTime>> getLastVisitDateByPerson(
    List<int> personIds,
  ) async {
    if (personIds.isEmpty) {
      return {};
    }

    final placeholders = List.filled(personIds.length, '?').join(',');

    final maps = await db.rawQuery(
      '''
      SELECT person_id, MAX(date) as last_date
      FROM visits
      WHERE person_id IN ($placeholders)
      GROUP BY person_id
      ''',
      personIds,
    );

    final lastVisitMap = <int, DateTime>{};

    for (final row in maps) {
      final personId = row['person_id'] as int;
      final lastDate = DateFormatter.parseFromDb(row['last_date'] as String);
      lastVisitMap[personId] = lastDate;
    }

    return lastVisitMap;
  }

  /// Get visits for a date range
  Future<List<Visit>> getByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final maps = await db.query(
      'visits',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [
        DateFormatter.formatForDb(startDate),
        DateFormatter.formatForDb(endDate),
      ],
      orderBy: 'date DESC',
    );

    return maps.map(_mapToVisit).toList();
  }

  /// Get count of visits for a person
  Future<int> getVisitCountByPerson(int personId) async {
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM visits WHERE person_id = ?',
      [personId],
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  // ==================== Helper Methods ====================

  /// Map a database row to a Visit object
  Visit _mapToVisit(Map<String, dynamic> map) {
    return Visit(
      id: map['id'] as int,
      personId: map['person_id'] as int,
      date: DateFormatter.parseFromDb(map['date'] as String),
      notes: map['notes'] as String?,
      createdAt: DateFormatter.parseFromDb(map['created_at'] as String),
    );
  }
}
