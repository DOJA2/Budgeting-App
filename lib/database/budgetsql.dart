import 'package:sqflite/sqflite.dart' as sql;
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
      CREATE TABLE budget(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        duty TEXT NOT NULL,
        amount REAL NOT NULL,
        todayDate TEXT NOT NULL,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
    """);

    await database.execute("""CREATE TABLE income(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      duty TEXT NOT NULL,
      amount REAL NOT NULL,
      todayDate TEXT NOT NULL,
      createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )""");

    await database.execute("""
  CREATE TABLE expensess(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    duty TEXT NOT NULL,
    amount REAL NOT NULL,
    todayDate TEXT NOT NULL,
    createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    budget_id INTEGER,
    FOREIGN KEY (budget_id) REFERENCES budget(id) ON DELETE CASCADE
  )
""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'dbmoney.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        print("...creating a table...");
        await createTables(database);
        createItem('Others', 0.0);
      },
    );
  }

  // BUDGET FUNCTION

  static Future<int> createItem(String duty, double amount) async {
    final todayDate =
        DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();

    final db = await SQLHelper.db();
    final data = {'duty': duty, 'amount': amount, 'todayDate': todayDate};
    final id = await db.insert('budget', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
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

  //delete items in budget where delete the row which matches the item in expenses
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      // Delete the budget item from the 'budget' table
      await db.delete("budget", where: "id = ?", whereArgs: [id]);

      // Also, delete any associated expenses in the 'expenses' table
      await db.delete("expensess", where: "budget_id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  static Future<double> getTotalAmountBudget() async {
    final db = await SQLHelper.db();
    final result = await db.rawQuery('SELECT SUM(amount) FROM budget');
    return double.parse((result.first['SUM(amount)'] ?? 0).toString());
  }

  static Future<List<String>> getDutyNamesForToday() async {
    final todayDate =
        DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    final db = await SQLHelper.db();
    final result = await db.query('budget',
        distinct: true,
        columns: ['duty'],
        where: 'todayDate = ?',
        whereArgs: [todayDate]);
    return result.map((row) => row['duty'] as String).toList();
  }

  static Future<List<Map<String, dynamic>>> getAmountAndDateBudget() async {
    final db = await SQLHelper.db();
    final result = await db.rawQuery(
        'SELECT SUM(amount) AS totalAmountBudget, todayDate FROM budget GROUP BY todayDate');
    return result;
  }

  static Future<double> getTotalAmountForDayBudget(String date) async {
    final db = await SQLHelper.db();
    final result = await db.rawQuery(
      'SELECT SUM(amount) AS totalAmount FROM budget WHERE todayDate = ?',
      [date],
    );
    return double.parse((result.first['totalAmount'] ?? 0).toString());
  }

// INCOME FUNCTION

  //IncomeInsert
  static Future<int> createItemIncome(String duty, double amount) async {
    final todayDate =
        DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();

    final db = await SQLHelper.db();
    final data = {'duty': duty, 'amount': amount, 'todayDate': todayDate};
    final id = await db.insert('income', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  //IncomeUpdate
  static Future<int> updateItemIncome(
      int id, String duty, double amount) async {
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

  //DeleteIncome
  static Future<void> deleteItemIncome(int id) async {
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

  //getAmountAndDateIncome
  static Future<List<Map<String, dynamic>>> getAmountAndDateIncome() async {
    final db = await SQLHelper.db();
    final result = await db.rawQuery(
        'SELECT SUM(amount) AS totalAmountIncome, todayDate FROM income GROUP BY todayDate');
    return result;
  }

//getTotalAmountForDayIncome
  static Future<double> getTotalAmountForDayIncome(String date) async {
    final db = await SQLHelper.db();
    final result = await db.rawQuery(
      'SELECT SUM(amount) AS totalAmount FROM income WHERE todayDate = ?',
      [date],
    );
    return double.parse((result.first['totalAmount'] ?? 0).toString());
  }

// EXPENSES FUNCTIONS

  //InsertExpenses
  static Future<int> createItemExpenses(
      String duty, double amount, int budgetId) async {
    final todayDate =
        DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();

    final db = await SQLHelper.db();
    final data = {
      'duty': duty,
      'amount': amount,
      'todayDate': todayDate,
      'budget_id': budgetId
    };
    final id = await db.insert('expensess', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    print('yoouuuu');
    print(data);
    return id;
  }

  static Future<int> updateItemExpenses(
      int id, String title, String duty, double amount) async {
    final db = await SQLHelper.db();
    final data = {
      'title': title,
      'duty': duty,
      'amount': amount,
      'createdAt': DateTime.now().toString()
    };
    final result =
        await db.update('expensess', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteItemExpense(int id) async {
    final db = await SQLHelper.db();
    try {
      // Delete the expense item from the 'expenses' table
      await db.delete("expensess", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an expense item: $err");
    }
  }

  // getTotalAmountExpense
  static Future<double> getTotalAmountExpense() async {
    final db = await SQLHelper.db();
    final result = await db.rawQuery('SELECT SUM(amount) FROM expensess');
    return double.parse((result.first['SUM(amount)'] ?? 0).toString());
  }

//getAmountAndDateExpenses
  static Future<List<Map<String, dynamic>>> getAmountAndDateExpenses() async {
    final db = await SQLHelper.db();
    final result = await db.rawQuery(
        'SELECT SUM(amount) AS totalAmountExpenses, todayDate FROM expensess GROUP BY todayDate');
    return result;
  }

  // getTotalAmountForDayExpenses
  static Future<double> getTotalAmountForDayExpenses(String date) async {
    final db = await SQLHelper.db();
    final result = await db.rawQuery(
      'SELECT SUM(amount) AS totalAmount FROM expensess WHERE todayDate = ?',
      [date],
    );
    return double.parse((result.first['totalAmount'] ?? 0).toString());
  }

  // getTotalAmountForBudget
  static Future<double> getTotalAmountForBudget(int budgetId) async {
    final db = await SQLHelper.db();
    final result = await db.rawQuery(
      'SELECT SUM(amount) AS totalAmount FROM expensess WHERE budget_id = ?',
      [budgetId],
    );
    return double.parse((result.first['totalAmount'] ?? 0).toString());
  }
}
