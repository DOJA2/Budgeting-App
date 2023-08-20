import 'package:flutter/material.dart';
import 'package:saving_money/database/budgetsql.dart';
import 'package:path/path.dart' as path; // Import for join function
import 'package:sqflite/sqflite.dart' as sql;
import 'package:saving_money/database/incomesql.dart' as Income;

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  double totalBudget = 0.0;
  double totalIncome = 0.0;
  double totalExpenses = 0.0;
  double budget = 1000.0; // Replace with your actual budget value
  double income = 5000.0; // Replace with your actual income value
  double expenses = 1800.0; // Replace with your actual expenses value
  double get savingAmount => totalIncome - expenses;
  double get spendingAmount => totalBudget - expenses;

  Color getSavingColor() {
    if (savingAmount > 0) {
      return Colors.green;
    } else if (savingAmount < 0) {
      return Colors.red;
    } else {
      return Colors.blue;
    }
  }

  Color getSpendingColor() {
    if (spendingAmount > 0) {
      return Colors.green;
    } else if (spendingAmount < 0) {
      return Colors.red;
    } else {
      return Colors.blue;
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchTotalBudget();
    _fetchTotalIncome();
    // _fetchTotalExpenses();
  }

  Future<void> _fetchTotalBudget() async {
    try {
      final dbPath = await sql.getDatabasesPath();
      final db = await sql.openDatabase(path.join(dbPath, 'dbmoney.db'));
      final totalBudget = await SQLHelper.getTotalAmountBudget();
      setState(() {
        this.totalBudget = totalBudget;
      });
    } catch (error) {
      // Handle error
      print("Error fetching total budget: $error");
    }
  }

  Future<void> _fetchTotalIncome() async {
    try {
      final dbPath = await sql.getDatabasesPath();
      final db = await sql.openDatabase(path.join(dbPath, 'dbincome.db'));
      final totalIncome = await Income.SQLHelper.getTotalAmount();
      setState(() {
        this.totalIncome = totalIncome;
      });
    } catch (error) {
      // Handle error
      print("Error fetching total income: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Report'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            SizedBox(height: 20),
            _buildAmountRow('Budget', totalBudget),
            _buildAmountRow('Income', totalIncome),
            _buildAmountRow('Expenses', expenses),
            SizedBox(height: 20),
            _buildResultRow('Saving Amount', savingAmount, getSavingColor()),
            SizedBox(height: 20),
            _buildResultRow(
                'Spending Amount', spendingAmount, getSpendingColor()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      'REPORT',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildAmountRow(String label, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          Text(
            'Tsh ${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, double amount, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Tsh ${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
