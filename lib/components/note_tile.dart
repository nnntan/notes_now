import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_now/components/note_settings.dart';

class NoteTile extends StatelessWidget {
  final String text;
  final DateTime lastModified;
  final void Function()? onEditPressed;
  final void Function()? onDeletePressed;
  final void Function()? onTap;
  final NoteSettings noteSettings;

  const NoteTile({
    super.key,
    required this.text,
    required this.lastModified,
    required this.onEditPressed,
    required this.onDeletePressed,
    required this.onTap,
    required this.noteSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(top: 10, left: 25, right: 25),
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 10),
            Text(
              DateFormat.yMMMMd().format(lastModified),
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        onLongPress: onEditPressed,
        onTap: onTap,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            noteSettings,
          ],
        ),
      ),
    );
  }
}
