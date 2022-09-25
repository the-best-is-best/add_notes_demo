import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../app/di.dart';

class SqfliteInit {
  Future initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'tasks.db');

    debugPrint('AppDatabaseInitialized');

    await _openAppDatabase(path);
  }

  Future _openAppDatabase(String path) async {
    await openDatabase(
      path,
      version: 2,
      onCreate: (Database db, int version) async {
        await db.execute(
          """CREATE TABLE notes (id INTEGER PRIMARY KEY, title TEXT , placeDateTime TEXT ,userId TEXT
              )""",
        );
        await db.execute(
          """CREATE TABLE intrests (id INTEGER PRIMARY KEY, intrestText TEXT 
              )""",
        );
        await db.execute(
          """CREATE TABLE users (id INTEGER PRIMARY KEY, username TEXT ,  password TEXT ,
          email TEXT , imageAsBase64 TEXT , intrestId TEXT
              )""",
        );

        debugPrint('Tables Created');
      },
      onOpen: (Database db) async {
        debugPrint('AppDatabaseOpened');

        di.registerFactory(() => db);
      },
    );
  }
}
