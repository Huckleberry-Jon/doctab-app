import 'package:flutter/foundation.dart';

import '../models/reminder.dart';
import '../storage/reminder_storage.dart';

class ReminderController extends ChangeNotifier {
  ReminderController({ReminderStorage? storage})
      : _storage = storage ?? ReminderStorage();

  final ReminderStorage _storage;
  final List<Reminder> _reminders = <Reminder>[];
  bool _loaded = false;

  List<Reminder> get reminders => List.unmodifiable(_reminders);
  bool get loaded => _loaded;

  Future<void> load() async {
    _reminders
      ..clear()
      ..addAll(await _storage.loadReminders());
    _sort();
    _loaded = true;
    notifyListeners();
  }

  Future<void> add(Reminder reminder) async {
    _reminders.add(reminder);
    await _persist();
  }

  Future<void> update(Reminder updated) async {
    final index = _reminders.indexWhere((item) => item.id == updated.id);
    if (index == -1) return;
    _reminders[index] = updated;
    await _persist();
  }

  Future<void> toggleCompleted(Reminder reminder) async {
    await update(
      reminder.copyWith(
        isCompleted: !reminder.isCompleted,
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<void> delete(String id) async {
    _reminders.removeWhere((item) => item.id == id);
    await _persist();
  }

  List<Reminder> dueToday([DateTime? now]) {
    final current = now ?? DateTime.now();
    return _reminders.where((reminder) {
      final due = reminder.dueAt.toLocal();
      return due.year == current.year &&
          due.month == current.month &&
          due.day == current.day;
    }).toList(growable: false);
  }

  List<Reminder> upcoming([DateTime? now]) {
    final current = now ?? DateTime.now();
    final startOfTomorrow = DateTime(
      current.year,
      current.month,
      current.day + 1,
    );
    return _reminders
        .where((reminder) => reminder.dueAt.toLocal().isAfter(startOfTomorrow))
        .toList(growable: false);
  }

  List<Reminder> overdue([DateTime? now]) {
    final current = now ?? DateTime.now();
    final startOfToday = DateTime(current.year, current.month, current.day);
    return _reminders
        .where(
          (reminder) =>
              !reminder.isCompleted &&
              reminder.dueAt.toLocal().isBefore(startOfToday),
        )
        .toList(growable: false);
  }

  Future<void> _persist() async {
    _sort();
    await _storage.saveReminders(_reminders);
    notifyListeners();
  }

  void _sort() {
    _reminders.sort((a, b) {
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }
      return a.dueAt.compareTo(b.dueAt);
    });
  }
}
