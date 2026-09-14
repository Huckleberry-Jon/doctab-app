import 'package:flutter_test/flutter_test.dart';
import 'package:doctab/main.dart';

void main() {
  testWidgets('DocTab home screen loads', (WidgetTester tester) async {
    await tester.pumpWidget(const DocTabApp());

    expect(find.text('DocTab'), findsOneWidget);
    expect(
      find.text('Your day. Your notes. Your reminders. One place.'),
      findsOneWidget,
    );
    expect(find.text('Notes'), findsOneWidget);
  });
}