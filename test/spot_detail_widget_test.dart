/*import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_login/Component/trip_preview.dart';
import 'package:my_login/dataclasses/trip_data.dart';

void main() {
  MaterialApp app = MaterialApp(
    home: Scaffold(
        body:  TripPreview(TripData("Ferran", "titulo", "place", "this is a description", "aaaaaaaaaaaaaaa"))
    ),
  );


  testWidgets('test of TripPreview', (WidgetTester tester) async {

    await tester.pumpWidget(app);

    //expect(find.text('Soundtrack'), findsNWidgets(1));
    expect(find.byType(Text), findsNWidgets(4));

  });
}*/