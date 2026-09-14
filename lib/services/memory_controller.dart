import 'package:flutter/foundation.dart';

import '../models/memory_item.dart';
import '../storage/memory_storage.dart';

class MemoryController extends ChangeNotifier {
  MemoryController({MemoryStorage? storage}) : _storage = storage ?? MemoryStorage();

  final MemoryStorage _storage;
  final List<MemoryItem> _memories = <MemoryItem>[];
  bool _loaded = false;

  List<MemoryItem> get memories => List.unmodifiable(_memories);
  bool get loaded => _loaded;

  Future<void> load() async {
    _memories
      ..clear()
      ..addAll(await _storage.loadMemories());
    _sort();
    _loaded = true;
    notifyListeners();
  }

  Future<void> add(MemoryItem memory) async {
    _memories.add(memory);
    await _persist();
  }

  Future<void> update(MemoryItem updated) async {
    final index = _memories.indexWhere((item) => item.id == updated.id);
    if (index == -1) return;
    _memories[index] = updated;
    await _persist();
  }

  Future<void> delete(String id) async {
    _memories.removeWhere((item) => item.id == id);
    await _persist();
  }

  List<MemoryItem> search(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return memories;

    return _memories.where((memory) {
      return memory.title.toLowerCase().contains(normalized) ||
          memory.details.toLowerCase().contains(normalized) ||
          memory.category.toLowerCase().contains(normalized);
    }).toList(growable: false);
  }

  Future<void> _persist() async {
    _sort();
    await _storage.saveMemories(_memories);
    notifyListeners();
  }

  void _sort() {
    _memories.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }
}
