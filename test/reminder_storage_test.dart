import 'package:doctab/models/reminder.dart';
import 'package:doctab/storage/reminder_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  test('reminders survive a fresh storage instance', () async {
    final due = DateTime(2026, 9, 14, 9, 30);
    final firstStorage = ReminderStorage();

    await firstStorage.saveReminders([
      Reminder(
        id: 'reminder-1',
        title: 'Call supplier',
        details: 'Ask about the backordered seal.',
        dueAt: due,
        isCompleted: false,
        createdAt: due.subtract(const Duration(hours: 1)),
        updatedAt: due.subtract(const Duration(hours: 1)),
      ),
    ]);

    final secondStorage = ReminderStorage();
    final reminders = await secondStorage.loadReminders();

    expect(reminders, hasLength(1));
    expect(reminders.single.id, 'reminder-1');
    expect(reminders.single.title, 'Call supplier');
    expect(reminders.single.details, contains('backordered seal'));
    expect(reminders.single.isCompleted, isFalse);
  });
}
