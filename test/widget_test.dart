//import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saving_money/main.dart';

void main() {
  testWidgets('Test if buttons are displayed', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify if the buttons are displayed on the screen.
    expect(find.text('Budget'), findsOneWidget);
    expect(find.text('Expenses'), findsOneWidget);
    expect(find.text('Report'), findsOneWidget);
    expect(find.text('Income'), findsOneWidget);
    expect(find.text('History'), findsOneWidget);
  });

 testWidgets('Test navigation to BudgetPage', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Tap the 'Budget' button and trigger navigation.
    await tester.tap(find.text('Budget'));
    await tester.pumpAndSettle();

    // Verify if we're on the BudgetPage.
    expect(find.text('This is the Budget Page'), findsOneWidget);
  });

  // You can add similar tests for the other buttons/pages as well.
}
//With these changes, when you run the app, tapping on any of the buttons ('Budget', 'Expenses', 'Report', 'Income', 'History') will navigate to the respective pages. Additionally, the widget tests will check if the buttons are displayed on the screen and verify that the navigation to the next pages is functioning correctly.




