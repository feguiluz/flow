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
Future<ActivityDao> activityDao(ActivityDaoRef ref) async {
  final db = await ref.watch(databaseProvider.future);
  return ActivityDao(db);
}

/// Provider for PersonDao
@riverpod
Future<PersonDao> personDao(PersonDaoRef ref) async {
  final db = await ref.watch(databaseProvider.future);
  return PersonDao(db);
}

/// Provider for VisitDao
@riverpod
Future<VisitDao> visitDao(VisitDaoRef ref) async {
  final db = await ref.watch(databaseProvider.future);
  return VisitDao(db);
}

/// Provider for GoalDao
@riverpod
Future<GoalDao> goalDao(GoalDaoRef ref) async {
  final db = await ref.watch(databaseProvider.future);
  return GoalDao(db);
}
