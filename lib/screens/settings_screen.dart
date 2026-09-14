import 'package:flutter/material.dart';

import '../services/privacy_settings_controller.dart';
import '../theme/doctab_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.controller});

  final PrivacySettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final settings = controller.settings;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                'Privacy first',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: DocTabTheme.ink,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'DocTab is the permission boundary. AI can only use information inside DocTab that you explicitly allow.',
                style: TextStyle(
                  color: DocTabTheme.ink.withValues(alpha: 0.75),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              Card(
                color: DocTabTheme.sage,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.shield_outlined, color: DocTabTheme.ink),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Protected boundary',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: DocTabTheme.ink,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Anything outside DocTab stays outside DocTab. These controls do not grant phone-wide access.',
                        style: TextStyle(
                          color: DocTabTheme.ink.withValues(alpha: 0.75),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                color: Colors.white,
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Allow connected AI to use DocTab data'),
                      subtitle: const Text(
                        'Stores your permission preference only. It does not connect Kate yet.',
                      ),
                      value: settings.aiAccessEnabled,
                      onChanged: controller.setAiAccess,
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      title: const Text('Notes'),
                      subtitle: const Text('Allow AI to read approved DocTab notes.'),
                      value: settings.allowNotes,
                      onChanged: settings.aiAccessEnabled
                          ? controller.setNotesAccess
                          : null,
                    ),
                    SwitchListTile(
                      title: const Text('Reminders'),
                      subtitle: const Text('Allow AI to read approved reminders.'),
                      value: settings.allowReminders,
                      onChanged: settings.aiAccessEnabled
                          ? controller.setRemindersAccess
                          : null,
                    ),
                    SwitchListTile(
                      title: const Text('Memory'),
                      subtitle: const Text('Allow AI to read approved long-term memory.'),
                      value: settings.allowMemory,
                      onChanged: settings.aiAccessEnabled
                          ? controller.setMemoryAccess
                          : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Card(
                color: DocTabTheme.sand,
                child: const ListTile(
                  leading: Icon(Icons.verified_user_outlined, color: DocTabTheme.ink),
                  title: Text('AI changes require confirmation'),
                  subtitle: Text(
                    'Protected rule: an AI cannot silently approve its own write or edit.',
                  ),
                  trailing: Icon(Icons.lock_outline, color: DocTabTheme.ink),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                color: Colors.white,
                child: const ListTile(
                  leading: Icon(Icons.phone_android_outlined, color: DocTabTheme.ink),
                  title: Text('Current storage'),
                  subtitle: Text(
                    'Notes, reminders, memory, and these privacy preferences are stored locally on this device in the current V1 build.',
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}