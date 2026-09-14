import 'package:flutter/foundation.dart';

import '../models/privacy_settings.dart';
import '../storage/privacy_settings_storage.dart';

class PrivacySettingsController extends ChangeNotifier {
  PrivacySettingsController({PrivacySettingsStorage? storage})
      : _storage = storage ?? PrivacySettingsStorage();

  final PrivacySettingsStorage _storage;
  PrivacySettings _settings = const PrivacySettings();
  bool _loaded = false;

  PrivacySettings get settings => _settings;
  bool get loaded => _loaded;

  Future<void> load() async {
    _settings = await _storage.load();
    _loaded = true;
    notifyListeners();
  }

  Future<void> setAiAccess(bool enabled) async {
    _settings = _settings.copyWith(
      aiAccessEnabled: enabled,
      allowNotes: enabled ? _settings.allowNotes : false,
      allowReminders: enabled ? _settings.allowReminders : false,
      allowMemory: enabled ? _settings.allowMemory : false,
    );
    await _save();
  }

  Future<void> setNotesAccess(bool enabled) async {
    _settings = _settings.copyWith(allowNotes: enabled);
    await _save();
  }

  Future<void> setRemindersAccess(bool enabled) async {
    _settings = _settings.copyWith(allowReminders: enabled);
    await _save();
  }

  Future<void> setMemoryAccess(bool enabled) async {
    _settings = _settings.copyWith(allowMemory: enabled);
    await _save();
  }

  Future<void> _save() async {
    await _storage.save(_settings);
    notifyListeners();
  }
}