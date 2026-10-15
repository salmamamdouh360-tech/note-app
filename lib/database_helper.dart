import 'package:note_app/model/event_model.dart';
import 'package:note_app/model/note_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async =>
      _database ??= await _initDatabase();

  static Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'notes.DB');
    return openDatabase(
      path,
      version: 3,
      onCreate: (db, _) async {
        await db.execute('''
          CREATE TABLE notes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            description TEXT NOT NULL,
            category INTEGER NOT NULL DEFAULT 0,
            date TEXT NOT NULL DEFAULT ''
          )
        ''');
        await _createEvents(db);
      },
      onUpgrade: (db, oldVersion, _) async {
        if (oldVersion < 2) {
          await db.execute(
            'ALTER TABLE notes ADD COLUMN category INTEGER NOT NULL DEFAULT 0',
          );
          await db.execute(
            "ALTER TABLE notes ADD COLUMN date TEXT NOT NULL DEFAULT ''",
          );
        }
        if (oldVersion < 3) await _createEvents(db);
      },
    );
  }

  static Future<void> _createEvents(Database db) => db.execute('''
    CREATE TABLE events (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      description TEXT NOT NULL DEFAULT '',
      date TEXT NOT NULL,
      time TEXT NOT NULL
    )
  ''');

  // ---------- Notes ----------
  static Future<int> insertNote(Note note) async =>
      (await database).insert('notes', note.toMap());

  static Future<List<Note>> getNotes() async => (await (await database).query(
    'notes',
    orderBy: 'id DESC',
  )).map(Note.fromMap).toList();

  static Future<int> updateNote(Note note) async => (await database).update(
    'notes',
    note.toMap(),
    where: 'id = ?',
    whereArgs: [note.id],
  );

  static Future<int> deleteNote(int id) async =>
      (await database).delete('notes', where: 'id = ?', whereArgs: [id]);

  // ---------- Events ----------
  static Future<int> insertEvent(Event e) async =>
      (await database).insert('events', e.toMap());

  static Future<List<Event>> getEvents() async => (await (await database).query(
    'events',
    orderBy: 'date, time',
  )).map(Event.fromMap).toList();

  static Future<int> deleteEvent(int id) async =>
      (await database).delete('events', where: 'id = ?', whereArgs: [id]);
}
