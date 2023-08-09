import 'package:flutter/material.dart';

void main() {
  runApp(const BudgetApp());
}

class BudgetApp extends StatelessWidget {
  const BudgetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BudgetPage(),
    );
  }
}

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BudgetPageState createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  List<BudgetEvent> budgetEvents = [];
  double totalAmount = 0.0;
  final _deletedEventsStack = <BudgetEvent>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Budget Fee'),
      ),
      body: ListView.builder(
        itemCount: budgetEvents.length + 1,
        itemBuilder: (context, index) {
          if (index == budgetEvents.length) {
            // Display the total amount at the bottom of the list
            return ListTile(
              title: const Text('Total Amount'),
              subtitle: Text('Tsh${totalAmount.toStringAsFixed(2)}'),
              onTap: () {
                // Implement undo for the last deleted event (if available)
                if (_deletedEventsStack.isNotEmpty) {
                  setState(() {
                    BudgetEvent lastDeletedEvent = _deletedEventsStack.pop()!;
                    budgetEvents.add(lastDeletedEvent);
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
                Text('Tsh${event.amount.toStringAsFixed(2)}'),
                Text('Date and Time: ${event.dateTime.toString()}'),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  _deletedEventsStack.push(event); // Store deleted event
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
        budgetEvents.add(newEvent);
        totalAmount += newEvent.amount; // Add to totalAmount
      });
    }
  }
}

class BudgetEvent {
  final String duty;
  final double amount;
  final DateTime dateTime;

  BudgetEvent(this.duty, this.amount, this.dateTime);
}

class AddEventDialog extends StatefulWidget {
  const AddEventDialog({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddEventDialogState createState() => _AddEventDialogState();
}

class _AddEventDialogState extends State<AddEventDialog> {
  // ignore: prefer_final_fields
  TextEditingController _dutyController = TextEditingController();
  // ignore: prefer_final_fields
  TextEditingController _amountController = TextEditingController();

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

// Extension to implement a simple stack using a List
extension StackExtension<T> on List<T> {
  void push(T element) {
    add(element);
  }

  T? pop() {
    if (isEmpty) return null;
    return removeLast();
  }
}
