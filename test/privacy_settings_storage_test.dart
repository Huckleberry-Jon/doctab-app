import 'package:doctab/models/privacy_settings.dart';
import 'package:doctab/storage/privacy_settings_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  test('privacy settings persist locally', () async {
    final storage = PrivacySettingsStorage();
    const expected = PrivacySettings(
      aiAccessEnabled: true,
      allowNotes: true,
      allowReminders: false,
      allowMemory: true,
    );

    await storage.save(expected);
    final loaded = await storage.load();

    expect(loaded.aiAccessEnabled, isTrue);
    expect(loaded.allowNotes, isTrue);
    expect(loaded.allowReminders, isFalse);
    expect(loaded.allowMemory, isTrue);
  });
}