import 'package:flutter/material.dart';

import 'models/note.dart';
import 'screens/add_note_screen.dart';
import 'screens/memory_screen.dart';
import 'screens/notes_screen.dart';
import 'screens/search_screen.dart';
import 'screens/today_screen.dart';
import 'services/memory_controller.dart';
import 'services/note_controller.dart';
import 'services/reminder_controller.dart';
import 'theme/doctab_theme.dart';

void main() {
  runApp(const DocTabApp());
}

class DocTabApp extends StatefulWidget {
  const DocTabApp({super.key});

  @override
  State<DocTabApp> createState() => _DocTabAppState();
}

class _DocTabAppState extends State<DocTabApp> {
  final NoteController _notes = NoteController();
  final ReminderController _reminders = ReminderController();
  final MemoryController _memory = MemoryController();

  @override
  void initState() {
    super.initState();
    _notes.load();
    _reminders.load();
    _memory.load();
  }

  @override
  void dispose() {
    _notes.dispose();
    _reminders.dispose();
    _memory.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DocTab',
      debugShowCheckedModeBanner: false,
      theme: DocTabTheme.light(),
      home: HomeScreen(
        noteController: _notes,
        reminderController: _reminders,
        memoryController: _memory,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.noteController,
    required this.reminderController,
    required this.memoryController,
  });

  final NoteController noteController;
  final ReminderController reminderController;
  final MemoryController memoryController;

  Future<void> _addNote(BuildContext context) async {
    final note = await Navigator.push<Note>(
      context,
      MaterialPageRoute(builder: (_) => const AddNoteScreen()),
    );
    if (note != null) {
      await noteController.add(note);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DocTab')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your day. Your notes. Your reminders. One place.',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: DocTabTheme.ink,
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                'What do you need to remember?',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: DocTabTheme.ink.withValues(alpha: 0.72),
                    ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.08,
                  children: [
                    _HomeCard(
                      icon: Icons.today_outlined,
                      label: 'Today',
                      subtitle: 'Reminders and tasks',
                      background: DocTabTheme.sage,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TodayScreen(
                              controller: reminderController,
                            ),
                          ),
                        );
                      },
                    ),
                    _HomeCard(
                      icon: Icons.notes_outlined,
                      label: 'Notes',
                      subtitle: 'Save what matters',
                      background: Colors.white,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => NotesScreen(
                              controller: noteController,
                            ),
                          ),
                        );
                      },
                    ),
                    _HomeCard(
                      icon: Icons.psychology_outlined,
                      label: 'Memory',
                      subtitle: 'Things to remember long-term',
                      background: DocTabTheme.sand,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MemoryScreen(
                              controller: memoryController,
                            ),
                          ),
                        );
                      },
                    ),
                    _HomeCard(
                      icon: Icons.add_circle_outline,
                      label: 'Add',
                      subtitle: 'Create a quick note',
                      background: Colors.white,
                      onTap: () => _addNote(context),
                    ),
                    _HomeCard(
                      icon: Icons.search,
                      label: 'Search',
                      subtitle: 'Find saved notes',
                      background: DocTabTheme.sage,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SearchScreen(
                              controller: noteController,
                            ),
                          ),
                        );
                      },
                    ),
                    const _HomeCard(
                      icon: Icons.settings_outlined,
                      label: 'Settings',
                      subtitle: 'Privacy and preferences',
                      background: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeCard extends StatelessWidget {
  const _HomeCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.background,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final Color background;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: background,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 38, color: DocTabTheme.ink),
              const SizedBox(height: 12),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: DocTabTheme.ink,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: DocTabTheme.ink.withValues(alpha: 0.68),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
