import 'package:doctab/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets('DocTab home screen loads', (WidgetTester tester) async {
    await tester.pumpWidget(const DocTabApp());
    await tester.pumpAndSettle();

    expect(find.text('DocTab'), findsOneWidget);
    expect(
      find.text('Your day. Your notes. Your reminders. One place.'),
      findsOneWidget,
    );
    expect(find.text('Notes'), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
  });

  testWidgets('user can add a note and see it in Notes',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const DocTabApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'Doctor Visit');
    await tester.enterText(
      find.byType(TextField).at(1),
      'Call back in two weeks and bring the blood pressure log.',
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Notes'));
    await tester.pumpAndSettle();

    expect(find.text('Doctor Visit'), findsOneWidget);
    expect(
      find.textContaining('blood pressure log'),
      findsOneWidget,
    );
  });

  testWidgets('user can open Today and add a reminder',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const DocTabApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Today'));
    await tester.pumpAndSettle();

    expect(find.text('Add Reminder'), findsOneWidget);
    await tester.tap(find.text('Add Reminder'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'Call supplier');
    await tester.enterText(
      find.byType(TextField).at(1),
      'Ask about the backordered seal.',
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Call supplier'), findsOneWidget);
    expect(find.textContaining('backordered seal'), findsOneWidget);
  });
}
