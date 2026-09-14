import 'package:doctab/models/note.dart';
import 'package:doctab/storage/note_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  test('notes survive a fresh storage instance with revision', () async {
    final now = DateTime(2026, 9, 13, 20, 0);
    final firstStorage = NoteStorage();

    await firstStorage.saveNotes([
      Note(
        id: 'note-1',
        title: 'Doctor Visit',
        content: 'Bring the blood pressure log.',
        createdAt: now,
        updatedAt: now,
        revision: 3,
      ),
    ]);

    final secondStorage = NoteStorage();
    final notes = await secondStorage.loadNotes();

    expect(notes, hasLength(1));
    expect(notes.single.id, 'note-1');
    expect(notes.single.title, 'Doctor Visit');
    expect(notes.single.content, contains('blood pressure'));
    expect(notes.single.revision, 3);
  });

  test('legacy saved note without revision defaults to revision 1', () async {
    final now = DateTime(2026, 9, 13, 20, 0);
    SharedPreferences.setMockInitialValues(<String, Object>{
      'doctab_notes_v1':
          '[{"id":"legacy","title":"Legacy","content":"Old data","createdAt":"${now.toIso8601String()}","updatedAt":"${now.toIso8601String()}"}]',
    });

    final notes = await NoteStorage().loadNotes();

    expect(notes, hasLength(1));
    expect(notes.single.id, 'legacy');
    expect(notes.single.revision, 1);
  });
}
