import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

import '../../core/database/daos/activity_dao.dart';
import '../../core/database/daos/goal_dao.dart';
import '../../core/database/daos/person_dao.dart';
import '../../core/database/daos/visit_dao.dart';
import '../../core/database/database.dart';

part 'database_provider.g.dart';

/// Provider for the database instance
@riverpod
Future<Database> database(DatabaseRef ref) async {
  return await AppDatabase.instance.database;
}

/// Provider for ActivityDao
@riverpod
ActivityDao activityDao(ActivityDaoRef ref) {
  final db = ref.watch(databaseProvider).value;
  if (db == null) {
    throw StateError('Database not initialized');
  }
  return ActivityDao(db);
}

/// Provider for PersonDao
@riverpod
PersonDao personDao(PersonDaoRef ref) {
  final db = ref.watch(databaseProvider).value;
  if (db == null) {
    throw StateError('Database not initialized');
  }
  return PersonDao(db);
}

/// Provider for VisitDao
@riverpod
VisitDao visitDao(VisitDaoRef ref) {
  final db = ref.watch(databaseProvider).value;
  if (db == null) {
    throw StateError('Database not initialized');
  }
  return VisitDao(db);
}

/// Provider for GoalDao
@riverpod
GoalDao goalDao(GoalDaoRef ref) {
  final db = ref.watch(databaseProvider).value;
  if (db == null) {
    throw StateError('Database not initialized');
  }
  return GoalDao(db);
}
