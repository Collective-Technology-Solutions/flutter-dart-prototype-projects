// note_editor_screen.dart
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:note_taking_app/show_save_file_dialog.dart';
import 'package:note_taking_app/show_unsaved_changes_dialog.dart';

import 'note.dart';
import 'note_storage.dart';

class NoteEditorScreen extends StatefulWidget {
  final Note note;
  final NoteStorage noteStorage;

  NoteEditorScreen({required this.note, required this.noteStorage});

  @override
  _NoteEditorScreenState createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  late final TextEditingController _textEditingController;
  late final ScrollController _editorScrollController;
  late final ScrollController _previewScrollController;

  double _editorWidth = 300;
  bool _isEditorMaximized = false;
  bool _isRendererMaximized = false;

  String _lastSavedText = "";
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();

    _lastSavedText = widget.note.content; //TODO: has to be a better way
    _editorScrollController = ScrollController();
    _previewScrollController = ScrollController();

    _textEditingController = TextEditingController(text: widget.note.content);

    _textEditingController.addListener(_checkForUnsavedChanges);
    _editorScrollController.addListener(_syncScroll);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _editorScrollController.dispose();
    _previewScrollController.dispose();
    super.dispose();
  }

  void _syncScroll() {
    if (_editorScrollController.hasClients &&
        _previewScrollController.hasClients) {
      _previewScrollController.jumpTo(_editorScrollController.offset);
    }
  }

  void _checkForUnsavedChanges() {
    setState(() {
      _hasUnsavedChanges = hasChanged();
    });
  }

  bool hasChanged() {
    return _textEditingController.text != _lastSavedText;
  }

  void _cancelNote() {
    Navigator.of(context).pop(); // This pops the current screen from the navigation stack
  }

  Future<void> _saveNote() async {
    String? fileName = widget.note.toName();
    if (fileName.isEmpty) {
      fileName = await showSaveFileDialog(context);
      if (fileName == null || fileName.isEmpty)
        return;
      else
        widget.note.filename = fileName;
    }

    final updatedNote = Note(
      filename: widget.note.toName(),
      content: _textEditingController.text,
      timestamp: widget.note.timestamp,
    );
    await widget.noteStorage.save(updatedNote);
    setState(() {
      _lastSavedText =
          _textEditingController.text; //TODO: has to be a better way
      _hasUnsavedChanges = false;
    }); // Trigger a rebuild to update the Markdown view
  }

  void _toggleEditorMaximized() {
    setState(() {
      _isEditorMaximized = !_isEditorMaximized;
      if (_isEditorMaximized) {
        _isRendererMaximized = false;
        _editorWidth = MediaQuery.of(context).size.width;
      } else {
        // _editorWidth = 300.0; // Default width
        final double windowWidth = MediaQuery.of(context).size.width;
        _editorWidth = windowWidth > 300 ? (windowWidth / 2) : 300;
      }
    });
  }

  void _toggleRendererMaximized() {
    setState(() {
      _isRendererMaximized = !_isRendererMaximized;
      if (_isRendererMaximized) {
        _isEditorMaximized = false;
        _editorWidth = 0.0; // Hide editor
      } else {
        // _editorWidth = 300.0; // Default width
        final double windowWidth = MediaQuery.of(context).size.width;
        _editorWidth = windowWidth > 300 ? (windowWidth / 2) : 300;
      }
    });
  }

  Future<bool> _onWillPop() async {
    if (_hasUnsavedChanges) {
      final result = await showUnsavedChangesDialog(context);
      if (result == true) {
        return true; // Discard changes and exit
      } else if (result == false) {
        await _saveNote(); // Save changes before exiting
        return false; // Prevent exit until save is complete
      } else {
        return false; // Cancel and stay
      }
    }
    return true; // No unsaved changes, allow exit
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !hasChanged(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Editing Note \'${widget.note.toName()}\''),
          actions: [
            IconButton(
              icon: Icon(_isEditorMaximized
                  ? Icons.close_fullscreen
                  : Icons.open_in_full),
              onPressed: _toggleEditorMaximized,
            ),
            IconButton(
              icon: Icon(_isRendererMaximized
                  ? Icons.close_fullscreen
                  : Icons.open_in_full),
              onPressed: _toggleRendererMaximized,
            ),
            if (_hasUnsavedChanges)
              IconButton(
                icon: Icon(Icons.save),
                onPressed: _saveNote,
                color: Colors.blue,
              ),
            if (_hasUnsavedChanges)
              IconButton(
                icon: Icon(Icons.cancel),
                onPressed: _cancelNote,
                color: Colors.grey,
              )
            else
              SizedBox(width: 50),
            // IconButton(
            // icon: Icon(Icons.save),
            // onPressed: _syncTextChange,
            // ),
            SizedBox(width: 25),
          ],
        ),
        body: Row(
          children: [
            if (!_isRendererMaximized)
              Container(
                width: _editorWidth,
                color: Colors.blueGrey[50],
                child: Column(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textEditingController,
                        scrollController: _editorScrollController,
                        decoration: InputDecoration(
                          hintText: 'Content',
                          border: InputBorder.none,
                        ),
                        maxLines: null,
                        expands: true,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.resizeLeftRight,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          setState(() {
                            _editorWidth += details.delta.dx;
                          });
                        },
                        child: Container(
                          width: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (!_isEditorMaximized && !_isRendererMaximized)
              Container(
                width: 10,
                color: Colors.grey,
              ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: Markdown(
                  data: _textEditingController.text,
                  controller: _previewScrollController,
                  styleSheet: MarkdownStyleSheet(
                    h1: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    h2: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    p: TextStyle(fontSize: 16),
                    // Add other styles as needed
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
