import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const BudgetApp());
}

// Model class for BudgetEvent
class BudgetEvent {
  final String duty;
  final double amount;
  final DateTime dateTime;

  BudgetEvent(this.duty, this.amount, this.dateTime);
}

class BudgetApp extends StatelessWidget {
  const BudgetApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BudgetPage(),
    );
  }
}

class BudgetPage extends StatefulWidget {
  const BudgetPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BudgetPageState createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
<<<<<<< HEAD:lib/Pages/bugdet.dart
  List<BudgetEvent> BudgetEvents = [];
=======
  final CollectionReference budgetCollection = FirebaseFirestore.instance.collection('/Savingmoney/tU5leq9sILp1wL88TsZE/budget/emUrgfcCykkNMKBtAYjx/event');

  List<BudgetEvent> budgetEvents = [];
>>>>>>> 41f7200e8c71f44978a1a29b96b6148883efa258:lib/bugdet.dart
  double totalAmount = 0.0;
  final _deletedEventsStack = <BudgetEvent>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Budget Fee'),
      ),
<<<<<<< HEAD:lib/Pages/bugdet.dart
      body: ListView.builder(
        itemCount: BudgetEvents.length + 1,
        itemBuilder: (context, index) {
          if (index == BudgetEvents.length) {
            // Display the total amount at the bottom of the list
            return ListTile(
              title: const Text('Total Amount'),
              subtitle: Text('Tsh${totalAmount.toStringAsFixed(2)}'),
              onTap: () {
                // Implement undo for the last deleted event (if available)
                if (_deletedEventsStack.isNotEmpty) {
                  setState(() {
                    BudgetEvent lastDeletedEvent = _deletedEventsStack.pop()!;
                    BudgetEvents.add(lastDeletedEvent);
                    totalAmount += lastDeletedEvent.amount;
                  });
                }
              },
            );
          }

          BudgetEvent event = BudgetEvents[index];
          return ListTile(
            title: Text(event.duty),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tsh${event.amount.toStringAsFixed(2)}'),
                Text('Date and Time: ${event.dateTime.toString()}'),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  _deletedEventsStack.push(event); // Store deleted event
                  BudgetEvents.removeAt(index);
                  totalAmount -= event.amount; // Decrease totalAmount
                });

                // Show a SnackBar to provide an "Undo" option
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Event deleted.'),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        setState(() {
                          // Restore the deleted event
                          BudgetEvents.insert(index, event);
                          totalAmount += event.amount;
=======
      body: StreamBuilder<QuerySnapshot>(
        stream: budgetCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            budgetEvents = snapshot.data!.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              return BudgetEvent(data['duty'], data['amount'], data['dateTime'].toDate());
            }).toList();
            totalAmount = budgetEvents.fold(0, (sum, event) => sum + event.amount);
          }
          return ListView.builder(
            itemCount: budgetEvents.length + 1,
            itemBuilder: (context, index) {
              if (index == budgetEvents.length) {
                // Display the total amount at the bottom of the list
                return ListTile(
                  title: const Text('Total Amount'),
                  subtitle: Text('Tsh ${totalAmount.toStringAsFixed(2)}'),
                  onTap: () {
                    // Implement undo for the last deleted event (if available)
                    if (_deletedEventsStack.isNotEmpty) {
                      setState(() {
                        BudgetEvent lastDeletedEvent = _deletedEventsStack.removeLast();
                        budgetCollection.doc().set({
                          'duty': lastDeletedEvent.duty,
                          'amount': lastDeletedEvent.amount,
                          'dateTime': lastDeletedEvent.dateTime,
>>>>>>> 41f7200e8c71f44978a1a29b96b6148883efa258:lib/bugdet.dart
                        });
                        totalAmount += lastDeletedEvent.amount;
                      });
                    }
                  },
                );
              }

              BudgetEvent event = budgetEvents[index];
              return ListTile(
                title: Text(event.duty),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tsh ${event.amount.toStringAsFixed(2)}'),
                    Text('Date and Time: ${event.dateTime.toString()}'),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      _deletedEventsStack.add(event); // Store deleted event
                      budgetCollection.doc().delete(); // Remove the event from Firestore
                      budgetEvents.removeAt(index);
                      totalAmount -= event.amount; // Decrease totalAmount
                    });

                    // Show a SnackBar to provide an "Undo" option
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Event deleted.'),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () {
                            setState(() {
                              // Restore the deleted event
                              budgetCollection.doc().set({
                                'duty': event.duty,
                                'amount': event.amount,
                                'dateTime': event.dateTime,
                              });
                              budgetEvents.insert(index, event);
                              totalAmount += event.amount;
                            });
                            _deletedEventsStack.remove(event);
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addNewEvent(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addNewEvent(BuildContext context) async {
    BudgetEvent? newEvent = await showDialog(
      context: context,
      builder: (context) => const AddEventDialog(),
    );

    if (newEvent != null) {
      setState(() {
<<<<<<< HEAD:lib/Pages/bugdet.dart
        BudgetEvents.add(newEvent);
        totalAmount += newEvent.amount; // Add to totalAmount
=======
        budgetCollection.doc().set({
          'duty': newEvent.duty,
          'amount': newEvent.amount,
          'dateTime': newEvent.dateTime,
        });
>>>>>>> 41f7200e8c71f44978a1a29b96b6148883efa258:lib/bugdet.dart
      });
    }
  }
}
class AddEventDialog extends StatefulWidget {
  const AddEventDialog({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddEventDialogState createState() => _AddEventDialogState();
}

class _AddEventDialogState extends State<AddEventDialog> {
  final TextEditingController _dutyController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Event'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _dutyController,
            decoration: const InputDecoration(labelText: 'Duty'),
          ),
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Amount'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            String duty = _dutyController.text.trim();
            double amount = double.tryParse(_amountController.text) ?? 0.0;

            if (duty.isNotEmpty && amount > 0) {
              // Get the current date and time
              DateTime now = DateTime.now();

              // Create a new BudgetEvent with the current date and time
              BudgetEvent newEvent = BudgetEvent(duty, amount, now);

              // Close the dialog and pass the new event back to the BudgetPage
              Navigator.pop(context, newEvent);
            } else {
              // Show an error message if duty or amount is invalid
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please enter valid duty and amount.'),
                ),
              );
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
