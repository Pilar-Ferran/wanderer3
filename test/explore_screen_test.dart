import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_login/Screens/explore_screen.dart';

void main() {
  // Define a test. The TestWidgets function also provides a WidgetTester
  // to work with. The WidgetTester allows you to build and interact
  // with widgets in the test environment.
  const MaterialApp app = MaterialApp(
    home: Scaffold(
        body:  const ExploreScreen()
    ),
  );

  testWidgets('Test of explore_screen', (WidgetTester tester) async {
      await tester.pumpWidget(app);

      expect(find.byType(TextField), findsNWidgets(1));
      expect(find.text('Search'), findsNWidgets(1));
      expect(find.byType(ElevatedButton),findsNWidgets(1));
      expect(find.byType(TabBar),findsOneWidget);
    });
}