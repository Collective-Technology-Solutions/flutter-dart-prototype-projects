import 'note.dart';

abstract class NoteStorage {
  String prepareFileName(String aFileName );
  Future<void> save(Note note);
  // Future<Note?> load(String title);
  Future<List<Note>> list();
  Future<void> delete(String title);
}
