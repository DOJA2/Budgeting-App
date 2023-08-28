import 'package:flutter/material.dart';
//import 'package:sqflite/sqflite.dart' as sql;

import '../database/budgetsql.dart';
import '../database/expensessql.dart';

class ExpensesPage extends StatefulWidget {
  @override
  _ExpensesPageState createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  List<Map<String, dynamic>> items = []; // List to store fetched items
  // List<Map<String, dynamic>> addedExpenses = [];
  List<Map<String, dynamic>> _items = []; //fetch items created on database

  late String? selectedItem;
  late List<String> dutiesFromDB;
  Map<String, dynamic>? selectedExpense;
  String? duty;
  double? amount;
  String? title;

  // final amountController = TextEditingController();
  // final dutyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    populateDuties();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final db = await Expensehelper.db();
    final items = await db.query('expensess', orderBy: 'createdAt DESC');
    setState(() {
      _items = items;
    });
  }

  Future<void> _addItem(String? title, String duty, double amount) async {
    if (title != null) {
      await Expensehelper.createItem(title, duty, amount);
      await _loadItems();
    } else {
      return showDialog(
          context: context,
          builder: (BuildContext ctx) =>
              AlertDialog(content: Text("Please enter First your Budget")));
    }
  }

  // Future<void> _deleteItem(int id) async {
  //   await Expensehelper.deleteItem(id);
  //   await _loadItems();
  // }

  Future<void> _deleteCategory(String category) async {
    await Expensehelper.deleteCategory(category);
    await _loadItems();
  }

  Future<void> _deleteExpense(int id) async {
    await Expensehelper.deleteExpense(id);
    await _loadItems();
  }

  double _getTotalAmountExpense() {
    double total = 0;
    for (final item in _items) {
      total += item['amount'];
    }
    return total;
  }

  Future<void> populateDuties() async {
    List<String> duties = await SQLHelper.getDutyNames();
    dutiesFromDB = duties;
    setState(() {
      selectedItem = duties.isNotEmpty ? duties[0] : '';
    });
  }

// String? selectedDuty;
  Future<void> _showAddExpenseDialog() async {
    await showDialog(
        context: context,
        builder: (ctx) {
          String? selectedItem;
          String duty = '';
          double amount = 0.0;
          return AlertDialog(
            title: Text('Expense Dialog'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                  child: DropdownButtonFormField(
                    hint: Text("Choose Category:"),
                    value: selectedItem,
                    items: dutiesFromDB.map((duty) {
                      return DropdownMenuItem(
                        value: duty,
                        child: Text(duty),
                      );
                    }).toList(),
                    onChanged: (String? newDuty) {
                      setState(() {
                        selectedItem = newDuty!;
                      });
                    },
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 28,
                    iconEnabledColor: Colors.black,
                    // decoration: InputDecoration(
                    //   border: OutlineInputBorder(
                    //     borderRadius: BorderRadius.circular(12),
                    //   ),
                    // ),
                    // padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
                // You can add more content here, like amount text field
                SizedBox(height: 10),
                TextFormField(
                  // controller: dutyController,
                  decoration: InputDecoration(labelText: 'Expense Name'),
                  onChanged: (value) => duty = value,
                  // onChanged: (value) => duty = value,
                ),
                SizedBox(height: 10),
                TextFormField(
                  // controller: amountController,
                  // validator: (value) {
                  //   if (value!.isEmpty) {
                  //     return 'Please enter an amount';
                  //   }

                  //   if (double.tryParse(value) == null) {
                  //     return 'Please enter a valid number';
                  //   }

                  //   return null;
                  // },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Expense  Amount'),
                  onChanged: (value) => amount = double.parse(value),
                  //onChanged: (value) => amount = double.parse(value),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                child: Text('Add'),
                onPressed: () async {
                  // await _addItem(selectedItem!, duty, amount);
                  // Navigator.of(context).pop();
                  // if (amountController.text.isEmpty) {
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //       SnackBar(content: Text('Please enter an amount')));
                  //   return;
                  // }
                  // double amount = double.parse(amountController.text);
                  // // ignore: unnecessary_null_comparison
                  // if (amount == null) {
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //       SnackBar(content: Text('Please enter a valid number')));
                  //   return;
                  // }
                  if (selectedItem != null) {
                    await _addItem(selectedItem, duty, amount);
                    // ... rest of the code ...
                    // Map<String, dynamic> expense = {
                    //   'title': selectedItem,
                    //   'subtitle': '{$duty?? ' '} - Tsh {$amount.toStringAsFixed(2)}',
                    // };

                    // setState(() {
                    //   addedExpenses.add(expense);
                    // });
                    Navigator.of(context).pop(); // Close the AlertDialog
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text('Please select an item from the dropdown')));
                    // return;
                    // Handle the case where selectedItem is null.
                    // You can show an error message or prevent the addition.
                  }
                },
              ),
              ElevatedButton(
                onPressed: () =>
                    Navigator.of(context).pop(), // Close the AlertDialog
                child: Text('Cancel'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expenses Page'),
      ),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (ctx, index) {
          String title = _items[index]['title'] ?? '';
          List<Map<String, dynamic>> titleItems = _items
              .where((expense) => expense['selectedItem'] == selectedItem)
              .toList();
          //final expense = _items[index];

          return ExpansionTile(
            title: Text(title),
            children: titleItems.map<Widget>((expense) {
              String duty = expense['duty'];
              double amount = expense['amount'];
              int id = expense['id'];
              // subtitle: Text('${expense['duty']}: Tsh ${expense['amount']}'),
              // trailing: IconButton(
              //   icon: const Icon(Icons.delete),
              //   onPressed: () => _deleteItem(expense['id']),
              // ),
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 2.0),
                child: ListTile(
                  title: Text(
                    duty,
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Amount: $amount'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteExpense(id),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddExpenseDialog,
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
