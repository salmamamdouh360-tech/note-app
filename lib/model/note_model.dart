// class NoteModel {
//   final String description;
//   final String title;
//   final int? id;
//   NoteModel({this.id, required this.description, required this.title});
//   Map<String, dynamic> toMap() {
//     return {'id': id, 'title': title, 'description': description};
//   }

//   factory NoteModel.fromMap(Map<String, dynamic> map) {
//     return NoteModel(
//       id: map['id'],
//       title: map['title'],
//       description: map['description'],
//     );
//   }
// }
import 'package:flutter/material.dart';

enum NoteCategory {
  all('All Notes', Icons.description, Color(0xFF8E8E93), Colors.white),
  favourites('Favourites', Icons.star, Color(0xFFFF9F0A), Color(0xFFFFF4CC)),
  hidden('Hidden', Icons.visibility_off, Color(0xFF0A84FF), Color(0xFFE3EEFF)),
  trash('Trash', Icons.delete, Color(0xFFFF3B30), Color(0xFFFFE3E1));

  const NoteCategory(this.label, this.icon, this.color, this.tint);
  final String label;
  final IconData icon;
  final Color color, tint;
}

class Note {
  final int? id;
  final String title, description, date;
  final NoteCategory category;

  const Note({
    this.id,
    required this.title,
    required this.description,
    this.category = NoteCategory.all,
    this.date = '',
  });

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'title': title,
    'description': description,
    'category': category.index,
    'date': date,
  };

  factory Note.fromMap(Map<String, dynamic> m) => Note(
    id: m['id'] as int,
    title: m['title'] as String,
    description: m['description'] as String,
    category: NoteCategory.values[m['category'] as int],
    date: m['date'] as String,
  );
  Note copyWith({
    String? title,
    String? description,
    NoteCategory? category,
    String? date,
  }) => Note(
    id: id,
    title: title ?? this.title,
    description: description ?? this.description,
    category: category ?? this.category,
    date: date ?? this.date,
  );
}
