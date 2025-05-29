import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:notes_now/models/note.dart';

class NoteDatabase extends ChangeNotifier {
  static late Isar isar;
// INITIALIZE

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([NoteSchema], directory: dir.path);
  }

// list of notes
  final List<Note> currentNotes = [];

// CREATE

// create new note
  Future<void> addNote(String text) async {
    final newNote = Note()
      ..text = text
      ..lastModified = DateTime.now();
    // save to db
    await isar.writeTxn(() => isar.notes.put(newNote));
    // read
    await fetchNotes();
  }

// READ

  Future<void> fetchNotes() async {
    List<Note> fetchedNotes = await isar.notes.where().findAll();
    currentNotes.clear();
    currentNotes.addAll(fetchedNotes);
    notifyListeners();
  }

// UPDATE

  Future<void> updateNote(Note note, String newText) async {
    note.text = newText;
    note.lastModified = DateTime.now();
    await isar.writeTxn(() => isar.notes.put(note));
    await fetchNotes();
  }

// DELETE

  Future<void> deleteNote(int id) async {
    await isar.writeTxn(() => isar.notes.delete(id));
    await fetchNotes();
  }
}
