import 'package:flutter/material.dart';

class NoteSettings extends StatelessWidget {
  final void Function() onDeletePressed;

  const NoteSettings({
    Key? key,
    required this.onDeletePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: Colors.grey),
      onSelected: (value) {
        if (value == 'delete') {
          onDeletePressed();
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem<String>(
            value: 'delete',
            child: SizedBox(
              width: 125,
              height: 50,
              child: ListTile(
                leading: Icon(Icons.delete_outline, color: Colors.red),
                title: Text('Delete Note', style: TextStyle(color: Colors.red)),
              ),
            ),
          ),
        ];
      },
      color: Colors.grey.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      offset: const Offset(17, 40),
    );
  }
}
