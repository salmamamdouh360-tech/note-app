import 'package:flutter/material.dart';
import 'package:note_app/model/note_model.dart';

import '../theme.dart';

class CategoryTile extends StatelessWidget {
  final NoteCategory category;
  final bool selected;
  final VoidCallback onTap;
  const CategoryTile(
    this.category, {
    super.key,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: selected ? category.color : AppColors.field,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: selected ? Colors.white : category.color,
            child: Icon(
              category.icon,
              size: 16,
              color: selected ? category.color : Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            category.label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    ),
  );
}
