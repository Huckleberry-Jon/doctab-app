import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/reminder.dart';

class ReminderStorage {
  static const _key = 'doctab_reminders_v1';

  Future<List<Reminder>> loadReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) {
      return <Reminder>[];
    }

    final decoded = jsonDecode(raw) as List<dynamic>;
    final reminders = decoded
        .map((item) => Reminder.fromJson(item as Map<String, dynamic>))
        .toList();

    reminders.sort((a, b) => a.dueAt.compareTo(b.dueAt));
    return reminders;
  }

  Future<void> saveReminders(List<Reminder> reminders) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded =
        jsonEncode(reminders.map((reminder) => reminder.toJson()).toList());
    await prefs.setString(_key, encoded);
  }
}
