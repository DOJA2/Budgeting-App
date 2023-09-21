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
    loadItems();
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
        await fetchBudgetItemsForToday(); // Refresh budgetItems list.
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

  Future<void> fetchBudgetItemsForToday() async {
    final dutyNames = await SQLHelper.getDutyNamesForToday();
    setState(() {
      budgetItems = dutyNames;
    });
  }

  String formatAmount(double amount) {
    final numberFormat = NumberFormat.currency(
      symbol: '', // Currency symbol
      decimalDigits: 2, // Number of decimal digits
      locale:
          'en_US', // Use the appropriate locale for your currency formatting
    );
    return numberFormat.format(amount);
  }

  String getTotalAmountExpenses() {
    final total =
        _items.fold(0.0, (previous, item) => previous + item['amount']);
    return formatAmount(total);
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
        itemCount: budgetItems.length,
        itemBuilder: (context, index) {
          final budgetItem = budgetItems[index];
          final expensesForBudget = _items
              .where((item) => item['budget_duty'] == budgetItem)
              .toList();
              
          print(budgetItem);
          print(expensesForBudget);

          return ExpansionTile(
            title: Text(budgetItem),
            children: expensesForBudget.map<Widget>((expense) {
              final expenseName = expense['duty'];
              final expenseAmount = expense['amount'];
              print(expenseName);

              return ListTile(
                title: Text(expenseName),
                subtitle: Text('Amount: ${formatAmount(expenseAmount)}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    // ...
                  },
                ),
              );
            }).toList(),
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
                        Navigator.of(context)
                            .pop(); // You may want to close the dialog here
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
            'Total Amount: Tsh ${getTotalAmountExpenses()}',
            style: TextStyle(fontSize: 20),
          ),
        ),
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
