import 'package:flutter/material.dart';
import 'package:saving_money/Pages/Report.dart';
import 'package:saving_money/Pages/budget.dart';
//import 'package:saving_money/Pages/bugdet.dart';
import 'package:saving_money/Pages/history.dart';
import 'package:saving_money/Pages/income.dart';



import 'expenses.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
 
  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
     BudgetPage(),
    const IncomePage(),
      ExpensesPage(),
     const ReportPage(),
    const History(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _navigateBottomBar,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.money), label: 'Budget'),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_wallet), label: 'Income'),
            BottomNavigationBarItem(
                icon: Icon(Icons.monetization_on), label: 'Expenses'),
            BottomNavigationBarItem(icon: Icon(Icons.report), label: 'Report'),
            BottomNavigationBarItem(
                icon: Icon(Icons.history), label: 'History'),
          ]),
    );
  }
}
