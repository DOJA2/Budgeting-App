import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  Map<String, List<Map<String, dynamic>>> categoryMap = {};
  String formattedDateTime = '';  // This will hold the formatted date and time
  late String? selectedItem;
  late List<String> dutiesFromDB;
  Map<String, dynamic>? selectedExpense;
  String? duty;
  double? amount;
  String? title;


  @override
  void initState() {
    super.initState();
    populateDuties();
    _loadItems();
    updateDateTime();
  }

  

  void updateDateTime() {
    final now = DateTime.now();
    formattedDateTime = DateFormat('EEE, MMM dd yyyy').format(now);
  }

  Future<void> _loadItems() async {
    final db = await Expensehelper.db();
    final items =
        await db.query('expensess', orderBy: 'createdAt DESC');
    print(items);
    setState(() {
      _items = items;
    });
  }

  Future<void> _addItem(String? title, String duty, double amount) async {
  if (title != null) {
    if (categoryMap.containsKey(title)) {
      // Category already exists, add the expense to it
      categoryMap[title]!.add({'duty': duty, 'amount': amount});
    } else {
      // Category doesn't exist, create a new ExpansionTile with the category name
      categoryMap[title] = [{'duty': duty, 'amount': amount}];
    }
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
                  if (selectedItem != null && duty.isNotEmpty && amount != 0) {
                    await _addItem(selectedItem, duty, amount);
                    Navigator.of(context).pop(); // Close the AlertDialog
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text('Please add the requirements')));
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
          itemCount: categoryMap.length,
  itemBuilder: (ctx, index) {
    String category = categoryMap.keys.elementAt(index);
    List<Map<String, dynamic>> expenses = categoryMap[category]!;
          //final expense = _items[index];

           return Dismissible(
  key: Key(category), // Provide a unique key for each Dismissible widget
  child: ExpansionTile(
    title: Text(category),
    children: expenses.map<Widget>((expense) {
      String duty = expense['duty'];
      double amount = expense['amount'];
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 2.0),
        child: ListTile(
          title: Text(
            duty,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text('${expense['duty']}: Tsh ${expense['amount']}'),
        ),
      );
    }).toList(),
  ),
  onDismissed: (direction) {
    setState(() {
      // Remove the category from the categoryMap when dismissed
      categoryMap.remove(category);
    });
  },
  background: Container(
    color: Colors.red,
    alignment: Alignment.centerRight, 
    child: Padding(
      padding: EdgeInsets.only(right: 20.0),
      child: Icon(
        Icons.delete,
        color: Colors.white,
      ),
    ),
  )
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
