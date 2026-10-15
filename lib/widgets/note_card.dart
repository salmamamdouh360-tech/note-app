import 'package:flutter/material.dart';
import 'package:note_app/model/note_model.dart';

import '../theme.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final Color tint;
  const NoteCard(this.note, {super.key, this.tint = Colors.white});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: tint,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          note.title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Expanded(
          child: Text(
            note.description,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, color: AppColors.grey),
          ),
        ),
        Text(
          note.title,
          style: const TextStyle(fontSize: 10, color: AppColors.grey),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(.12),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Text(
            'Important',
            style: TextStyle(fontSize: 10, color: AppColors.primary),
          ),
        ),
      ],
    ),
  );
}
