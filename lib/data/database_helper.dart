import 'dart:async';

import 'package:flutter_myopia_ai/data/custom_type.dart';
import 'package:path/path.dart';
import 'activity_item.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  final String tableActivity = 'ActivityTable';
  final String tableCustomTypeDic = 'CustomTypeDic';

  final String columnId = 'id';
  final String type = 'type';
  final String customType = 'custom_type';
  final String target = 'target';
  final String actual = 'actual';
  final String time = 'time';

  final String customTypeId = 'id';
  final String customTypeText = 'type_text';

  static Database _db;

  DatabaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();

    return _db;
  }

  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'myopia.db');

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tableActivity($columnId INTEGER PRIMARY KEY, '
        '$type INTEGER, $customType INTEGER, $target INTEGER, $actual INTEGER, $time INTEGER)');
    await db.execute(
        'CREATE TABLE $tableCustomTypeDic($customTypeId INTEGER PRIMARY KEY, $customTypeText TEXT)');
  }

  Future<int> insertActivity(ActivityItem activity) async {
    var dbClient = await db;
    var result = await dbClient.insert(tableActivity, activity.toJson());
    return result;
  }

  Future<int> insertCustomType(CustomType customType) async {
    var dbClient = await db;
    var result = await dbClient.insert(tableCustomTypeDic, customType.toJson());
    return result;
  }

  Future<List> selectActivities({int limit, int offset}) async {
    var dbClient = await db;
    var result = await dbClient.query(
      tableActivity,
      columns: [columnId, type, customType, target, actual, time],
      limit: limit,
      offset: offset,
    );
    List<ActivityItem> activities = [];
    result.forEach((item) => activities.add(ActivityItem.fromSql(item)));
    return activities;
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery('SELECT COUNT(*) FROM $tableActivity'));
  }

  Future<int> getCustomTypeCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery('SELECT COUNT(*) FROM $tableCustomTypeDic'));
  }

  Future<CustomType> getCustomType(String text) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query(tableCustomTypeDic,
        columns: [customTypeId, customTypeText],
        where: '$customTypeText = ?',
        whereArgs: [text]);

    if (result.length > 0) {
      return CustomType.fromSql(result.first);
    }

    return null;
  }

  Future<ActivityItem> getActivity(int id) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query(tableActivity,
        columns: [columnId, type, customType, target, actual, time],
        where: '$columnId = ?',
        whereArgs: [id]);

    if (result.length > 0) {
      return ActivityItem.fromSql(result.first);
    }

    return null;
  }

//
//  Future<int> deleteNote(String images) async {
//    var dbClient = await db;
//    return await dbClient
//        .delete(tableActivity, where: '$image = ?', whereArgs: [images]);
//  }
//
  Future<int> updateActivity(ActivityItem item) async {
    var dbClient = await db;
    return await dbClient.update(tableActivity, item.toJson(),
        where: "$columnId = ?", whereArgs: [item.id]);
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
