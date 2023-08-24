import 'package:flutter/material.dart';
//import 'package:sqflite/sqflite.dart' as sql;

import '../database/budgetsql.dart';

class ExpensesPage extends StatefulWidget {
  @override
  _ExpensesPageState createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  List<Map<String, dynamic>> items = []; // List to store fetched items

  late String selectedDuty;
  late List<String> dutiesFromDB;

  @override
  void initState() {
    super.initState();
    populateDuties();
  }

  Future<void> populateDuties() async {
    List<String> duties = await SQLHelper.getDutyNames();
    dutiesFromDB = duties;
    setState(() {
      selectedDuty = duties.isNotEmpty ? duties[0] : '';
    });
  }

  Future<void> _showAddExpenseDialog() async {
    // String selectedDuty = 'Category';

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Add Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.only(left:16, right:16),
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
                //hint: Text("Choose Category:"),
                value: selectedDuty,
                items: dutiesFromDB.map((duty) {
                  return DropdownMenuItem(
                    value: duty,
                    child: Text(duty),
                  );
                }).toList(),
                onChanged: (String? newDuty) {
                  setState(() {
                    selectedDuty = newDuty!;
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
            TextField(
              decoration: InputDecoration(hintText: 'Duty'),
              // onChanged: (value) => duty = value,
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(hintText: 'Amount'),
              keyboardType: TextInputType.number,
              //onChanged: (value) => amount = double.parse(value),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              // Call your SQLHelper function here to insert the new item
              // SQLHelper.createItem(selectedDuty, newAmount);
              Navigator.of(context).pop(); // Close the AlertDialog
            },
            child: Text('Add'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the AlertDialog
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expenses Page'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (ctx, index) {
          final item = items[index];
          return ListTile(
            title: Text(item['duty']),
            subtitle: Text('Amount: ${item['amount']}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddExpenseDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}

// void main() {
//   runApp(MaterialApp(
//     home: ExpensesPage(),
//   ));
// }
