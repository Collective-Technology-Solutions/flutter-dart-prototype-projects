// note_list_screen.dart
import 'package:flutter/material.dart';
import 'note_storage.dart';
import 'note_editor_screen.dart';
import 'note.dart';

class NoteListScreen extends StatefulWidget {
  final NoteStorage noteStorage;

  NoteListScreen({required this.noteStorage});

  @override
  _NoteListScreenState createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  late Future<List<Note>> _notesFuture;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    setState(() {
      _notesFuture = widget.noteStorage.list();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notes')),
      body: FutureBuilder<List<Note>>(
        future: _notesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No notes available.'));
          }

          final notes = snapshot.data!;

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final Note note = notes[index];
              return ListTile(
                title: Text('${note.toName()}'),
                subtitle: Text('${note.timestamp}'),
                onTap: () async {
                  // Navigate to NoteEditorScreen with the full note content
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NoteEditorScreen(
                        note: note,
                        noteStorage: widget.noteStorage,
                      ),
                    ),
                  ).then((_) {
                    _loadNotes(); // Reload notes after returning from the editor
                  });
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteEditorScreen(
                note: Note(
                  filename: '',
                  content: '',
                  timestamp: DateTime.now(),
                ),
                noteStorage: widget.noteStorage,
              ),
            ),
          ).then((_) {
            _loadNotes(); // Reload notes after returning from the editor
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
