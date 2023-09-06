 //import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart' as sql;

//create a table of budget
class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE income(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      duty TEXT NOT NULL,
      amount INTEGER NOT NULL,
      todayDate TEXT NOT NULL,
      createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'dbincome.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        print("...creating a table...");
        await createTables(database);
      },
    );
  }

  static Future<int> createItem(String duty, double amount) async {
    final todayDate =
        DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();

    final db = await SQLHelper.db();
    final data = {'duty': duty, 'amount': amount, 'todayDate': todayDate};
    final id = await db.insert('income', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

// //retreive of data orderBy id
//   static Future<List<Map<String, dynamic>>> getItems() async {
//     final db = await SQLHelper.db();
//     return db.query('income', orderBy: "id");
//   }

// //responsible for getting one item from database
//   static Future<List<Map<String, dynamic>>> getItem(int id) async {
//     final db = await SQLHelper.db();
//     return db.query('income', where: "id = ?", whereArgs: [id], limit: 1);
//   }

  static Future<int> updateItem(int id, String duty, double amount) async {
    final db = await SQLHelper.db();

    final data = {
      'duty': duty,
      'amount': amount,
      'createdAt': DateTime.now().toString()
    };
    final result =
        await db.update('income', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("income", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  static Future<double> getTotalAmount() async {
    final db = await SQLHelper.db();
    final result = await db.rawQuery('SELECT SUM(amount) FROM income');
    return double.parse((result.first['SUM(amount)'] ?? 0).toString());
  }
}
