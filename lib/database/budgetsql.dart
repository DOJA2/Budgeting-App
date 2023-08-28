import 'package:sqflite/sqflite.dart' as sql;
import 'package:flutter/foundation.dart';

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
      CREATE TABLE budget(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        duty TEXT NOT NULL,
        amount INTEGER NOT NULL,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
    """);
//  await database.execute("""
//       CREATE TABLE expenses(
//         id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
//         budgetId INTEGER NOT NULL,
//         item TEXT NOT NULL,
//         amount REAL NOT NULL,
//         createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
//         FOREIGN KEY (budgetId) REFERENCES budget(id)
//       )
//     """);

  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'dbmoney.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        print("...creating a table...");
        await createTables(database);
      },
    );
  }

  static Future<int> createItem(String duty, double amount) async {
    final db = await SQLHelper.db();
    final data = {'duty': duty, 'amount': amount};
    final id = await db.insert('budget', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('budget', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('budget', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateItem(int id, String duty, double amount) async {
    final db = await SQLHelper.db();
    final data = {
      'duty': duty,
      'amount': amount,
      'createdAt': DateTime.now().toString()
    };
    final result =
        await db.update('budget', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("budget", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  static Future<double> getTotalAmountBudget() async {
    final db = await SQLHelper.db();
    final result = await db.rawQuery('SELECT SUM(amount) FROM budget');
    return double.parse((result.first['SUM(amount)'] ?? 0) .toString());
  } 

  static Future<List<String>> getDutyNames() async {
    final db = await SQLHelper.db();
    final result = await db.query('budget', distinct: true, columns: ['duty']);
    return result.map((row) => row['duty'] as String).toList();
  }

//expenses functions 
  // static Future<int> createExpense(int budgetId, String item, double amount) async {
  //   final db = await SQLHelper.db();
  //   final data = {'budgetId': budgetId, 'item': item, 'amount': amount};
  //   final id = await db.insert('expenses', data,
  //       conflictAlgorithm: sql.ConflictAlgorithm.replace);
  //   return id;
  // }

  // static Future<List<Map<String, dynamic>>> getExpensesForBudget(int budgetId) async {
  //   final db = await SQLHelper.db();
  //   return db.query('expenses', where: "budgetId = ?", whereArgs: [budgetId], orderBy: "id");
  // }

  // static Future<int> updateExpense(int id, String item, double amount) async {
  //   final db = await SQLHelper.db();
  //   final data = {
  //     'item': item,
  //     'amount': amount,
  //     'createdAt': DateTime.now().toString()
  //   };
  //   final result =
  //       await db.update('expenses', data, where: "id = ?", whereArgs: [id]);
  //   return result;
  // }

  // static Future<void> deleteExpense(int id) async {
  //   final db = await SQLHelper.db();
  //   try {
  //     await db.delete("expenses", where: "id = ?", whereArgs: [id]);
  //   } catch (err) {
  //     debugPrint("Something went wrong when deleting an expense: $err");
  //   }
  // }

}