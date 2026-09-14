import 'package:flutter/foundation.dart';

import '../models/note.dart';
import '../storage/note_storage.dart';

class NoteController extends ChangeNotifier {
  NoteController({NoteStorage? storage}) : _storage = storage ?? NoteStorage();

  final NoteStorage _storage;
  final List<Note> _notes = <Note>[];
  bool _loaded = false;

  List<Note> get notes => List.unmodifiable(_notes);
  bool get loaded => _loaded;

  Future<void> load() async {
    _notes
      ..clear()
      ..addAll(await _storage.loadNotes());
    _loaded = true;
    notifyListeners();
  }

  Future<void> add(Note note) async {
    _notes.insert(0, note);
    await _persist();
  }

  Future<void> update(Note updated) async {
    final index = _notes.indexWhere((note) => note.id == updated.id);
    if (index == -1) return;
    _notes[index] = updated;
    _sort();
    await _persist();
  }

  Future<void> delete(String id) async {
    _notes.removeWhere((note) => note.id == id);
    await _persist();
  }

  List<Note> search(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return notes;
    return _notes.where((note) {
      return note.title.toLowerCase().contains(normalized) ||
          note.content.toLowerCase().contains(normalized);
    }).toList(growable: false);
  }

  Future<void> _persist() async {
    _sort();
    await _storage.saveNotes(_notes);
    notifyListeners();
  }

  void _sort() {
    _notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }
}