import 'package:flutter/material.dart';

import '../models/reminder.dart';

class AddReminderScreen extends StatefulWidget {
  const AddReminderScreen({super.key, this.reminder});

  final Reminder? reminder;

  @override
  State<AddReminderScreen> createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _detailsController;
  late DateTime _dueAt;

  bool get _editing => widget.reminder != null;

  @override
  void initState() {
    super.initState();
    final reminder = widget.reminder;
    _titleController = TextEditingController(text: reminder?.title ?? '');
    _detailsController = TextEditingController(text: reminder?.details ?? '');
    _dueAt = reminder?.dueAt.toLocal() ?? DateTime.now().add(const Duration(hours: 1));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueAt,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (picked == null) return;
    setState(() {
      _dueAt = DateTime(
        picked.year,
        picked.month,
        picked.day,
        _dueAt.hour,
        _dueAt.minute,
      );
    });
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dueAt),
    );
    if (picked == null) return;
    setState(() {
      _dueAt = DateTime(
        _dueAt.year,
        _dueAt.month,
        _dueAt.day,
        picked.hour,
        picked.minute,
      );
    });
  }

  void _save() {
    final title = _titleController.text.trim();
    final details = _detailsController.text.trim();
    if (title.isEmpty) return;

    final now = DateTime.now();
    final existing = widget.reminder;
    final reminder = Reminder(
      id: existing?.id ?? now.microsecondsSinceEpoch.toString(),
      title: title,
      details: details,
      dueAt: _dueAt,
      isCompleted: existing?.isCompleted ?? false,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    );

    Navigator.pop(context, reminder);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editing ? 'Edit Reminder' : 'Add Reminder'),
        actions: [
          TextButton(onPressed: _save, child: const Text('Save')),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Reminder'),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _detailsController,
            decoration: const InputDecoration(
              labelText: 'Details (optional)',
              alignLabelWithHint: true,
            ),
            minLines: 3,
            maxLines: 5,
          ),
          const SizedBox(height: 20),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.calendar_today_outlined),
                  title: const Text('Date'),
                  subtitle: Text(_formatDate(_dueAt)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _pickDate,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.access_time),
                  title: const Text('Time'),
                  subtitle: Text(_formatTime(_dueAt)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _pickTime,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime value) {
    final local = value.toLocal();
    return '${local.month}/${local.day}/${local.year}';
  }

  String _formatTime(DateTime value) {
    final local = value.toLocal();
    final hour = local.hour == 0
        ? 12
        : local.hour > 12
            ? local.hour - 12
            : local.hour;
    final minute = local.minute.toString().padLeft(2, '0');
    final suffix = local.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $suffix';
  }
}
