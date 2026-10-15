import 'package:flutter/material.dart';
import 'package:note_app/theme.dart';

class SearchField extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  const SearchField({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) => TextField(
    onChanged: onChanged,
    decoration: InputDecoration(
      hintText: 'Search',
      prefixIcon: const Icon(Icons.search, color: AppColors.grey),
      filled: true,
      fillColor: AppColors.field,
      contentPadding: EdgeInsets.zero,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
