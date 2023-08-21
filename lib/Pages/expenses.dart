import 'package:flutter/material.dart';
// import 'package:saving_money/database/budgetsql.dart';
// import 'package:path/path.dart' as path;
// import 'package:sqflite/sqflite.dart' as sql;

class ExpensesPage extends StatefulWidget {
  @override
  _ExpensesPageState createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  List<Map<String, dynamic>> _expenses = [];
  // List<String> duties = [];
  // String selectedDuty;

   @override
  void initState() {
    super.initState();
    //_fetchDuties();
  }

  // Future<void> _fetchDuties() async {
  //   try {
  //     final dbPath = await sql.getDatabasesPath();
  //     final db = await sql.openDatabase(path.join(dbPath, 'dbmoney.db'));
  //     final items = await SQLHelper.getItems();
  //     final List duties = items.map((item) => item['duty']).toList();
  //     setState(() {
  //       this.duties = duties;
  //     });
  //   } catch (error) {
  //     print("Error fetching duties: $error");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expenses'),
      ),
      body: ListView.builder(
        itemCount: _expenses.length,
        itemBuilder: (context, index) {
          String category = _expenses[index]['category'];
          List<Map<String, dynamic>> categoryExpenses = _expenses.where((expense) => expense['category'] == category).toList();

          return ExpansionTile(
            title: Text(category),
            children: categoryExpenses.map<Widget>((expense) {
              String duty = expense['duty'];
              double amount = expense['amount'];

              return ListTile(
                title: Text(duty),
                subtitle: Text('Amount: $amount'),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              String _category = 'Food';
              String _duty = '';
              double _amount = 0.0;

              return AlertDialog(
                title: Text('Add Expense'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButton<String>(
                      value: _category,
                      
                      onChanged: (value) {
                        setState(() {
                          _category = value!;
                        });
                      },
                      items: <String>['Food', 'Transport', 'Entertainment', 'Shopping']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Duty', 
                        border: OutlineInputBorder()),
                      onChanged: (value) {
                        setState(() {
                          _duty = value;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Amount',  
                        border: OutlineInputBorder(
                        )),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          _amount = double.parse(value);
                        });
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _expenses.add({
                          'category': _category,
                          'duty': _duty,
                          'amount': _amount,
                        });
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}