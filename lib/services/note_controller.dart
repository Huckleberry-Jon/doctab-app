import 'package:flutter/foundation.dart';

import '../models/note.dart';
import '../storage/note_storage.dart';
import 'axis_proof_client.dart';

class NoteConflictException implements Exception {
  const NoteConflictException({
    required this.noteId,
    required this.expectedRevision,
    required this.actualRevision,
  });

  final String noteId;
  final int expectedRevision;
  final int actualRevision;

  @override
  String toString() {
    return 'NoteConflictException(noteId: $noteId, expectedRevision: $expectedRevision, actualRevision: $actualRevision)';
  }
}

class NoteController extends ChangeNotifier {
  NoteController({
    NoteStorage? storage,
    AxisProofClient? axisProofClient,
  })  : _storage = storage ?? NoteStorage(),
        _axisProofClient = axisProofClient ?? AxisProofClient();

  static const String syntheticProofNoteId = 'synthetic-note-1';

  final NoteStorage _storage;
  final AxisProofClient _axisProofClient;
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

  Future<Note> loadAxisProofNote() async {
    final note = await _axisProofClient.fetchNote();
    final index = _notes.indexWhere((item) => item.id == note.id);
    if (index == -1) {
      _notes.insert(0, note);
    } else {
      _notes[index] = note;
    }
    await _persist();
    return note;
  }

  Future<void> add(Note note) async {
    _notes.insert(0, note);
    await _persist();
  }

  Future<Note> update(Note updated) async {
    final index = _notes.indexWhere((note) => note.id == updated.id);
    if (index == -1) {
      return updated;
    }

    final current = _notes[index];
    if (current.revision != updated.revision) {
      throw NoteConflictException(
        noteId: updated.id,
        expectedRevision: updated.revision,
        actualRevision: current.revision,
      );
    }

    if (updated.id == syntheticProofNoteId) {
      try {
        final persisted = await _axisProofClient.directEdit(note: updated);
        _notes[index] = persisted;
        _sort();
        await _persist();
        return persisted;
      } on AxisProofConflictException catch (error) {
        _notes[index] = error.currentNote;
        _sort();
        await _persist();
        throw NoteConflictException(
          noteId: updated.id,
          expectedRevision: error.expectedRevision,
          actualRevision: error.currentRevision,
        );
      }
    }

    final persisted = updated.copyWith(
      updatedAt: DateTime.now(),
      revision: current.revision + 1,
    );

    _notes[index] = persisted;
    _sort();
    await _persist();
    return persisted;
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
