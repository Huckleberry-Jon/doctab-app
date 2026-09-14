import 'package:flutter/material.dart';

import '../models/reminder.dart';
import '../services/reminder_controller.dart';
import 'add_reminder_screen.dart';

class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key, required this.controller});

  final ReminderController controller;

  Future<void> _addReminder(BuildContext context) async {
    final reminder = await Navigator.push<Reminder>(
      context,
      MaterialPageRoute(builder: (_) => const AddReminderScreen()),
    );
    if (reminder != null) {
      await controller.add(reminder);
    }
  }

  Future<void> _editReminder(BuildContext context, Reminder reminder) async {
    final updated = await Navigator.push<Reminder>(
      context,
      MaterialPageRoute(
        builder: (_) => AddReminderScreen(reminder: reminder),
      ),
    );
    if (updated != null) {
      await controller.update(updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Today')),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          if (!controller.loaded) {
            return const Center(child: CircularProgressIndicator());
          }

          final overdue = controller.overdue();
          final today = controller.dueToday();
          final upcoming = controller.upcoming();

          if (controller.reminders.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(28),
                child: Text(
                  'Nothing scheduled yet.\nTap Add Reminder to put something on your day.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
            children: [
              if (overdue.isNotEmpty) ...[
                _SectionTitle(label: 'Overdue', count: overdue.length),
                const SizedBox(height: 8),
                ...overdue.map(
                  (reminder) => _ReminderCard(
                    reminder: reminder,
                    onToggle: () => controller.toggleCompleted(reminder),
                    onTap: () => _editReminder(context, reminder),
                    onDelete: () => controller.delete(reminder.id),
                  ),
                ),
                const SizedBox(height: 20),
              ],
              _SectionTitle(label: 'Today', count: today.length),
              const SizedBox(height: 8),
              if (today.isEmpty)
                const _EmptySection(message: 'No reminders due today.')
              else
                ...today.map(
                  (reminder) => _ReminderCard(
                    reminder: reminder,
                    onToggle: () => controller.toggleCompleted(reminder),
                    onTap: () => _editReminder(context, reminder),
                    onDelete: () => controller.delete(reminder.id),
                  ),
                ),
              const SizedBox(height: 20),
              _SectionTitle(label: 'Upcoming', count: upcoming.length),
              const SizedBox(height: 8),
              if (upcoming.isEmpty)
                const _EmptySection(message: 'Nothing upcoming yet.')
              else
                ...upcoming.map(
                  (reminder) => _ReminderCard(
                    reminder: reminder,
                    onToggle: () => controller.toggleCompleted(reminder),
                    onTap: () => _editReminder(context, reminder),
                    onDelete: () => controller.delete(reminder.id),
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addReminder(context),
        icon: const Icon(Icons.add_alert_outlined),
        label: const Text('Add Reminder'),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.label, required this.count});

  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(width: 8),
        Text('($count)'),
      ],
    );
  }
}

class _EmptySection extends StatelessWidget {
  const _EmptySection({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(message),
      ),
    );
  }
}

class _ReminderCard extends StatelessWidget {
  const _ReminderCard({
    required this.reminder,
    required this.onToggle,
    required this.onTap,
    required this.onDelete,
  });

  final Reminder reminder;
  final VoidCallback onToggle;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final textStyle = reminder.isCompleted
        ? const TextStyle(
            decoration: TextDecoration.lineThrough,
            color: Colors.grey,
          )
        : const TextStyle(fontWeight: FontWeight.w700);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          leading: Checkbox(
            value: reminder.isCompleted,
            onChanged: (_) => onToggle(),
          ),
          title: Text(reminder.title, style: textStyle),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              _subtitle(reminder),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          onTap: onTap,
          trailing: PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') onDelete();
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'delete',
                child: Text('Delete'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _subtitle(Reminder reminder) {
    final due = reminder.dueAt.toLocal();
    final hour = due.hour == 0
        ? 12
        : due.hour > 12
            ? due.hour - 12
            : due.hour;
    final minute = due.minute.toString().padLeft(2, '0');
    final suffix = due.hour >= 12 ? 'PM' : 'AM';
    final when = '${due.month}/${due.day}/${due.year} · $hour:$minute $suffix';
    if (reminder.details.isEmpty) return when;
    return '$when\n${reminder.details}';
  }
}
