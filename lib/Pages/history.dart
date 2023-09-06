import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path; // Import for join function
import 'package:sqflite/sqflite.dart' as sql;
import '../database/budgetsql.dart';
import '../database/expensessql.dart';
import '../database/incomesql.dart' as Income;

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  String formattedDateTime = '';
  double totalBudget = 0.0;
  double totalIncome = 0.0;
  double totalExpenses = 0.0;
  final List<Widget> listTiles = [];

  @override
  void initState() {
    super.initState();
    updateDateTime();
    _fetchTotalBudget();
    _fetchTotalIncome();
    _fetchTotalExpenses();
  }

  void updateDateTime() {
    final now = DateTime.now();
    formattedDateTime = DateFormat('EEE, MMM dd yyy').format(now);
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
            title: Row(
              children: [
                Text('My History'),
                Spacer(),
                // Text(formattedDateTime)
              ],
            )),
        body: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
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
              children: [
                ListTile(
                  leading: Text(formattedDateTime),
                  trailing: IconButton(
                    icon:Icon(Icons.remove_red_eye_rounded),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              
                              children: [
                                _buildHeader(),
                                SizedBox(height: 16),
                                _buildUnifiedAmountContainer(),
                              ],
                            ),
                          );
                        });
                  },
                )
                ),
                 Divider(), // Divider between ListTiles
                ListTile(
                  leading: Text(formattedDateTime),
                  trailing: IconButton(
                    icon:Icon(Icons.remove_red_eye_rounded),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              
                              children: [
                                _buildHeader(),
                                SizedBox(height: 16),
                                _buildUnifiedAmountContainer(),
                              ],
                            ),
                          );
                        });
                  },
                )
                ),
                Divider(), // Divider between ListTiles
                ListTile(
                  leading: Text(formattedDateTime),
                  trailing: IconButton(
                    icon:Icon(Icons.remove_red_eye_rounded),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              
                              children: [
                                _buildHeader(),
                                SizedBox(height: 16),
                                _buildUnifiedAmountContainer(),
                              ],
                            ),
                          );
                        });
                  },
                )
                ),
                // Divider(), // Divider between ListTiles
                ListTile(
                  leading: Text(formattedDateTime),
                  trailing: IconButton(
                    icon:Icon(Icons.remove_red_eye_rounded),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              
                              children: [
                                _buildHeader(),
                                SizedBox(height: 16),
                                _buildUnifiedAmountContainer(),
                              ],
                            ),
                          );
                        });
                  },
                )
                ),
                // Divider(), // Divider between ListTiles
                ListTile(
                  leading: Text(formattedDateTime),
                  trailing: IconButton(
                    icon:Icon(Icons.remove_red_eye_rounded),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              
                              children: [
                                _buildHeader(),
                                SizedBox(height: 16),
                                _buildUnifiedAmountContainer(),
                              ],
                            ),
                          );
                        });
                  },
                )
                ),
              // Divider(), // Divider between ListTiles
              ],
            )
    )
    );
  }

  Widget _buildHeader() {
    return Text(
      formattedDateTime,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildUnifiedAmountContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      
      children: [
        _buildAmountRow('Budget', totalBudget),
        SizedBox(height: 10),
        _buildAmountRow('Income', totalIncome),
        SizedBox(height: 10),
        _buildAmountRow('Expenses', totalExpenses),
      ],
    );
  }

  Widget _buildAmountRow(String label, double amount) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
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
}
