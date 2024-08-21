import 'package:flutter/material.dart';
import 'package:flutter_persistance_hive/models/user_preferences.dart';
import 'package:flutter_persistance_hive/services/hive_service.dart';
import 'package:flutter_persistance_hive/views/edit_preferences_screen.dart';
import 'package:flutter_persistance_hive/views/splash_screen.dart';

/*
FOCUS ITEMS:
- use of Hive managed user preferences, serialize to local file

NOTES:
-

 */
class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late Future<UserPreferences> _userPreferencesFuture;

  @override
  void initState() {
    super.initState();
    _userPreferencesFuture = _loadPreferences();
  }

  Future<UserPreferences> _loadPreferences() async {
    var hiveService = HiveService();
    return await hiveService.getUserPreferences();
  }

  Future<void> _navigateToEditPreferences() async {
    // Navigate to EditPreferencesScreen and wait for it to return
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditPreferencesScreen()),
    );

    // Check the result to see if preferences have been updated
    if (result == true) {
      setState(() {
        _userPreferencesFuture = _loadPreferences();
      });
    }
  }

  Widget _buildPreferencesInfo(UserPreferences userPreferences) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Welcome, ${userPreferences.alias}'),
          SizedBox(height: 8),
          Text('Bookmarked Views: ${userPreferences.bookmarkedViewNames.join(', ')}'),
          SizedBox(height: 8),
          Text('Show Splash Screen: ${userPreferences.showSplashScreen ? 'Yes' : 'No'}'),
          SizedBox(height: 8),
          Text('Splash Screen Image Index: ${userPreferences.splashScreenImageIndex}'),
          SizedBox(height: 8),
          Text('Allow Bad HTTPS Certificates: ${userPreferences.allowBadHttpsCertificates ? 'Yes' : 'No'}'),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _navigateToEditPreferences,
            child: Text('Edit Preferences'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SplashScreen()), // Ensure SplashScreen is imported
              );
            },
            child: Text('Back to Splash Screen'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: FutureBuilder<UserPreferences>(
        future: _userPreferencesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(), // Show a loading indicator while waiting
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error loading preferences: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            return _buildPreferencesInfo(snapshot.data!);
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
