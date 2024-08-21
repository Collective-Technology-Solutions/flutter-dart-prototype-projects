import 'package:flutter/material.dart';
import 'package:flutter_persistance_hive/services/CustomCacheManager.dart';
import 'package:flutter_persistance_hive/services/hive_service.dart';
import 'package:flutter_persistance_hive/views/home_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';

/*
FOCUS ITEMS:
- splash screen (view with an auto-forward timer)
- loading cachable network images for the logo
- added text from the Platform description of the App (version, build)
- primitive "on error" behaviors (not refined)

NOTES:
-

 */
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? _errorMessage;
  String urlString = '';
  String _version = '';
  String _buildNumber = '';
  bool _showSplashScreen = true;
  int splashTimer = 5;

  @override
  void initState() {
    super.initState();
    _loadInitialSettings();
  }

  Future<void> _loadInitialSettings() async {
    // Fetch preferences and version info
    final userPreferences = await HiveService().getUserPreferences();
    _showSplashScreen = userPreferences.showSplashScreen;
    await _getVersionInfo();

    // If splash screen is disabled, navigate to HomeView immediately
    if (!_showSplashScreen) {
      _navigateToHome(immediate: true);
    } else {
      splashTimer = 5; // or adjust as needed
      _navigateToHome();
    }
  }

  Future<String> _setUrlString() async {
    final userPreferences = await HiveService().getUserPreferences();
    final int index = userPreferences.splashScreenImageIndex;
    urlString =
        'https://cplabs.org/resources/homey/splash/happy_home_$index.jpg';
    return urlString;
  }

  Future<void> _getVersionInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
      _buildNumber = packageInfo.buildNumber;
    });
  }

  void _navigateToHome({bool immediate = false}) async {
    if (!immediate) {
      await Future.delayed(Duration(seconds: splashTimer));
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeView()),
    );
  }

  Future<void> _loadImage() async {
    try {
      await CachedNetworkImage.evictFromCache(urlString);
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load image: $e';
      });
    }
  }

  Widget _buildImage() {
    return Container(
      width: 200, // Set width
      height: 200, // Set height
      child: FittedBox(
        fit: BoxFit.cover,
        child: CachedNetworkImage(
          imageUrl: urlString,
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) {
            if (mounted) {
              // Ensure widget is still mounted before calling setState
              setState(() {
                _errorMessage = 'Failed to load image: $error';
              });
            }
            return Icon(Icons.error);
          },
          cacheManager: CustomCacheManager.instance,
        ),
      ),
    );
  }

  Widget _buildTitleAndVersion() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Happy Homes',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.amber,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Version: $_version-$_buildNumber',
          style: TextStyle(
            fontSize: 14,
            color: Colors.teal,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, color: Colors.red),
          SizedBox(height: 8),
          Text(
            _errorMessage!,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_showSplashScreen) {
      return Container(); // Return an empty container if splash screen is not shown
    }

    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<String>(
            future: _setUrlString(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                return FutureBuilder<void>(
                  future: _loadImage(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError || _errorMessage != null) {
                      return _buildErrorWidget();
                    } else {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 20),
                            _buildImage(),
                            SizedBox(height: 20),
                            _buildTitleAndVersion(),
                            SizedBox(height: 20),
                          ],
                        ),
                      );
                    }
                  },
                );
              } else {
                return Center(child: Text('No data found'));
              }
            },
          ),
          if (_errorMessage != null)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Local cleanup
    super.dispose();
  }
}
