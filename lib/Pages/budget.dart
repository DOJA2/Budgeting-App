import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/budgetsql.dart';
import 'dart:async';
//import 'package:path_provider/path_provider.dart';
//import 'package:sqflite/sqflite.dart';
//import 'dart:io';
//import 'database_helper.dart';

class BudgetPage extends StatefulWidget {
  @override
  BudgetPageState createState() => BudgetPageState();
}

class BudgetPageState extends State<BudgetPage> {
  List<Map<String, dynamic>> _items = [];
  String formattedDateTime = ''; // This will hold the formatted date and time

  @override
  void initState() {
    super.initState();
    _loadItems();
    updateDateTime();
  }

  void updateDateTime() {
    final now = DateTime.now();
    formattedDateTime = DateFormat('EEE, MMM dd yyyy').format(now);
  }

  Future<void> _loadItems() async {
    final db = await SQLHelper.db();
    final formatteTodayDate =
        DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    final items = await db.query('budget', where: "todayDate = ?",
        whereArgs: [formatteTodayDate], orderBy: 'createdAt DESC');
    setState(() {
      _items = items;
    });
  }

  Future<void> _addItem(String duty, double amount) async {
    await SQLHelper.createItem(duty, amount);
    await _loadItems();
  }

  Future<void> _deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    await _loadItems();
  }

  String formatAmount(double amount) {
  final numberFormat = NumberFormat.currency(
    symbol: '', // Currency symbol
    decimalDigits: 2, // Number of decimal digits
    locale: 'en_US', // Use the appropriate locale for your currency formatting
  );

  return numberFormat.format(amount);
}

  String getTotalAmountBudget() {
  final total = _items.fold(0.0, (previous, item) => previous + item['amount']);
  return formatAmount(total);
}

  String capitalize(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Text('Budget Page'),
            Spacer(), // Takes up space in between
            Text(formattedDateTime),
          ],
        ),
      ),
      body: ListView.builder(
  itemCount: _items.length,
  itemBuilder: (context, index) {
    final item = _items[index];
     final amountFormatted = NumberFormat.currency(
      symbol: '', // Currency symbol
      decimalDigits: 2, // Number of decimal digits
      locale: 'en_US', // Use the appropriate locale for your currency formatting
    ).format(item['amount']);

    // Add a symbolAndNumberSeparator
    const symbolAndNumberSeparator = 'TZS '; // Change this to your desired separator

    final amountFormattedWithSeparator = '$symbolAndNumberSeparator$amountFormatted';

    final capitalDutyBudget = capitalize(item['duty']); // Capitalize the duty
  
    return item['id'] == 1?Container(): Column(
      children: <Widget>[
        ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(capitalDutyBudget),
              Text(amountFormattedWithSeparator),
            ],
          ),
          subtitle: Text(formattedDateTime),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _deleteItem(item['id']),
          ),
        ),
        const Divider( // Add a Divider between each ListTile
          height: 1, // Specify the height of the Divider
          color: Colors.grey, // Specify the color of the Divider
        ),
      ],
    );
  },
),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              String duty = '';
              double amount = 0.0;
              return AlertDialog(
                title: Text('Add Event'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Budget Name'),
                      onChanged: (value) => duty = value,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Budget Amount'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => amount = double.parse(value),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    child: Text('Cancel'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  TextButton(
                    child: Text('Save'),
                    onPressed: () async {
                      if (amount != 0) {
                        await _addItem(duty, amount);
                        Navigator.of(context).pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Please enter the required')));
                      }
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50,
          child: Center(
            child: Text(
              'Total Amount: TZS ${getTotalAmountBudget()}',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
