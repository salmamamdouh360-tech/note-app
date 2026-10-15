import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/cubit/cubit_state.dart';
import 'package:note_app/cubit/note_cubit.dart';
import 'package:note_app/model/note_model.dart';
import 'package:note_app/screens/note_editor_screen.dart';
import 'package:note_app/widgets/category_tile.dart';
import 'package:note_app/widgets/note_card.dart';
import 'package:note_app/widgets/search_field.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NoteCategory _selected = NoteCategory.all;
  String _query = '';

  bool _matches(Note n) {
    final inCategory = _selected == NoteCategory.all
        ? n.category != NoteCategory.hidden && n.category != NoteCategory.trash
        : n.category == _selected;
    final inSearch =
        n.title.toLowerCase().contains(_query) ||
        n.description.toLowerCase().contains(_query);
    return inCategory && inSearch;
  }

  void _delete(Note n) {
    final cubit = context.read<NoteCubit>();
    _selected == NoteCategory.trash
        ? cubit.removeNote(n.id!)
        : cubit.moveToTrash(n);
  }

  @override
  Widget build(BuildContext context) {
    final isAll = _selected == NoteCategory.all;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Notes',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SearchField(
            onChanged: (v) => setState(() => _query = v.trim().toLowerCase()),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 3.2,
            children: [
              for (final c in NoteCategory.values)
                CategoryTile(
                  c,
                  selected: c == _selected,
                  onTap: () => setState(() => _selected = c),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            isAll ? 'Recent Notes' : _selected.label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          BlocBuilder<NoteCubit, CubitState>(
            builder: (context, state) {
              if (state is NoteFailure) return Text(state.messege);
              if (state is! NoteLoaded) {
                return const Center(child: CircularProgressIndicator());
              }
              final shown = state.notes.where(_matches).toList();
              if (shown.isEmpty) return const Text('No notes here');

              return GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: [
                  for (final n in shown)
                    Dismissible(
                      key: ValueKey(n.id),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) => _delete(n),
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16),
                        decoration: BoxDecoration(
                          color: NoteCategory.trash.color,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => NoteEditorScreen(note: n),
                          ),
                        ),
                        child: NoteCard(n, tint: _selected.tint),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
