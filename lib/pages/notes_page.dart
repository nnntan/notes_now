import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_now/components/note_settings.dart';
import 'package:provider/provider.dart';
import 'package:notes_now/components/drawer.dart';
import 'package:notes_now/components/note_tile.dart';
import 'package:notes_now/models/note.dart';
import 'package:notes_now/models/note_database.dart';
import 'package:notes_now/pages/edit_note_page.dart';
import 'package:notes_now/theme/theme.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final textController = TextEditingController();

  String searchQuery = ''; // search

  @override
  void initState() {
    super.initState();
    readNote();
  }

  // create
  void createNote() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditNotePage(),
      ),
    );
  }

  // read
  void readNote() {
    context.read<NoteDatabase>().fetchNotes();
  }

  // update
  void updateNote(Note note) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditNotePage(note: note),
      ),
    );
  }

  // delete
  void deleteNote(int id) async {
    bool? shouldDelete = await confirmDialog(context);

    if (shouldDelete ?? false) {
      // ignore: use_build_context_synchronously
      context.read<NoteDatabase>().deleteNote(id);
      readNote();
    }
  }

  void searchNotes(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    // note database
    final noteDatabase = context.watch<NoteDatabase>();

    // current notes
    List<Note> currentNotes = noteDatabase.currentNotes;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      endDrawer: const MyDrawer(),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Heading
              Padding(
                padding:
                    const EdgeInsets.only(left: 25.0, top: 20.0, right: 25.0),
                child: Text(
                  'Notes',
                  style: GoogleFonts.dmSerifText(
                      fontSize: 40,
                      color: Theme.of(context).colorScheme.inversePrimary),
                ),
              ),

              // Search TextField
              const SizedBox(
                height: 30,
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: SizedBox(
                      width: 375,
                      child: TextField(
                        onChanged: (query) {
                          searchNotes(query);
                        },
                        style: TextStyle(
                          fontSize: 16,
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.black
                                  : Colors.white,
                        ),
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 12),
                          hintText: "Search...",
                          hintStyle: const TextStyle(color: Colors.grey),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          fillColor:
                              Theme.of(context).brightness == Brightness.light
                                  ? lightMode.colorScheme.background
                                  : darkMode.colorScheme.background,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )),

              const SizedBox(
                height: 40,
              ),
              // List of note
              Expanded(
                child: ListView.builder(
                    itemCount: currentNotes.length,
                    itemBuilder: (context, index) {
                      final note = currentNotes[index];

                      bool matchesSearch = note.text.contains(searchQuery);

                      // list tile UI
                      if (searchQuery.isEmpty || matchesSearch) {
                        return NoteTile(
                          text: note.text,
                          lastModified: DateTime.now(),
                          onEditPressed: () => updateNote(note),
                          onDeletePressed: () => deleteNote(note.id),
                          onTap: () => updateNote(note),
                          noteSettings: NoteSettings(
                            onDeletePressed: () => deleteNote(note.id),
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.grey.withOpacity(0.3),
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0, bottom: 20),
                    child: FloatingActionButton(
                      onPressed: createNote,
                      backgroundColor: Colors.grey.withOpacity(0.3),
                      mini: true,
                      child: Icon(Icons.add,
                          color: Theme.of(context).colorScheme.inversePrimary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool?> confirmDialog(BuildContext context) async {
    return showDialog<bool?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey.withOpacity(0.5),
          icon: Icon(
            Icons.info,
            color: Colors.grey.shade300,
          ),
          title: const Text(
            'This note will be deleted. This action cannot be undone.',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context, true);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.red.withOpacity(0.8)), //red shade 900
                child: const SizedBox(
                  width: 60,
                  child: Text(
                    'Delete',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.8)), // white
                child: SizedBox(
                  width: 60,
                  child: Text(
                    'Cancel',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
