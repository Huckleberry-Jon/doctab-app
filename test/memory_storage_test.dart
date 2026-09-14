import 'package:doctab/models/memory_item.dart';
import 'package:doctab/storage/memory_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  test('memory storage persists and reloads saved memories', () async {
    final storage = MemoryStorage();
    final createdAt = DateTime(2026, 9, 13, 10, 30);
    final memory = MemoryItem(
      id: 'memory-1',
      title: 'Gate code',
      details: 'The side gate code is 2468.',
      category: 'Important details',
      createdAt: createdAt,
      updatedAt: createdAt,
    );

    await storage.saveMemories(<MemoryItem>[memory]);
    final loaded = await storage.loadMemories();

    expect(loaded, hasLength(1));
    expect(loaded.single.id, 'memory-1');
    expect(loaded.single.title, 'Gate code');
    expect(loaded.single.details, 'The side gate code is 2468.');
    expect(loaded.single.category, 'Important details');
  });
}
