import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:saving_money/database/incomesql.dart' as Income;
// import 'package:flutter/material.dart';

import 'budgetsql.dart';
import 'expensessql.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = 'report.db';
  static final _databaseVersion = 1;

  static final reportTable = 'reporttable';
  static final reportColumnId = 'id';
  static final reportColumnBudgetAmount = 'budgetamount';
  static final reportColumnIncomeAmount = 'incomeamount';
  static final reportColumnExpensesAmount = 'expensesamount';
  static final reportColumnSavingAmount = 'savingamount';
  static final reportColumnSpendingAmount = 'spendingamount';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // open the database
  _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL statement to create the report table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $reportTable (
            $reportColumnId INTEGER PRIMARY KEY,
            $reportColumnBudgetAmount REAL NOT NULL,
            $reportColumnIncomeAmount REAL NOT NULL,
            $reportColumnExpensesAmount REAL NOT NULL,
            $reportColumnSavingAmount REAL NOT NULL,
            $reportColumnSpendingAmount REAL NOT NULL,
            createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
          )
          ''');
  }

  // SQL statement to insert data into the report table
  Future<int> insertDataIntoReportTable() async {
    Database db = await instance.database;
    double totalBudget = await _fetchTotalBudget();
    double totalIncome = await _fetchTotalIncome();
    double totalExpenses = await _fetchTotalExpenses();
    double savingAmount = totalIncome - totalExpenses;
    double spendingAmount = totalBudget - totalExpenses;
    Map<String, dynamic> row = {
      reportColumnBudgetAmount: totalBudget,
      reportColumnIncomeAmount: totalIncome,
      reportColumnExpensesAmount: totalExpenses,
      reportColumnSavingAmount: savingAmount,
      reportColumnSpendingAmount: spendingAmount
    };
    return await db.insert(reportTable, row);
  }

  // SQL statement to get the total budget amount
  Future<double> _fetchTotalBudget() async {
    try {
      final dbPath = await sql.getDatabasesPath();
      final db = await sql.openDatabase(path.join(dbPath, 'dbmoney.db'));
      final totalBudget = await SQLHelper.getTotalAmountBudget();
      return totalBudget;
    } catch (error) {
      // Handle error
      print("Error fetching total budget: $error");
      return 0;
    }
  }

  // SQL statement to get the total income amount
  Future<double> _fetchTotalIncome() async {
    try {
      final dbPath = await sql.getDatabasesPath();
      final db = await sql.openDatabase(path.join(dbPath, 'dbincome.db'));
      final totalIncome = await Income.SQLHelper.getTotalAmount();
      return totalIncome;
    } catch (error) {
      // Handle error
      print("Error fetching total income: $error");
      return 0;
    }
  }

  // SQL statement to get the total expenses amount
  Future<double> _fetchTotalExpenses() async {
    try {
      final dbPath = await sql.getDatabasesPath();
      final db = await sql.openDatabase(path.join(dbPath, 'expense.db'));
      final totalExpenses = await Expensehelper.getTotalAmountExpense();
      return totalExpenses;
    } catch (error) {
      // Handle error
      print("Error fetching total expenses: $error");
      return 0;
    }
  }

  // SQL statement to get the amount from the report table
  Future<Object> getAmountFromReportTable() async {
    Database db = await instance.database;
    return db.rawQuery('SELECT $reportColumnIncomeAmount FROM $reportTable');
  }

  // SQL statement to get the amount from the report table
  Future<double> fetchTotalBudget() async {
    Database db = await instance.database;
    final result =
        await db.rawQuery('SELECT $reportColumnBudgetAmount FROM $reportTable');
    return 0.0;
  }

  // SQL statement to get the amount from the report table
  Future<double> fetchTotalExpenses() async {
    Database db = await instance.database;
    var result = await db
        .rawQuery('SELECT $reportColumnExpensesAmount FROM $reportTable');
    return 0.0;
  }

  // SQL statement to get the amount from the report table
  Future<double> getTotalSavingAmount() async {
    Database db = await instance.database;
    var result =
        await db.rawQuery('SELECT $reportColumnSavingAmount FROM $reportTable');
    return 0.0;
  }

  // SQL statement to get the amount from the report table
  Future<double> getTotalSpendingAmount() async {
    Database db = await instance.database;
    var result = await db
        .rawQuery('SELECT $reportColumnSpendingAmount FROM $reportTable');
    return 0.0;
  }
}

class DatabaseHelp {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
CREATE TABLE reportTable(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  date dATE,
  budgetamount REAL NOT NULL,
  incomeamount REAL NOT NULL,
  expensesamount REAL NOT NULL,
  savingamount REAL NOT NULL,
  spendingamount REAL NOT NULL
)
""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase('report.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  static Future<int> createItem(double budgetamount, double incomeamount,
      double expensesamount, double savingamount, double spendingamount) async {
    final db = await DatabaseHelp.db();
    final data = {
      'budget_amount': budgetamount,
      'income_amount': incomeamount,
      'expenses_amount': expensesamount,
      'saving_amount': savingamount,
      'spending_amount': spendingamount
    };
    final id = await db.insert('reportTable', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

}
