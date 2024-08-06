import 'package:flutter/material.dart';

Future<String?> showSaveFileDialog(BuildContext context) async {
  final TextEditingController _fileNameController = TextEditingController();
  String? fileName;

  return showDialog<String>(
    context: context,
    barrierDismissible: false, // User must tap a button to dismiss the dialog
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Save File'),
        content: TextField(
          controller: _fileNameController,
          decoration: InputDecoration(
            labelText: 'File Name',
            hintText: 'Enter file name',
          ),
          autofocus: true,
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog without a result
            },
          ),
          TextButton(
            child: Text('Save'),
            onPressed: () {
              fileName = _fileNameController.text;
              Navigator.of(context).pop(fileName); // Return the file name
            },
          ),
        ],
      );
    },
  );
}
