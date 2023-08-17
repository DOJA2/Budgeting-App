import 'package:flutter/material.dart';
import '../database/budgetsql.dart';
import 'dart:async';
//import 'package:path_provider/path_provider.dart';
//import 'package:sqflite/sqflite.dart';
//import 'dart:io';
//import 'database_helper.dart';

class BudgetPage extends StatefulWidget {
  BudgetPage({super.key});
   // Budget items list
  //final List<Map<String, dynamic>> budgetItems = [];

  @override
  _BudgetPageState createState() => _BudgetPageState();


}

class _BudgetPageState extends State<BudgetPage> {
  List<Map<String, dynamic>> _items = [];

  

  @override
  void initState() {
    super.initState();
    _loadItems();
    
  }

  Future<void> _loadItems() async {
    final db = await SQLHelper.db();
    final items = await db.query('budget', orderBy: 'createdAt DESC');
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

  double _getTotalAmountBudget() {
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
        title: const Text('Budget Page'),
      ),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          return ListTile(
            title: Text(item['duty']),
            subtitle: Text('Tsh ${item['amount']}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteItem(item['id']),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              String duty = '';
              double amount = 0.0;
              return AlertDialog(
                title: const Text('Add Event'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Duty'
                        ),
                      onChanged: (value) => duty = value,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Amount'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => amount = double.parse(value),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  TextButton(
                    child: const Text('Save'),
                    onPressed: () async {
                      await _addItem(duty, amount);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: 50,
          child: Center(
            child: Text(
              'Total Amount: Tsh ${_getTotalAmountBudget()}',
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
