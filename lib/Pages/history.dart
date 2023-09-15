import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path; // Import for join function
import 'package:sqflite/sqflite.dart' as sql;
import '../database/budgetsql.dart';
import '../database/expensessql.dart';
import '../database/incomesql.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  String formattedDateTime = '';
  double amountDateBudget = 0.0;
  double amountDateIncome = 0.0;
  double amountDateExpenses = 0.0;
  final List<Widget> listTiles = [];
  List<Map<String, dynamic>> _historyList = [];

  @override
  void initState() {
    super.initState();
    updateDateTime();
    // _fetchTotalBudget();
    fetchAmountDateBudget();
    fetchTotalIncome();
    fetchTotalExpenses();
  }

  void updateDateTime() {
    final now = DateTime.now();
    formattedDateTime = DateFormat('EEE, MMM dd yyy').format(now);
  }

  // Future<void> _fetchTotalBudget() async {
  //   try {
  //     final dbPath = await sql.getDatabasesPath();
  //     final db = await sql.openDatabase(path.join(dbPath, 'dbmoney.db'));
  //     final totalBudget = await SQLHelper.getTotalAmountBudget();
  //     setState(() {
  //       this.totalBudget = totalBudget;
  //     });
  //   } catch (error) {
  //     // Handle error
  //     print("Error fetching total budget: $error");
  //   }
  // }

  Future<void> fetchAmountDateBudget() async {
    try {
      final dbPath = await sql.getDatabasesPath();
      final db = await sql.openDatabase(path.join(dbPath, 'dbmoney.db'));
      final amountDateBudget = await SQLHelper.getAmountAndDateBudget();
      setState(() {
        _historyList.addAll(amountDateBudget.map((data) {
          // Check if 'totalAmountBudget' is not null before casting
          final totalAmountBudget = data['totalAmountBudget'] != null
              ? (data['totalAmountBudget'] as double?)
              : null;

          // Format the date
          final date = DateTime.parse(data['todayDate']);
          final formattedDate = DateFormat('EEE, MMM dd yyy').format(date);

          return {
            'todayDate': formattedDate,
            'totalAmountBudget': totalAmountBudget,
          };
        }).toList());
      });
      print(amountDateBudget);
      print("Hereeeeeeee");
      print(_historyList);
      print("heeeerrree");
    } catch (error) {
      // Handle error
      print("Error fetching total budget: $error");
    }
  }

  Future<void> fetchTotalIncome() async {
    try {
      final dbPath = await sql.getDatabasesPath();
      final db = await sql.openDatabase(path.join(dbPath, 'dbincome.db'));
      final amountDateIncome = await SQLHelper.getAmountAndDateIncome();
      setState(() {
        _historyList.addAll(amountDateIncome.map((data) {
          // Convert 'totalAmount' to double
          final totalAmountIncome = data['totalAmountIncome'] != null
              ? (data['totalAmountIncome'] as double)
              : null;

          // Format the date
          final date = DateTime.parse(data['todayDate']);
          final formattedDate = DateFormat('EEE, MMM dd yyy').format(date);

          return {
            'todayDate': formattedDate,
            'totalAmountIncome': totalAmountIncome,
          };
        }));
      });
      print(amountDateIncome);
      print("heeeerrree");
      print(_historyList);
    } catch (error) {
      // Handle error
      print("Error fetching total income: $error");
    }
  }

  Future<void> fetchTotalExpenses() async {
    try {
      final dbPath = await sql.getDatabasesPath();
      final db = await sql.openDatabase(path.join(dbPath, 'expense.db'));
      final amountDateExpenses = await SQLHelper.getAmountAndDateExpenses();
      setState(() {
        _historyList.addAll(amountDateExpenses.map((data) {
          // Check if 'totalAmountExpenses' is not null before casting
          final totalAmountExpenses = data['totalAmountExpenses'] != null
              ? (data['totalAmountExpenses']
                  as double?) // Cast to double or null
              : null; // Set it to null if it's null in the database

          // Format the date
          final date = DateTime.parse(data['todayDate']);
          final formattedDate = DateFormat('EEE, MMM dd yyy').format(date);

          return {
            'todayDate': formattedDate,
            'totalAmountExpenses': totalAmountExpenses,
          };
        }).toList());
      });
      print(amountDateExpenses);
      print("heeeerrree");
      print(_historyList);
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
            title: const Row(
              children: [
                Text('My History'),
                Spacer(),
                // Text(formattedDateTime)
              ],
            )),
        body: ListView.builder(
          itemCount: _historyList.length,
          itemBuilder: (context, index) {
            final historyData = _historyList[index];
            print(historyData);
            final date = historyData['todayDate'] as String;
            final totalAmountBudget = historyData['totalAmountudget'];
            final totalAmountIncome = historyData['totalAmountIncome'];
            final totalAmountExpenses = historyData['totalAmountExpenses'];
            print(totalAmountBudget);

            return Column(
              children: <Widget>[
                ListTile(
                    leading: Text(
                      date,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    trailing: IconButton(
                        icon: Icon(Icons.remove_red_eye_rounded),
                        onPressed: () {
                          _showTotalAmountDialog([
                            totalAmountBudget,
                            totalAmountIncome,
                            totalAmountExpenses
                          ]);
                        })),
                const Divider(
                  // Add a Divider between each ListTile
                  height: 1, // Specify the height of the Divider
                  color: Colors.grey, // Specify the color of the Divider
                ),
              ],
            );
          },
        ));
  }

  void _showTotalAmountDialog(List<double?> amounts) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Summary Report:'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Budget: Tsh ${amounts[0] ?? 0.0}'),
                Text('Income: Tsh ${amounts[1] ?? 0.0}'),
                Text('Expenses: Tsh ${amounts[2] ?? 0.0}'),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        });
  }
}
