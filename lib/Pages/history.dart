import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path; // Import for join function
import 'package:sqflite/sqflite.dart' as sql;
import '../database/budgetsql.dart';

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
  final List<Map<String, dynamic>> _historyList = [];
  

  @override
  void initState() {
    super.initState();
    updateDateTime();
    fetchAmountForDays();
  }

  void updateDateTime() {
    final now = DateTime.now();
    formattedDateTime = DateFormat('EEE, MMM dd yyy').format(now);
  }

   Future<void> fetchAmountForDays() async {
    try {
      final dbPath = await sql.getDatabasesPath();
      final db = await sql.openDatabase(path.join(dbPath, 'dbmoney.db'));

      final amountDateBudget = await SQLHelper.getAmountAndDateBudget();
      final amountDateIncome = await SQLHelper.getAmountAndDateIncome();
      final amountDateExpenses = await SQLHelper.getAmountAndDateExpenses();

      // Group the data by day
      final groupedData = groupDataByDay(amountDateBudget, amountDateIncome, amountDateExpenses);

      setState(() {
        _historyList.addAll(groupedData);
      });

      print("Here are the amounts for each day:");
      print(_historyList);
    } catch (error) {
      // Handle error
      print("Error fetching amounts for days: $error");
    }
  }

  List<Map<String, dynamic>> groupDataByDay(
      List<Map<String, dynamic>> budgetData,
      List<Map<String, dynamic>> incomeData,
      List<Map<String, dynamic>> expensesData) {
    final Map<String, Map<String, dynamic>> groupedData = {};

    // Initialize values to zero for each day
    for (final data in budgetData) {
      final date = data['todayDate'];
      groupedData[date] = {
        'todayDate': date,
        'totalAmountBudget': 0.0,
        'totalAmountIncome': 0.0,
        'totalAmountExpenses': 0.0,
      };
    }

    for (final data in incomeData) {
      final date = data['todayDate'];
      if (!groupedData.containsKey(date)) {
        groupedData[date] = {
          'todayDate': date,
          'totalAmountBudget': 0.0,
          'totalAmountIncome': 0.0,
          'totalAmountExpenses': 0.0,
        };
      }
    }

    for (final data in expensesData) {
      final date = data['todayDate'];
      if (!groupedData.containsKey(date)) {
        groupedData[date] = {
          'todayDate': date,
          'totalAmountBudget': 0.0,
          'totalAmountIncome': 0.0,
          'totalAmountExpenses': 0.0,
        };
      }
    }

    // Sum budget data by day
    for (final data in budgetData) {
      final date = data['todayDate'];
      final budgetValue = data['totalAmountBudget'];
      if (groupedData.containsKey(date)) {
        groupedData[date]!['totalAmountBudget'] += budgetValue ?? 0.0;
      }
    }

     // Sum income data by day
    for (final data in incomeData) {
      final date = data['todayDate'];
      final incomeValue = data['totalAmountIncome'];
      if (groupedData.containsKey(date)) {
        groupedData[date]!['totalAmountIncome'] += incomeValue ?? 0.0;
      }
    }

    // Sum expenses data by day
    for (final data in expensesData) {
      final date = data['todayDate'];
      final expensesValue = data['totalAmountExpenses'];
      if (groupedData.containsKey(date)) {
        groupedData[date]!['totalAmountExpenses'] += expensesValue ?? 0.0;
      }
    }

    return groupedData.values.toList();
  }

  @override
  Widget build(BuildContext context) {
     // Reverse the _historyList to display items from new to old
  final reversedHistoryList = _historyList.reversed.toList();
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Row(
              children: [
                Text('My History'),
                Spacer(),
              ],
            )),
        body: ListView.builder(
          itemCount: reversedHistoryList.length,
          itemBuilder: (context, index) {
            final historyData = reversedHistoryList[index];
            print(historyData);
            print('lets gooo');
            final date = historyData['todayDate'] as String;
            final totalAmountBudget = historyData['totalAmountBudget'];
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
                          _showTotalAmountDialog(totalAmountBudget ?? 0.0,
                      totalAmountIncome ?? 0.0,
                      totalAmountExpenses ?? 0.0,);
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

  void _showTotalAmountDialog(
    double budgetAmount,
    double incomeAmount,
    double expensesAmount,
  ) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Summary Report:'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Budget: Tsh $budgetAmount'),
              Text('Income: Tsh $incomeAmount'),
              Text('Expenses: Tsh $expensesAmount'),
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
