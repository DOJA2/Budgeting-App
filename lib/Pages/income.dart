import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '../database/budgetsql.dart';
// import '../database/incomesql.dart';

class IncomePage extends StatefulWidget {
  const IncomePage({super.key});

  @override
  _IncomePageState createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  List<Map<String, dynamic>> _items = [];
  String formattedDateTime = '';  // This will hold the formatted date and time

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
    final items = await db.query('income', where: "todayDate = ?",
        whereArgs: [formatteTodayDate], orderBy: 'createdAt DESC');
    setState(() {
      _items = items;
    });
  }

  Future<void> _addItem(String duty, double amount) async {
    await SQLHelper.createItemIncome(duty, amount);
    await _loadItems();
  }

  Future<void> _deleteItem(int id) async {
    await SQLHelper.deleteItemIncome(id);
    await _loadItems();
  }

  double _getTotalAmount() {
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
            Text('Income Page'),
            Spacer(), // Takes up space in between
            Text(formattedDateTime),
          ],
        ),
      ),
      body: ListView.builder(
  itemCount: _items.length,
  itemBuilder: (context, index) {
    final item = _items[index];
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(item['duty']),
          subtitle: Column(
            children: [
              Text('Tsh ${item['amount']}'),
              Text('Date: ${item['todayDate']}'),
            ],
          ),
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
                        labelText: 'Income Name'),
                      onChanged: (value) => duty = value,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Income Amount'),
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
                      if (duty.isNotEmpty && amount != 0){
                      await _addItem(duty, amount);
                      Navigator.of(context).pop();
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter the required'))
                        );
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
        child: SizedBox(
          height: 50,
          child: Center(
            child: Text(
              'Total Amount: Tsh ${_getTotalAmount()}',
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
