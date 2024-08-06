import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'note_list_screen.dart';
import 'local_note_storage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var noteStorage = LocalNoteStorage(); // allocate here to the async methods have more time to complete before starting up
    return MaterialApp(
      title: 'Note Taking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
      routes: {
        '/home': (context) => NoteListScreen(noteStorage: noteStorage),
      },
    );
  }
}
