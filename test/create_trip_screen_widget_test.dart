import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_login/Screens/create_trip_screen.dart';

void main() {
  const MaterialApp app = MaterialApp(
    home: Scaffold(
        body:  CreateTripScreen()
    ),
  );


  // Define a test. The TestWidgets function also provides a WidgetTester
  // to work with. The WidgetTester allows you to build and interact
  // with widgets in the test environment.
  testWidgets('test of CreateTripScreen', (WidgetTester tester) async {
    // Test code goes here.
    //Firebase.initializeApp();
    //WidgetsFlutterBinding.ensureInitialized();
    //await Firebase.initializeApp();

    await tester.pumpWidget(app);

    // Create the Finders.
    //final addSpotButtonFinder = find.widgetWithText(ElevatedButton, "Add spot");
    expect(find.text('Add spot'), findsNWidgets(1));
    expect(find.byType(ElevatedButton), findsNWidgets(1));  //only one, because the "Create trip" one is disabled at first
    expect(find.byType(TextFormField), findsNWidgets(3));
    expect(find.byType(IconButton), findsNWidgets(2));

    // Use the `findsOneWidget` matcher provided by flutter_test to verify that the Text widgets appear exactly once in the widget tree.
    //expect(addSpotButtonFinder, findsOneWidget);
    //expect(messageFinder, findsOneWidget);
  });
}