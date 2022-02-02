import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_login/Screens/logout_screen.dart';



void main() {
  // Define a test. The TestWidgets function also provides a WidgetTester
  // to work with. The WidgetTester allows you to build and interact
  // with widgets in the test environment.
  const MaterialApp app = MaterialApp(
    home: Scaffold(
        body:  const LogoutScreen()
    ),
  );

  testWidgets('Test of logout_screen_test', (WidgetTester tester) async {
    await tester.pumpWidget(app);

    expect(find.byType(Expanded), findsNWidgets(0));
    expect(find.text('Followers'), findsNWidgets(0));
    expect(find.text('Following'), findsNWidgets(0));
    expect(find.text('Trips'), findsNWidgets(0));
    expect(find.byType(ClipOval),findsNWidgets(0));
    expect(find.byType(GestureDetector),findsNWidgets(0));
  });
}