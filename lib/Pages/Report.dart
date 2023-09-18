import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saving_money/database/budgetsql.dart';
import 'package:path/path.dart' as path; // Import for join function
import 'package:sqflite/sqflite.dart' as sql;

class ReportPage extends StatefulWidget {
  @override
  ReportPageState createState() => ReportPageState();
}

class ReportPageState extends State<ReportPage> {
  double totalBudget = 0.0;
  double totalIncome = 0.0;
  double totalExpenses = 0.0;
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
    fetchTotalBudget();
    fetchTotalIncome();
    fetchTotalExpenses();
    updateDateTime();
  }

  void updateDateTime() {
    final now = DateTime.now();
    formattedDateTime = DateFormat('EEE, MMM dd yyyy').format(now);
  }

  Future<void> fetchTotalBudget() async {
    final formatteTodayDate =
        DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    try {
      final dbPath = await sql.getDatabasesPath();
      final db = await sql.openDatabase(path.join(dbPath, 'dbmoney.db'));
      final totalBudget =
          await SQLHelper.getTotalAmountForDayBudget(formatteTodayDate);
      setState(() {
        this.totalBudget = totalBudget;
      });
    } catch (error) {
      // Handle error
      print("Error fetching total budget: $error");
    }
  }

  Future<void> fetchTotalIncome() async {
    final formatteTodayDate =
        DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    try {
      final dbPath = await sql.getDatabasesPath();
      final db = await sql.openDatabase(path.join(dbPath, 'dbincome.db'));
      final totalIncome =
          await SQLHelper.getTotalAmountForDayIncome(formatteTodayDate);
      setState(() {
        this.totalIncome = totalIncome;
      });
    } catch (error) {
      // Handle error
      print("Error fetching total income: $error");
    }
  }

  Future<void> fetchTotalExpenses() async {
    final formatteTodayDate =
        DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    try {
      final dbPath = await sql.getDatabasesPath();
      final db = await sql.openDatabase(path.join(dbPath, 'expense.db'));
      final totalExpenses =
          await SQLHelper.getTotalAmountForDayExpenses(formatteTodayDate);
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
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(children: [
          Text('Day Report'),
          Spacer(), // Takes up space in between
          Text(formattedDateTime),
        ]),
      ),
      body: Container(
        height: screenHeight, // Set the height based on screen height
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
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
            buildHeader(),
            SizedBox(height: 20),
            buildUnifiedAmountContainer(),
            SizedBox(height: 20),
            Text(
              '*Spending amount = Total Budget - Total Expenses',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            buildResultRow('Saving Amount', savingAmount, getSavingColor()),
            SizedBox(height: 20),
            Text(
              '*Saving amount = Total Income - Total Expenses',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            buildResultRow(
                'Spending Amount', spendingAmount, getSpendingColor()),
          ],
        ),
      ),
    );
  }

  Widget buildHeader() {
    return const Text(
      'REPORT',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget buildUnifiedAmountContainer() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
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
          buildAmountRow('Budget', totalBudget),
          buildAmountRow('Income', totalIncome),
          buildAmountRow('Expenses', totalExpenses),
        ],
      ),
    );
  }

  Widget buildAmountRow(String label, double amount) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Tsh ${amount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 18,
              //fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Inside the _buildResultRow method
  Widget buildResultRow(String label, double amount, Color color) {
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
          side: const BorderSide(color: Colors.grey),
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
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5), // Add some space
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
