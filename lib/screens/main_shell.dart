import 'package:flutter/material.dart';
import 'events_screen.dart';
import 'home_screen.dart';
import 'note_editor_screen.dart';
import 'search_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;
  static const _screens = [HomeScreen(), EventsScreen(), SearchScreen()];

  void _onTap(int i) {
    if (i == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const NoteEditorScreen()),
      );
    } else {
      setState(() => _index = i);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: IndexedStack(index: _index, children: _screens),
    bottomNavigationBar: NavigationBar(
      selectedIndex: _index,
      onDestinationSelected: _onTap,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.description_outlined),
          label: 'Notes',
        ),
        NavigationDestination(icon: Icon(Icons.event_outlined), label: 'Event'),
        NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
        NavigationDestination(
          icon: Icon(Icons.add_circle_outline),
          label: 'Create Note',
        ),
      ],
    ),
  );
}
