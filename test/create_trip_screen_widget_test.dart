import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_login/Screens/create_trip_screen.dart';

void main() {
  // Define a test. The TestWidgets function also provides a WidgetTester
  // to work with. The WidgetTester allows you to build and interact
  // with widgets in the test environment.
  testWidgets('CreateTripScreen has a add spot button', (WidgetTester tester) async {
    // Test code goes here.
    //Firebase.initializeApp();
    //WidgetsFlutterBinding.ensureInitialized();
    //await Firebase.initializeApp();

    await tester.pumpWidget(const CreateTripScreen());

    // Create the Finders.
    final addSpotButtonFinder = find.widgetWithText(ElevatedButton, "Add spot");
    final messageFinder = find.text('M');

    // Use the `findsOneWidget` matcher provided by flutter_test to verify that the Text widgets appear exactly once in the widget tree.
    expect(addSpotButtonFinder, findsOneWidget);
    //expect(messageFinder, findsOneWidget);
  });
}