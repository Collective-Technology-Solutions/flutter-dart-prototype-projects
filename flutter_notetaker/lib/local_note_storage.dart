// local_note_storage.dart
import 'package:path_provider/path_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;

import 'dart:io';

import 'note.dart';
import 'note_storage.dart';

class LocalNoteStorage implements NoteStorage {
  static const String extension = "MD";
  late final Directory directory;
  late final String appName;
  late final Directory _directory;

  Future<void>? _initialization;

  LocalNoteStorage() {
    _initialization = _initialize();
  }

  Future<void> _initialize() async {
    try {
      appName = await getApplicationName();
      // print( 'App Name: $appName');
      directory = await getApplicationDocumentsDirectory();
      final directoryPath = p.join(directory.path, appName);
      this._directory = Directory(directoryPath);

      if (!_directory.existsSync()) {
        _directory.createSync(recursive: true);
      }
    } catch (e) {
      print('_initialize: Failed to create directory: $e');
      // Handle the exception as needed
    }
  }

  @override
  Future<List<Note>> list() async {
    try {
      final files = _directory.listSync().whereType<File>();
      final notes = <Note>[];
      for (var file in files) {
        final content = await file.readAsString();
        final fileName = file.uri.pathSegments.last;

        notes.add(Note(
          filename: fileName,
          content: content,
          timestamp: file.lastModifiedSync(),
        ));
      }

      // Sort notes by file modification time (descending) and then by fileName (ascending)
      notes.sort((a, b) {
        int timestampComparison = b.timestamp.compareTo(a.timestamp);
        if (timestampComparison != 0) {
          return timestampComparison;
        }

        // Handle null fileName by treating nulls as greater than non-nulls
        final fileNameA = a.filename ?? '';
        final fileNameB = b.filename ?? '';

        return fileNameA.compareTo(fileNameB);
      });

      return notes;
    } catch (e) {
      print('list: $e');
      return [];
    }
  }

  @override
  Future<void> save(Note note) async {
    final newFile = File('${prepareFileName(note.filename)}');
    await newFile.writeAsString(note.content);
  }

  String prepareFileName(String aFileName) {
    return '${_directory.path}/$aFileName.$extension';
  }

  @override
  Future<void> delete(String filename) async {
    if (!filename.startsWith(_directory.path)) {
      print("Delete called for file on incorrect path: $filename");
      return;
    }

    if (!filename.endsWith(extension)) {
      print("Delete called for file non-matching extension: $filename");
      return;
    }
    final file = File('${_directory.path}/${filename}');
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<void> deleteNode(Note note) async {
    delete(note.filename);
  }

  // Helper function to insert timestamp into content
  String _insertTimestamp(String content, DateTime timestamp) {
    final timestampString = '# ${timestamp.toIso8601String()}: ';
    if (content.startsWith('# ')) {
      return content.replaceFirst('# ', '# $timestampString\n', 0);
    }
    return '$timestampString\n$content';
  }
}

Future<String> getApplicationName() async {
  final PackageInfo info = await PackageInfo.fromPlatform();
  // print( info.toString() );
  return info.appName;
}
