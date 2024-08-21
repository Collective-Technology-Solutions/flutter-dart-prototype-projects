import 'package:flutter/material.dart';
import 'package:flutter_persistance_hive/models/user_preferences.dart';
import 'package:flutter_persistance_hive/services/hive_service.dart';

/*
FOCUS ITEMS:
- use of FutureBuilders and async methods
- dispose() for all controllers
- using user preferences to populate and persist values using HiveService
- partially broken up build functions for clarity

NOTES:
- a bit chunk for all the pre-build dependencies to load

 */
class EditPreferencesScreen extends StatefulWidget {
  @override
  _EditPreferencesScreenState createState() => _EditPreferencesScreenState();
}

class _EditPreferencesScreenState extends State<EditPreferencesScreen> {
  late Future<UserPreferences> _userPreferencesFuture;
  late TextEditingController _aliasController;
  late TextEditingController _splashScreenImageIndexController;
  late TextEditingController _bookmarkedViewNamesController;
  List<String> _bookmarkedViewNames = [];
  bool _showSplashScreen = true;
  bool _allowBadHttpsCertificates = false;

  @override
  void initState() {
    super.initState();
    _aliasController = TextEditingController();
    _splashScreenImageIndexController = TextEditingController();
    _bookmarkedViewNamesController = TextEditingController();
    _userPreferencesFuture = _loadPreferences();
  }

  Future<UserPreferences> _loadPreferences() async {
    try {
      var hiveService = HiveService();
      var preferences = await hiveService.getUserPreferences();

      _aliasController.text = preferences.alias;
      _splashScreenImageIndexController.text =
          preferences.splashScreenImageIndex.toString();
      _bookmarkedViewNames = List.from(preferences.bookmarkedViewNames);
      _bookmarkedViewNamesController.text = _bookmarkedViewNames.join(', ');
      _showSplashScreen = preferences.showSplashScreen;
      _allowBadHttpsCertificates = preferences.allowBadHttpsCertificates;

      return preferences;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error loading preferences: $e'),
        backgroundColor: Colors.red,
      ));
      return UserPreferences(
        alias: '',
        bookmarkedViewNames: [],
        showSplashScreen: true,
        splashScreenImageIndex: 1,
        allowBadHttpsCertificates: false,
      );
    }
  }

  Future<void> _savePreferences() async {
    int splashScreenImageIndex =
        int.tryParse(_splashScreenImageIndexController.text) ?? 1;
    if (splashScreenImageIndex < 1 || splashScreenImageIndex > 4) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Splash screen image index must be between 1 and 4'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    try {
      var hiveService = HiveService();
      var updatedPreferences = await _userPreferencesFuture;
      updatedPreferences = updatedPreferences.copyWith(
        alias: _aliasController.text,
        bookmarkedViewNames: _bookmarkedViewNames,
        showSplashScreen: _showSplashScreen,
        splashScreenImageIndex: splashScreenImageIndex,
        allowBadHttpsCertificates: _allowBadHttpsCertificates,
      );

      await hiveService.saveUserPreferences(updatedPreferences);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Preferences saved'),
      ));
      Navigator.pop(
          context, true); // Pass true to indicate preferences were updated
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error saving preferences: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Widget _buildPreferencesForm(UserPreferences userPreferences) {
    return ListView(
      children: [
        TextField(
          controller: _aliasController,
          decoration: InputDecoration(labelText: 'Alias'),
        ),
        TextField(
          controller: _bookmarkedViewNamesController,
          decoration: InputDecoration(
              labelText: 'Bookmarked View Names (comma-separated)'),
          onChanged: (value) {
            setState(() {
              _bookmarkedViewNames =
                  value.split(',').map((e) => e.trim()).toList();
            });
          },
        ),
        Row(
          children: [
            SizedBox(height: 20),
            Text(
              'Splash Screen Image Index (1-4)',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Slider(
              value:
                  double.tryParse(_splashScreenImageIndexController.text) ?? 1,
              min: 1,
              max: 4,
              divisions: 3,
              label: _splashScreenImageIndexController.text,
              onChanged: (double value) {
                setState(() {
                  _splashScreenImageIndexController.text =
                      value.toInt().toString();
                });
              },
            ),
            SizedBox(height: 20),
            Expanded(
              child: SwitchListTile(
                title: Text('Show Splash Screen'),
                value: _showSplashScreen,
                onChanged: (bool value) {
                  setState(() {
                    _showSplashScreen = value;
                  });
                },
              ),
            ),
            Expanded(
              child: SwitchListTile(
                title: Text('Allow Bad HTTPS Certificates'),
                value: _allowBadHttpsCertificates,
                onChanged: (bool value) {
                  setState(() {
                    _allowBadHttpsCertificates = value;
                  });
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _savePreferences,
          child: Text('Save Preferences'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Preferences'),
      ),
      body: FutureBuilder<UserPreferences>(
        future: _userPreferencesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: _buildPreferencesForm(snapshot.data!),
            );
          } else {
            return Center(
              child: Text('No preferences found.'),
            );
          }
        },
      ),
    );
  }
}
