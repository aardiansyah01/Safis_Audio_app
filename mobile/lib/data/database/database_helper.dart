import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'audio_enhancer.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE history(
              id INTEGER PRIMARY KEY AUTOINCREMENT,

              originalFile TEXT NOT NULL,

              originalPath TEXT NOT NULL,

              enhancedFile TEXT NOT NULL,

              noiseReduction REAL NOT NULL,

              audioEnhancement REAL NOT NULL,

              createdAt TEXT NOT NULL
          )
        ''');
      },
    );
  }
}
