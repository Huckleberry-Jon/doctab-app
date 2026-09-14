import 'package:flutter/material.dart';

import '../models/memory_item.dart';
import '../services/memory_controller.dart';
import '../theme/doctab_theme.dart';
import 'add_memory_screen.dart';

class MemoryScreen extends StatefulWidget {
  const MemoryScreen({super.key, required this.controller});

  final MemoryController controller;

  @override
  State<MemoryScreen> createState() => _MemoryScreenState();
}

class _MemoryScreenState extends State<MemoryScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_refresh);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_refresh);
    _searchController.dispose();
    super.dispose();
  }

  void _refresh() => setState(() {});

  Future<void> _addMemory() async {
    final memory = await Navigator.push<MemoryItem>(
      context,
      MaterialPageRoute(builder: (_) => const AddMemoryScreen()),
    );
    if (memory != null) await widget.controller.add(memory);
  }

  Future<void> _editMemory(MemoryItem memory) async {
    final updated = await Navigator.push<MemoryItem>(
      context,
      MaterialPageRoute(
        builder: (_) => AddMemoryScreen(existing: memory),
      ),
    );
    if (updated != null) await widget.controller.update(updated);
  }

  Future<void> _deleteMemory(MemoryItem memory) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete memory?'),
        content: Text('Delete “${memory.title}”?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) await widget.controller.delete(memory.id);
  }

  @override
  Widget build(BuildContext context) {
    final memories = widget.controller.search(_searchController.text);

    return Scaffold(
      appBar: AppBar(title: const Text('Memory')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addMemory,
        icon: const Icon(Icons.add),
        label: const Text('Add Memory'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Long-term things you want DocTab to keep easy to find.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: DocTabTheme.ink.withValues(alpha: 0.72),
                  ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search memory',
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: !widget.controller.loaded
                  ? const Center(child: CircularProgressIndicator())
                  : memories.isEmpty
                      ? _EmptyMemory(hasQuery: _searchController.text.trim().isNotEmpty)
                      : ListView.separated(
                          itemCount: memories.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final memory = memories[index];
                            return Card(
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 10,
                                ),
                                leading: const CircleAvatar(
                                  backgroundColor: DocTabTheme.sand,
                                  child: Icon(
                                    Icons.psychology_outlined,
                                    color: DocTabTheme.ink,
                                  ),
                                ),
                                title: Text(
                                  memory.title,
                                  style: const TextStyle(fontWeight: FontWeight.w700),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text(
                                    '${memory.category} • ${memory.details}',
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                onTap: () => _editMemory(memory),
                                trailing: IconButton(
                                  tooltip: 'Delete',
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () => _deleteMemory(memory),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyMemory extends StatelessWidget {
  const _EmptyMemory({required this.hasQuery});

  final bool hasQuery;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          hasQuery
              ? 'No memories match that search.'
              : 'Nothing saved in Memory yet.\nTap Add Memory to save something important long-term.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
