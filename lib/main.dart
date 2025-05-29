import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:notes_now/models/note_database.dart';
import 'package:notes_now/pages/notes_page.dart';
import 'package:notes_now/theme/theme_provider.dart';

void main() async {
  // initialize note isar database
  WidgetsFlutterBinding.ensureInitialized();
  await NoteDatabase.initialize();

  runApp(
    MultiProvider(
      providers: [
        // Note provider
        ChangeNotifierProvider(create: (context) => NoteDatabase()),
        // Theme provider
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const NotesPage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
