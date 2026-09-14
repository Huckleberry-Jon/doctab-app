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
  });

  testWidgets('user can add a note and see it in Notes',
      (WidgetTester tester) async {
    await tester.pumpWidget(const DocTabApp());
    await tester.pumpAndSettle();

    final addFinder = find.text('Add');
    await tester.ensureVisible(addFinder);
    await tester.tap(addFinder);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'Doctor Visit');
    await tester.enterText(
      find.byType(TextField).at(1),
      'Call back in two weeks and bring the blood pressure log.',
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final notesFinder = find.text('Notes');
    await tester.ensureVisible(notesFinder);
    await tester.tap(notesFinder);
    await tester.pumpAndSettle();

    expect(find.text('Doctor Visit'), findsOneWidget);
    expect(
      find.textContaining('blood pressure log'),
      findsOneWidget,
    );
  });
}
