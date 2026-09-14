import 'package:flutter/material.dart';

import '../models/note.dart';
import '../services/note_controller.dart';
import 'add_note_screen.dart';
import 'note_detail_screen.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key, required this.controller});

  final NoteController controller;

  Future<void> _addNote(BuildContext context) async {
    final note = await Navigator.push<Note>(
      context,
      MaterialPageRoute(builder: (_) => const AddNoteScreen()),
    );
    if (note != null) {
      await controller.add(note);
    }
  }

  Future<void> _openNote(BuildContext context, Note note) async {
    final updated = await Navigator.push<Note>(
      context,
      MaterialPageRoute(builder: (_) => NoteDetailScreen(note: note)),
    );
    if (updated != null) {
      await controller.update(updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          if (!controller.loaded) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.notes.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(28),
                child: Text(
                  'No notes yet.\nTap Add Note to save something you want to remember.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
            itemCount: controller.notes.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final note = controller.notes[index];
              return Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    note.title,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      note.content.isEmpty ? 'No additional text' : note.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _openNote(context, note),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addNote(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Note'),
      ),
    );
  }
}
