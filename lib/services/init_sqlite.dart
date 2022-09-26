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
          """CREATE TABLE notes (id INTEGER PRIMARY KEY, text TEXT , placeDateTime TEXT ,userId TEXT
              )""",
        );
        await db.execute(
          """CREATE TABLE intrests (id INTEGER PRIMARY KEY, intrestText TEXT 
              )""",
        );

        // dummy data note
        await db.execute(
          """CREATE TABLE users (id INTEGER PRIMARY KEY, username TEXT ,  password TEXT ,
          email TEXT , imageAsBase64 TEXT , intrestId TEXT
              )""",
        );
        await db.execute("""INSERT INTO notes(text, userId, placeDateTime) 
        VALUES("World War II or the Second World War, often abbreviated as WWII or WW2, was a global war that lasted...",
         "1" , "2022-09-26T09:37:45.8363259+00:00"), 
       
        ("C# is a general-purpose, modern and object-oriented programming language pronounced as “C sharp”. It...",
         "2" , "2022-09-26T09:37:45.8374881+00:00") ,
        
         ("Test Note",
         "3" , "2022-09-26T09:37:45.837491+00:00"
         )""");

        // dummy data users
        await db.execute(
            """INSERT INTO users(username, password, email , imageAsBase64 , intrestId) 
        VALUES( "Mohammed" , "moha21212313" , "mmm@gmail.com" ,"" , "2"), 
       
       ( "Hassan" , "113231242412" , "abds@gmail.com" ,"" , "1"),
      
       ( "Abdulla" , "hanso1l2031sa" , "husaann21@gmail.com"
        ,"null"
        , "2")""");
        // dummy data intrests
        await db.execute("""INSERT INTO intrests(intrestText) 
        VALUES( "Swimming"), 
       
       ( "Football"),
      
       ( "Programming")""");
        debugPrint('Tables Created');
      },
      onOpen: (Database db) async {
        debugPrint('AppDatabaseOpened');

        di.registerFactory(() => db);
      },
    );
  }
}
