import 'package:doctab/models/note.dart';
import 'package:doctab/services/note_controller.dart';
import 'package:doctab/storage/note_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  test('direct note edit increments revision', () async {
    final now = DateTime(2026, 9, 14, 9, 0);
    final storage = NoteStorage();
    final controller = NoteController(storage: storage);

    await controller.add(
      Note(
        id: 'synthetic-note',
        title: 'Synthetic',
        content: 'Original',
        createdAt: now,
        updatedAt: now,
      ),
    );

    final current = controller.notes.single;
    final persisted = await controller.update(
      current.copyWith(content: 'Edited in DocTab'),
    );

    expect(persisted.revision, 2);
    expect(controller.notes.single.content, 'Edited in DocTab');
    expect(controller.notes.single.revision, 2);
  });

  test('stale edit cannot overwrite newer note revision', () async {
    final now = DateTime(2026, 9, 14, 9, 0);
    final storage = NoteStorage();
    final controller = NoteController(storage: storage);

    await controller.add(
      Note(
        id: 'synthetic-note',
        title: 'Synthetic',
        content: 'Original',
        createdAt: now,
        updatedAt: now,
      ),
    );

    final staleProposal = controller.notes.single.copyWith(
      content: 'Older Kate proposal',
    );

    await controller.update(
      controller.notes.single.copyWith(content: 'Newer direct edit'),
    );

    expect(
      () => controller.update(staleProposal),
      throwsA(
        isA<NoteConflictException>()
            .having((error) => error.expectedRevision, 'expectedRevision', 1)
            .having((error) => error.actualRevision, 'actualRevision', 2),
      ),
    );

    expect(controller.notes.single.content, 'Newer direct edit');
    expect(controller.notes.single.revision, 2);
  });
}
