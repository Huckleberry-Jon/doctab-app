import 'package:flutter/material.dart';

import '../models/memory_item.dart';

class AddMemoryScreen extends StatefulWidget {
  const AddMemoryScreen({super.key, this.existing});

  final MemoryItem? existing;

  @override
  State<AddMemoryScreen> createState() => _AddMemoryScreenState();
}

class _AddMemoryScreenState extends State<AddMemoryScreen> {
  static const List<String> _categories = <String>[
    'People',
    'Places',
    'Important details',
    'Preferences',
    'Other',
  ];

  late final TextEditingController _titleController;
  late final TextEditingController _detailsController;
  late String _category;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.existing?.title ?? '');
    _detailsController = TextEditingController(text: widget.existing?.details ?? '');
    _category = widget.existing?.category ?? 'Important details';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  void _save() {
    final title = _titleController.text.trim();
    final details = _detailsController.text.trim();
    if (title.isEmpty || details.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add a title and something to remember.')),
      );
      return;
    }

    final now = DateTime.now();
    final existing = widget.existing;
    Navigator.pop(
      context,
      existing == null
          ? MemoryItem(
              id: now.microsecondsSinceEpoch.toString(),
              title: title,
              details: details,
              category: _category,
              createdAt: now,
              updatedAt: now,
            )
          : existing.copyWith(
              title: title,
              details: details,
              category: _category,
              updatedAt: now,
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.existing != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(editing ? 'Edit Memory' : 'Add Memory'),
        actions: [
          TextButton(onPressed: _save, child: const Text('Save')),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: _titleController,
            autofocus: !editing,
            decoration: const InputDecoration(
              labelText: 'Title',
              hintText: 'Example: Gate code at Mom’s house',
            ),
          ),
          const SizedBox(height: 18),
          DropdownButtonFormField<String>(
            initialValue: _category,
            decoration: const InputDecoration(labelText: 'Category'),
            items: _categories
                .map(
                  (category) => DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  ),
                )
                .toList(growable: false),
            onChanged: (value) {
              if (value != null) setState(() => _category = value);
            },
          ),
          const SizedBox(height: 18),
          TextField(
            controller: _detailsController,
            minLines: 5,
            maxLines: 10,
            decoration: const InputDecoration(
              labelText: 'What should DocTab remember?',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save_outlined),
            label: Text(editing ? 'Save Changes' : 'Save Memory'),
          ),
        ],
      ),
    );
  }
}
