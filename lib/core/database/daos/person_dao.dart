import 'package:sqflite/sqflite.dart';

import '../../../shared/models/person.dart';
import '../../utils/date_formatter.dart';

/// Data Access Object for Person table
class PersonDao {
  const PersonDao(this.db);

  final Database db;

  // ==================== CRUD Operations ====================

  /// Insert a new person
  Future<int> insert(Person person) async {
    return await db.insert(
      'people',
      {
        'name': person.name,
        'phone': person.phone,
        'address': person.address,
        'notes': person.notes,
        'is_bible_study': person.isBibleStudy ? 1 : 0,
        'created_at': DateFormatter.formatForDb(person.createdAt),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Update an existing person
  Future<void> update(Person person) async {
    if (person.id == null) {
      throw ArgumentError('Person must have an ID to update');
    }

    await db.update(
      'people',
      {
        'name': person.name,
        'phone': person.phone,
        'address': person.address,
        'notes': person.notes,
        'is_bible_study': person.isBibleStudy ? 1 : 0,
        'created_at': DateFormatter.formatForDb(person.createdAt),
      },
      where: 'id = ?',
      whereArgs: [person.id],
    );
  }

  /// Delete a person (and all their visits due to CASCADE)
  Future<void> delete(int id) async {
    await db.delete(
      'people',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Get a person by ID
  Future<Person?> getById(int id) async {
    final maps = await db.query(
      'people',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) {
      return null;
    }

    return _mapToPerson(maps.first);
  }

  // ==================== Query Operations ====================

  /// Get all people
  Future<List<Person>> getAll() async {
    final maps = await db.query(
      'people',
      orderBy: 'name ASC',
    );

    return maps.map(_mapToPerson).toList();
  }

  /// Get all people marked as Bible studies
  Future<List<Person>> getBibleStudies() async {
    final maps = await db.query(
      'people',
      where: 'is_bible_study = ?',
      whereArgs: [1],
      orderBy: 'name ASC',
    );

    return maps.map(_mapToPerson).toList();
  }

  /// Get all interested persons (not marked as Bible studies)
  Future<List<Person>> getInterestedPersons() async {
    final maps = await db.query(
      'people',
      where: 'is_bible_study = ?',
      whereArgs: [0],
      orderBy: 'name ASC',
    );

    return maps.map(_mapToPerson).toList();
  }

  /// Search people by name (case-insensitive)
  Future<List<Person>> search(String query) async {
    final maps = await db.query(
      'people',
      where: 'LOWER(name) LIKE ?',
      whereArgs: ['%${query.toLowerCase()}%'],
      orderBy: 'name ASC',
    );

    return maps.map(_mapToPerson).toList();
  }

  /// Get count of Bible studies
  Future<int> getBibleStudiesCount() async {
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM people WHERE is_bible_study = 1',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Get count of interested persons
  Future<int> getInterestedPersonsCount() async {
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM people WHERE is_bible_study = 0',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  // ==================== Helper Methods ====================

  /// Map a database row to a Person object
  Person _mapToPerson(Map<String, dynamic> map) {
    return Person(
      id: map['id'] as int,
      name: map['name'] as String,
      phone: map['phone'] as String?,
      address: map['address'] as String?,
      notes: map['notes'] as String?,
      isBibleStudy: (map['is_bible_study'] as int) == 1,
      createdAt: DateFormatter.parseFromDb(map['created_at'] as String),
    );
  }
}
