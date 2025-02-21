import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? db;
  static Future<void> createDB() async {
    if (db != null) return;

    try {
      String path = '${await getDatabasesPath()}/notes.db';
      db = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE notes (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              Title TEXT,
              Note TEXT,
              isFavorite INTEGER DEFAULT 0,
              isArchived INTEGER DEFAULT 0
            )
          ''');
        },
      );

      // Ensure isFavorite column exists in case the table was created before
    } catch (e) {
      print("Database creation error: $e");
    }
  }

  static Future<void> insertToDB(String title, String note) async {
    try {
      await db?.insert("notes", {"title": title, "Note": note});
    }
    catch (e) {
      print("insert error: $e");
    }
  }

  static Future<List<Map<String, dynamic>>?> getDataFromDB() async {
    try {
      return await db?.query("notes",
          where: 'isArchived= ?',
          whereArgs: [0]
      );
    } catch (e) {
      print("Fetch error: $e");
      return null;
    }
  }

  static Future<void> addFavoriteColumnIfNoteExists() async {
    try {
      await db?.execute(
          "ALTER TABLE notes ADD COLUMN isFavorite INTEGER DEFAULT 0");
    }
    catch (e) {
      print("Error adding is Favorite column: $e");
    }
  }

  static Future<void> updateeFavoriteStatus(int id , int isFavorite) async {
    try {
      await db?.update(
        "notes",
        {"isFavorite": isFavorite},
        where: "id = ?",
        whereArgs: [id],
      );
    }
    catch (e) {
      print("Error adding is Favorite column: $e");
    }
  }

  static Future<List<Map<String, dynamic>>?> getFavoriteNotes() async {
    try {
      return await db?.query("notes", where: "isFavorite = ?", whereArgs: [1]);
    } catch (e) {
      print("Error fetching favorite notes: $e");
      return null;
    }
  }
  static Future<void> deleteDB(int id) async {
    await db?.delete("notes",

      where: "id = ?",
      whereArgs: [id],
    );
  }
  static Future<void> addArchivedColumnIfNotExists() async {
    try {
      await db?.execute(
          "ALTER TABLE notes ADD COLUMN isArchived INTEGER DEFAULT 0");
    } catch (e) {
      print("Error adding isArchived column:$e");
    }
  }
  static Future<void> updateArchivedStatus(int id, int isArchived) async {
    try {
      await db?.update(
        "notes",
        {"isArchived": isArchived},
        where: "id = ?",
        whereArgs: [id],
      );
    } catch (e) {
      print("Update archived status error$e");
    }
  }
  static Future<List<Map<String, dynamic>>?> getArchivedNotes() async {
    try {
      return await db?.query("notes", where: "isArchived = ?", whereArgs: [1]);
    } catch (e) {
      print("Error fetching archived notes: $e");
      return null;
    }
  }

  static Future<void> updateDB(int id,String text,String note) async {
    await db?.update("notes",
      {"Title" : text, "Note" : note},
      where: "id = ?",
      whereArgs: [id],
    );
  }






}