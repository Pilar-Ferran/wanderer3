import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_login/Screens/login_screen.dart';
import 'package:my_login/Screens/signup_screen.dart';


void main() {
  // Define a test. The TestWidgets function also provides a WidgetTester
  // to work with. The WidgetTester allows you to build and interact
  // with widgets in the test environment.
  const MaterialApp app = MaterialApp(
    home: Scaffold(
        body:  const SignupScreen()
    ),
  );

  testWidgets('Test of explore_screen', (WidgetTester tester) async {
    await tester.pumpWidget(app);

    expect(find.byType(TextField), findsNWidgets(3));
    expect(find.text('Create Account'), findsNWidgets(1));
    expect(find.text('Login'), findsNWidgets(1));
    expect(find.byType(GestureDetector),findsNWidgets(2));
    expect(find.byType(Icon),findsNWidgets(3));
  });
}