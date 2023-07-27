import 'package:hourock_flutter/models/favorite.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:hourock_flutter/consts/db.dart';
import 'package:flutter_test/flutter_test.dart';

class FavoriteDb {
  static Future<Database> openDb() async {
    return await openDatabase(
      join(await getDatabasesPath(), favFileName),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE $favTableName(id VARCHAR PRIMARY KEY)',
        );
      },
      version: 1,
    );
  }

  static Future<void> create(Favorite fav) async {
    var db = await openDb();
    await db.insert(
      favTableName,
      fav.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Favorite>> read() async {
    var db = await openDb();
    final List<Map<String, dynamic>> maps = await db.query(favTableName);
    return List.generate(maps.length, (index) {
      return Favorite(
        rockId: maps[index]['id'],
      );
    });
  }

  static Future<void> update(Favorite fav) async {
    var db = await openDb();
    await db.update(
      favTableName,
      fav.toMap(),
      where: 'id = ?',
      whereArgs: [fav.rockId],
    );
    db.close();
  }

  static Future<void> delete(String rockId) async {
    var db = await openDb();
    await db.delete(
      favTableName,
      where: 'id = ?',
      whereArgs: [rockId],
    );
  }
}
