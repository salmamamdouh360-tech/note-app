import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/cubit/cubit_state.dart';
import 'package:note_app/cubit/note_cubit.dart';
import 'package:note_app/model/note_model.dart';
import 'package:note_app/screens/note_editor_screen.dart';
import 'package:note_app/theme.dart';
import 'package:note_app/widgets/search_field.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Notes',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SearchField(
            onChanged: (v) => setState(() => _query = v.trim().toLowerCase()),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: BlocBuilder<NoteCubit, CubitState>(
              builder: (context, state) {
                if (_query.isEmpty || state is! NoteLoaded) {
                  return const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recent Searches',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'No recent searches to display',
                        style: TextStyle(color: AppColors.grey),
                      ),
                    ],
                  );
                }
                final results = state.notes
                    .where(
                      (n) =>
                          n.category != NoteCategory.trash &&
                          (n.title.toLowerCase().contains(_query) ||
                              n.description.toLowerCase().contains(_query)),
                    )
                    .toList();
                if (results.isEmpty) return const Text('No results');

                return ListView.separated(
                  itemCount: results.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) {
                    final n = results[i];
                    return ListTile(
                      tileColor: n.category.tint,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      title: Text(
                        n.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        n.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NoteEditorScreen(note: n),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}
