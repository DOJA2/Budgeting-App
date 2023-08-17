import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'shared_database.db'),
      onCreate: (db, version) async {
        await db.execute(
          '''
          CREATE TABLE IF NOT EXISTS income_items(
            id INTEGER PRIMARY KEY,
            duty_name TEXT,
            amount REAL
          )
          ''',
        );
      },
      version: 1,
    );
  }
}
