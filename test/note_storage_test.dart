import 'package:doctab/models/note.dart';
import 'package:doctab/storage/note_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  test('notes survive a fresh storage instance', () async {
    final now = DateTime(2026, 9, 13, 20, 0);
    final firstStorage = NoteStorage();

    await firstStorage.saveNotes([
      Note(
        id: 'note-1',
        title: 'Doctor Visit',
        content: 'Bring the blood pressure log.',
        createdAt: now,
        updatedAt: now,
      ),
    ]);

    final secondStorage = NoteStorage();
    final notes = await secondStorage.loadNotes();

    expect(notes, hasLength(1));
    expect(notes.single.id, 'note-1');
    expect(notes.single.title, 'Doctor Visit');
    expect(notes.single.content, contains('blood pressure'));
  });
}