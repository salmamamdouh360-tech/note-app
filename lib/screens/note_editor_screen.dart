import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/cubit/note_cubit.dart';
import 'package:note_app/model/note_model.dart';

class NoteEditorScreen extends StatefulWidget {
  final Note? note; // null = نوت جديدة
  const NoteEditorScreen({super.key, this.note});
  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  late final _title = TextEditingController(text: widget.note?.title);
  late final _body = TextEditingController(text: widget.note?.description);
  late NoteCategory _category = widget.note?.category ?? NoteCategory.all;
  FontWeight _weight = FontWeight.w400;

  void _save() {
    if (_title.text.trim().isNotEmpty || _body.text.trim().isNotEmpty) {
      context.read<NoteCubit>().saveNote(
        Note(
          id: widget.note?.id,
          title: _title.text,
          description: _body.text,
          category: _category,
        ),
      );
    }
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Back'),
      ),
      leadingWidth: 72,
      actions: [
        PopupMenuButton<FontWeight>(
          icon: const Icon(Icons.text_format),
          onSelected: (w) => setState(() => _weight = w),
          itemBuilder: (_) => const [
            PopupMenuItem(value: FontWeight.w300, child: Text('Light')),
            PopupMenuItem(value: FontWeight.w400, child: Text('Regular')),
            PopupMenuItem(value: FontWeight.w600, child: Text('SemiBold')),
            PopupMenuItem(value: FontWeight.w700, child: Text('Bold')),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: FilledButton(
            onPressed: _save,
            style: FilledButton.styleFrom(minimumSize: const Size(64, 32)),
            child: const Text('Save'),
          ),
        ),
      ],
    ),
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _title,
            decoration: const InputDecoration.collapsed(hintText: 'Page Title'),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              for (final c in NoteCategory.values)
                ChoiceChip(
                  label: Text(c.label),
                  selected: c == _category,
                  onSelected: (_) => setState(() => _category = c),
                ),
            ],
          ),
          const Divider(height: 24),
          Expanded(
            child: TextField(
              controller: _body,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              style: TextStyle(fontWeight: _weight),
              decoration: const InputDecoration.collapsed(
                hintText: 'Start writing...',
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
