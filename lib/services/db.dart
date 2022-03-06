import 'dart:io';
import 'dart:async';
import 'package:tracenow/models/info.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = 'encounter_history.db';
  static const _databaseVersion = 1;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE EncounterHistory (
                uuid TEXT,
                date DATETIME,
                duration INTEGER,
                PRIMARY KEY(uuid,date)
              )
              ''');
  }

  // Database helper methods:

  Future<int> insert(Info info) async {
    Database? db = await database;
    int id = await db!.insert('EncounterHistory', info.toMap());
    return id;
  }

  Future<int> update(Info info) async {
    Database? db = await database;
    return await db!.update(
      'EncounterHistory',
      info.toMap(),
      where: 'uuid = ? AND date = ? ',
      whereArgs: [info.uuid, info.date],
    );
  }

  Future<int> deleteAll() async {
    Database? db = await database;
    return await db!.delete('EncounterHistory');
  }

  Future<List<Info>> queryUser(String id, String date) async {
    Database? db = await database;
    List<Map> maps =
        await db!.query('EncounterHistory', where: 'uuid = ? AND date = ? ', whereArgs: [id, date]);

    return List.generate(maps.length, (i) {
      return Info(
        uuid: maps[i]['uuid'],
        duration: maps[i]['duration'],
        date: maps[i]['date'],
      );
    });
  }

  Future<List<Info>> getAll() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all the encounter history.
    final List<Map<String, dynamic>> maps = await db!.query('EncounterHistory');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Info(
        uuid: maps[i]['uuid'],
        duration: maps[i]['duration'],
        date: maps[i]['date'],
      );
    });
  }

  Future<List<Info>> filterDate() async {
    final db = await database;

    const String sql =
        "SELECT * FROM EncounterHistory WHERE EncounterHistory.date <= date('now','-14 day')";

    final List<Map<String, dynamic>> maps = await db!.rawQuery(sql);

    return List.generate(maps.length, (i) {
      return Info(
        uuid: maps[i]['uuid'],
        duration: maps[i]['duration'],
        date: maps[i]['date'],
      );
    });
  }

  Future<int> deleteOldData() async {
    final db = await database;
    const String sql =
        "DELETE FROM EncounterHistory WHERE EncounterHistory.date <= date('now','-14 day')";

    return await db!.rawDelete(sql);
  }

  Future<List<Info>> getAllCompiled() async {
    final db = await database;
    const String sql =
        "SELECT EncounterHistory.uuid, EncounterHistory.date, SUM(EncounterHistory.duration) as duration FROM EncounterHistory GROUP BY EncounterHistory.uuid";

    final List<Map<String, dynamic>> maps = await db!.rawQuery(sql);

    return List.generate(maps.length, (i) {
      return Info(
        uuid: maps[i]['uuid'],
        duration: maps[i]['duration'],
        date: maps[i]['date'],
      );
    });

    // return List.generate(maps.length, (i) {
    //   return Info(
    //     uuid: maps[i]['uuid'],
    //     duration: maps[i]['duration'],
    //     date: maps[i]['date'],
    //   );
    // });
  }
}
