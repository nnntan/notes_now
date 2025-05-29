import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:notes_now/models/note.dart';
import 'package:notes_now/models/note_database.dart';

class EditNotePage extends StatefulWidget {
  final Note? note;

  const EditNotePage({Key? key, this.note}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.note != null) {
      textController.text = widget.note!.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'New Note' : 'Edit Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: textController,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Type something here...',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Save or update note
                if (widget.note == null) {
                  // Create new note
                  context.read<NoteDatabase>().addNote(textController.text);
                } else {
                  // Updating note
                  context.read<NoteDatabase>().updateNote(
                        widget.note!,
                        textController.text,
                      );
                }

                // Back home
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                widget.note == null ? 'Done' : 'Done',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
