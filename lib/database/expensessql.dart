import 'package:sqflite/sqflite.dart' as sql;
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLHelper {
  static Future<Database> createTables(sql.Database database) async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'db.db'),
      onCreate: (database, version) async {
        await database.execute("CREATE TABLE expenses("
            "id INTEGER PRIMARY KEY AUTOINCREMENT,"
            "name TEXT NOT NULL,"
            "amount INTEGER NOT NULL,"
            "budgetId INTEGER NOT NULL,"
            "FOREIGN KEY(budgetId) REFERENCES budget(id)),"
            "createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP");
      },
      version: 1,
    );
  }

  static Future<sql.Database> db() async {
  return sql.openDatabase(
    'expenses.db',
    version: 1, 
    onCreate: (sql.Database db, int version) async {
      print("...creating database...");
      await createTables(db);
    }
  ); 
}

  static Future<int> createExpense(
      String name, double amount, int budgetId) async {
    final db = await SQLHelper.db();
    final data = {'name': name, 'amount': amount, 'budgetId': budgetId};
    final id = await db.insert('expenses', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getExpenses(int budgetId) async {
    final db = await SQLHelper.db();
    return db.query('expenses', where: "budgetId = ?", whereArgs: [budgetId]);
  }

  static Future<List<Map<String, dynamic>>> getExpense(int id) async {
    final db = await SQLHelper.db();
    return db.query('expenses', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateExpense(int id, String duty, double amount) async {
    final db = await SQLHelper.db();
    final data = {
      'duty': duty,
      'amount': amount,
      'createdAt': DateTime.now().toString()
    };
    final result =
        await db.update('expenses', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteExpense(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("expenses", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  static Future<double> getTotalAmountExpenses() async {
    final db = await SQLHelper.db();
    final result = await db.rawQuery('SELECT SUM(amount) FROM budget');
    return (result.first['SUM(amount)'] ?? 0) as double;
  }
}
