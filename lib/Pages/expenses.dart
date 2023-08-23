import 'package:flutter/material.dart';
//import 'package:sqflite/sqflite.dart' as sql;

import '../database/budgetsql.dart';

class ExpensesPage extends StatefulWidget {
  @override
  _ExpensesPageState createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  List<Map<String, dynamic>> items = []; // List to store fetched items

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  Future<void> fetchItems() async {
    final itemList = await SQLHelper.getItems();
    setState(() {
      items = itemList;
    });
  }
   Future<List<String>> fetchDutyNames() async {
    final itemList = await SQLHelper.getItems();
    return itemList.map<String>((item) => item['duty']).toList();
  }

Future<void> _showAddExpenseDialog() async {
    String selectedDuty = '';

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Add Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FutureBuilder<List<String>>(
              future: fetchDutyNames(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No duties available.');
                } else {
                  return DropdownButton<String>(
                    value: selectedDuty,
                    onChanged: (value) {
                      setState(() {
                        selectedDuty = value!;
                      });
                    },
                    items: snapshot.data!.map<DropdownMenuItem<String>>(
                      (duty) {
                        return DropdownMenuItem<String>(
                          value: duty,
                          child: Text(duty),
                        );
                      },
                    ).toList(),
                  );
                }
              },
            ),
            // You can add more content here, like amount text field
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              // Call your SQLHelper function here to insert the new item
              // SQLHelper.createItem(selectedDuty, newAmount);
              fetchItems(); // Update the list
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
