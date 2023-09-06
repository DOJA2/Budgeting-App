import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saving_money/database/budgetsql.dart';
import 'package:path/path.dart' as path; // Import for join function
import 'package:sqflite/sqflite.dart' as sql;
import 'package:saving_money/database/incomesql.dart' as Income;
import '../database/expensessql.dart';

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  double totalBudget = 0.0;
  double totalIncome = 0.0;
  double totalExpenses = 0.0;
  // double budget = 1000.0; // Replace with your actual budget value
  // double income = 5000.0; // Replace with your actual income value
  // double expenses = 1800.0; // Replace with your actual expenses value
  double get savingAmount => totalIncome - totalExpenses;
  double get spendingAmount => totalBudget - totalExpenses;
  String formattedDateTime = ''; // This will hold the formatted date and time

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
    _fetchTotalExpenses();
    updateDateTime();
  }

  void updateDateTime() {
    final now = DateTime.now();
    formattedDateTime = DateFormat('EEE, MMM dd yyyy').format(now);
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

  Future<void> _fetchTotalExpenses() async {
    try {
      final dbPath = await sql.getDatabasesPath();
      final db = await sql.openDatabase(path.join(dbPath, 'expense.db'));
      final totalExpenses = await Expensehelper.getTotalAmountExpense();
      setState(() {
        this.totalExpenses = totalExpenses;
      });
    } catch (error) {
      // Handle error
      print("Error fetching total expenses: $error");
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(children: [
          Text('Daily Report'),
          Spacer(), // Takes up space in between
          Text(formattedDateTime),
        ]),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0, 2),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            SizedBox(height: 20),
            _buildUnifiedAmountContainer(),
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

  Widget _buildUnifiedAmountContainer() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 2),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildAmountRow('Budget', totalBudget),
          _buildAmountRow('Income', totalIncome),
          _buildAmountRow('Expenses', totalExpenses),
        ],
      ),
    );
  }

  Widget _buildAmountRow(String label, double amount) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      // decoration: BoxDecoration(
      //   color: Colors.grey[200],
      //   borderRadius: BorderRadius.circular(1),
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.grey,
      //       offset: Offset(0, 2),
      //       blurRadius: 4,
      //       spreadRadius: 0,
      //     ),
      //   ],
      // ),
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
              fontSize: 18,
              //fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Inside the _buildResultRow method
  Widget _buildResultRow(String label, double amount, Color color) {
    String message = '';
    Color messageColor = Colors.black; // Initialize with a default color
    String hint = '';

    if (label == 'Saving Amount') {
      if (amount > 0) {
        message = 'You\'re doing great on saving!';
        messageColor = Colors.green;
      } else if (amount < 0) {
        message = 'Oops! No savings this time.';
        messageColor = Colors.red;
      } else {
        message = 'Keep working on those savings!';
        messageColor = Colors.blue;
      }
      hint = 'Saving amount = Total Income - Total Expenses';
    } else if (label == 'Spending Amount') {
      if (amount > 0) {
        message = 'Your spending is under control!';
        messageColor = Colors.green;
      } else if (amount < 0) {
        message = 'You\'ve overspent this time.';
        messageColor = Colors.red;
      } else {
        message = 'Your spending is in balance.';
        messageColor = Colors.blue;
      }
      hint = 'Spending amount = Total Budget - Total Expenses';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 4,
        color: Colors.grey[200], // Set the card background color to grey
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey),
        ),
        child: Tooltip(
          message: hint, // Display the hint when user hovers over the card
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5), // Add some space
                Text(
                  'Tsh ${amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 20,
                    //fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: messageColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Future<void> getAmounts() async {
//   await _fetchTotalBudget();
//   await _fetchTotalIncome();
//   await _fetchTotalExpenses();
//   double savingAmount = totalIncome - totalExpenses;
//   double spendingAmount = totalBudget - totalExpenses;
//   setState(() {
//     this.savingAmount = savingAmount;
//     this.spendingAmount = spendingAmount;
//   });
// }

