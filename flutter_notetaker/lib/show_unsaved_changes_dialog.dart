import 'package:flutter/material.dart';

Future<bool?> showUnsavedChangesDialog(BuildContext context) async {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false, // User must tap a button to dismiss the dialog
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Unsaved Changes'),
        content: Text('You have unsaved changes. Do you want to save them before exiting?'),
        actions: <Widget>[
          TextButton(
            child: Text('Discard'),
            onPressed: () {
              Navigator.of(context).pop(true); // Discard changes and exit
            },
          ),
          TextButton(
            child: Text('Save'),
            onPressed: () {
              Navigator.of(context).pop(false); // Save changes and exit
            },
          ),
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(null); // Cancel and stay
            },
          ),
        ],
      );
    },
  );
}
