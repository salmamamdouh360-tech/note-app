import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/cubit/cubit_state.dart';
import 'package:note_app/database_helper.dart';
import 'package:note_app/model/note_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/database_helper.dart';
import 'package:note_app/model/event_model.dart';

class NoteCubit extends Cubit<CubitState> {
  NoteCubit() : super(NoteInitial());

  String get _today {
    final d = DateTime.now();
    return '${d.day}/${d.month}/${d.year}';
  }

  Future<void> loadNotes() async {
    try {
      emit(NoteLoaded(await DatabaseHelper.getNotes()));
    } catch (e) {
      emit(NoteFailure(messege: '$e'));
    }
  }

  Future<void> _run(Future<void> Function() action) async {
    try {
      await action();
      await loadNotes(); // الليست بتتحدث لوحدها بعد أي تغيير
    } catch (e) {
      emit(NoteFailure(messege: '$e'));
    }
  }

  Future<void> saveNote(Note note) {
    final n = note.copyWith(date: _today);
    return _run(
      () => n.id == null
          ? DatabaseHelper.insertNote(n)
          : DatabaseHelper.updateNote(n),
    );
  }

  Future<void> moveToTrash(Note note) => _run(
    () =>
        DatabaseHelper.updateNote(note.copyWith(category: NoteCategory.trash)),
  );

  Future<void> removeNote(int id) => _run(() => DatabaseHelper.deleteNote(id));
}

class EventCubit extends Cubit<List<Event>> {
  EventCubit() : super(const []);

  Future<void> load() async => emit(await DatabaseHelper.getEvents());

  Future<void> add(Event e) async {
    await DatabaseHelper.insertEvent(e);
    await load();
  }

  Future<void> remove(int id) async {
    await DatabaseHelper.deleteEvent(id);
    await load();
  }
}
