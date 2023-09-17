// import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../database/budgetsql.dart';
// import '../database/expensessql.dart';

class ExpensesPage extends StatefulWidget {
  @override
  _ExpensesPageState createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  String formattedDateTime = '';
  List<Map<String, dynamic>> _items = []; //fetch items created on database
  // List<Map<String, dynamic>> selectedBudgetItem = [];
  List<Map<String, dynamic>> items = []; //fetch items created on database
  // String? duty;
  // double? amount;
  
  

  @override
  void initState() {
    super.initState();
    updateDateTime();
    fetchBudgetItemsForToday();
  }

  void updateDateTime() {
    final now = DateTime.now();
    formattedDateTime = DateFormat('EEE, MMM dd yyyy').format(now);
  }

  Future<void> loadItems() async {
    final db = await SQLHelper.db();
    final formatteTodayDate =
        DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    final items = await db.query('expensess',
        where: "todayDate = ?",
        whereArgs: [formatteTodayDate],
        orderBy: 'createdAt DESC');
    print(items);
    print('kweeetuuuuuu');
    setState(() {
      _items = items;
    });
  }

  Future<void> addItemExpenses(
    String duty, double amount, String? budgetItem) async {
  if (budgetItem != null) {
    // Convert budgetItem to its corresponding budget ID here
    final budgetId = await getBudgetIdByName(budgetItem);

    if (budgetId != null) {
      await SQLHelper.createItemExpenses(duty, amount, budgetId);
      await loadItems();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Expenses added successfully.'),
        ),
      );
    } else {
      // Handle the case where budgetItem is not found
      showDialog(
        context: context,
        builder: (BuildContext ctx) =>
            AlertDialog(content: Text("Budget item not found.")),
      );
    }
  } else {
    // Handle the case where budgetItem is null
    showDialog(
      context: context,
      builder: (BuildContext ctx) =>
          AlertDialog(content: Text("Budget item is null.")),
    );
  }
}

  Future<int?> getBudgetIdByName(String budgetName) async {
    final db = await SQLHelper.db();
    final result =
        await db.query('budget', where: 'duty = ?', whereArgs: [budgetName]);
    if (result.isNotEmpty) {
      return result.first['id'] as int?;
    }
    return null;
  }

  List<String> budgetItems = []; //fetch budgetItem

  void fetchBudgetItemsForToday() async {
    final dutyNames = await SQLHelper.getDutyNamesForToday();
    setState(() {
      budgetItems = dutyNames;
    });
  }

  double _getTotalAmountExpense() {
    double total = 0;
    for (final item in _items) {
      total += item['amount'];
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Text('Expenses Page'),
            Spacer(), // Takes up space in between
            Text(formattedDateTime),
          ],
        ),
      ),
       body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context,index) {
          final item = _items[index];
          return Column(
            children: <Widget> [
              ExpansionTile(
                title: Text(item['selectedBudgetItem']?? ''),
                children: _items.map<Widget>((item) {
                  return Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(item['duty']),
                        subtitle: Text(item['amount'].toString()),
                        trailing: IconButton(
  icon: const Icon(Icons.delete),
  onPressed: () {
    // ...
  },
),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
  
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show the AlertDialog to add expenses
          showDialog(
            context: context,
            builder: (ctx) {
              String? selectedBudgetItem;
              double amount = 0.0;
              String duty = '';
              return AlertDialog(
                title: Text('Add Expenses'),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text('Select a Budget Item:'),
                      SizedBox(height: 8.0),
                      Container(
                        padding: EdgeInsets.only(left: 16, right: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                        child: DropdownButtonFormField<String>(
                          hint: Text("Choose BudgetItem:"),
                          value: selectedBudgetItem,
                          items: budgetItems.map((String item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedBudgetItem = newValue!;
                            });
                          },
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 28,
                          iconEnabledColor: Colors.black,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        onChanged: (value) => duty = value,
                        decoration: InputDecoration(
                          labelText: 'Expenses Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        // controller: amountController,
                        onChanged: (value) => amount = double.parse(value),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Expenses Amount',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (selectedBudgetItem != null &&
                          duty.isNotEmpty &&
                          amount != 0) {
                        await addItemExpenses(
                            duty, amount, selectedBudgetItem!);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Expenses added successfully.'),
                          ),
                        );
                        print(selectedBudgetItem);
                        print(duty);
                        print(amount);
                        Navigator.of(context).pop(); // You may want to close the dialog here
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please fill in all fields.'),
                          ),
                        );
                      }
                    },
                    child: Text('Add Expenses'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
          child: Container(
        height: 50,
        child: Center(
          child: Text(
            'Total Amount: Tsh ${_getTotalAmountExpense()}',
            style: TextStyle(fontSize: 20),
          ),
        ),
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
