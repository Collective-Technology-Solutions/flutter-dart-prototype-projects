import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_persistance_hive/services/hive_service.dart';
import 'package:flutter_persistance_hive/views/splash_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

/*
FOCUS ITEMS:
- Hive Service configuration, registration, invocations
- fetching user preferences early in the app lifecycle
- disabling HTTP/SSL server CERT blocking errors using HttpOverrides.global
-

NOTES:
-

 */

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Load user preferences
  final hiveService = HiveService();
  HiveService().registerAdapters(); // Register adapters for Hive
  // await HiveService().removeBox();
  await HiveService().openBox(); // Open the Hive box
  final userPreferences = await hiveService.getUserPreferences();

  // Apply HTTP overrides if allowed
  if (userPreferences.allowBadHttpsCertificates) {
    HttpOverrides.global = MyHttpOverrides();
  }

  runApp(MyApp());
}

//TODO: consider State<MyApp> with WidgetsBindingObserver
//TODO: add in WidgetsBindingObserver, didChangeAppLifecycleState(), dispose()
// to manage global service clean
class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hive User Preferences',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

/*
 Allows for loading resources from insecure HTTPS servers
 */
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);
    client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    return client;
  }
}
