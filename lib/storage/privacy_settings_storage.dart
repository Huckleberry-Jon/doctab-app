import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/privacy_settings.dart';

class PrivacySettingsStorage {
  static const String _key = 'doctab_privacy_settings_v1';

  Future<PrivacySettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) {
      return const PrivacySettings();
    }
    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      return const PrivacySettings();
    }
    return PrivacySettings.fromJson(decoded);
  }

  Future<void> save(PrivacySettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(settings.toJson()));
  }
}