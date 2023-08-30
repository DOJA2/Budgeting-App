import 'package:sqflite/sqflite.dart' as sql;
import 'package:flutter/foundation.dart';

class Expensehelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
      CREATE TABLE expensess(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT NOT NULL,
        duty TEXT NOT NULL,
        amount REAL NOT NULL,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
    """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'expense.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        print("...creating a table...");
        await createTables(database);
      },
    );
  }

  static Future<int> createItem(String title,String duty, double amount) async {
    final db = await Expensehelper.db();
    final data = {'title':title,'duty': duty, 'amount': amount};
    final id = await db.insert('expensess', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await Expensehelper.db();
    return db.query('expensess', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await Expensehelper.db();
    return db.query('expensess', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateItem(int id,  String title, String duty, double amount) async {
    final db = await Expensehelper.db();
    final data = {
      'title':title,
      'duty': duty,
      'amount': amount,
      'createdAt': DateTime.now().toString()
    };
    final result =
        await db.update('expensess', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteCategory(String category) async {
    final db = await Expensehelper.db();
    try {
      await db.delete('expensess', where: 'title = ?', whereArgs: [category]);
    } catch (err) {
      debugPrint('Something went wrong when deleting a category: $err');
    }
  }

  static Future<void> deleteExpense(int id) async {
    final db = await Expensehelper.db();
    try {
      await db.delete('expensess', where: 'id = ?', whereArgs: [id]);
    } catch (err) {
      debugPrint('Something went wrong when deleting an expense: $err');
    }
  }


  static Future<double> getTotalAmountExpense() async {
    final db = await Expensehelper.db();
    final result = await db.rawQuery('SELECT SUM(amount) FROM expensess');
    return double.parse((result.first['SUM(amount)'] ?? 0) .toString());
  } 

}