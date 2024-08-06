// note.dart
import 'dart:io';

import 'package:note_taking_app/local_note_storage.dart';

class Note {
  String filename;
  final String content;
  final DateTime timestamp;

  Note({
    required this.filename,
    required this.content,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  String toName() {
    if ( filename == null || filename.isEmpty)
      return "";
    File file = File(filename);
    String f = file.uri.pathSegments.last;
    if  ( f.endsWith( LocalNoteStorage.extension) )
      f = f.replaceRange( f.length-1-LocalNoteStorage.extension.length, f.length, '');
    return f;
  }
}
