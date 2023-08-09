import 'package:flutter/material.dart';

void main() {
  runApp(ReportApp());
}

class ReportApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ReportPage(),
    );
  }
}

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  double budget = 1000.0; // Replace with your actual budget value
  double income = 5000.0; // Replace with your actual income value
  double expenses = 1800.0; // Replace with your actual expenses value
  double get savingAmount => income - expenses;
  double get spendingAmount => budget - expenses;

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
            _buildAmountRow('Budget', budget),
            _buildAmountRow('Income', income),
            _buildAmountRow('Expenses', expenses),
            SizedBox(height: 20),
            _buildResultRow('Saving Amount', savingAmount, getSavingColor()),
            SizedBox(height: 20),
            _buildResultRow('Spending Amount', spendingAmount, getSpendingColor()),
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
