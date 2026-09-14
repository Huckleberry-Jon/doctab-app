import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/memory_item.dart';

class MemoryStorage {
  static const String _key = 'doctab_memory_v1';

  Future<List<MemoryItem>> loadMemories() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return <MemoryItem>[];

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map(
          (item) => MemoryItem.fromJson(
            Map<String, Object?>.from(item as Map<dynamic, dynamic>),
          ),
        )
        .toList();
  }

  Future<void> saveMemories(List<MemoryItem> memories) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(
      memories.map((memory) => memory.toJson()).toList(growable: false),
    );
    await prefs.setString(_key, encoded);
  }
}
