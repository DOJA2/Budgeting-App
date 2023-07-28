import 'package:flutter/material.dart';

import 'bugdet.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 150,
              height: 50,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ButtonWidget(
                  label: 'Budget',
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const BudgetApp()) );
                    // Handle Budget button press here
                  },
                ),
              ),
            ),
            SizedBox(
              width: 150,
              height: 50,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ButtonWidget(
                  label: 'Expenses',
                  onPressed: () {
                    // Handle Expenses button press here
                  },
                ),
              ),
            ),
            SizedBox(
              width: 150,
              height: 50,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ButtonWidget(
                  label: 'Report',
                  onPressed: () {
                    // Handle Report button press here
                  },
                ),
              ),
            ),
            SizedBox(
              width: 150,
              height: 50,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ButtonWidget(
                  label: 'Income',
                  onPressed: () {
                    // Handle Income button press here
                  },
                ),
              ),
            ),
            SizedBox(
              width: 150,
              height: 50,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ButtonWidget(
                  label: 'History',
                  onPressed: () {
                    // Handle History button press here
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ButtonWidget extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const ButtonWidget({super.key, 
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
