import 'package:note_app/model/note_model.dart';

abstract class CubitState {}

class NoteInitial extends CubitState {}

class NoteLoading extends CubitState {}

class NoteSuccess extends CubitState {}

class NoteLoaded extends CubitState {
  final List<Note> notes;
  NoteLoaded(this.notes);
}

class NoteFailure extends CubitState {
  final String messege;
  NoteFailure({required this.messege});
}
