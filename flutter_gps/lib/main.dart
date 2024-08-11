import 'package:flutter/material.dart';
import 'package:flutter_gps/providers/CacheManagerProvider.dart';
import 'package:flutter_gps/providers/geo_location_cache_provider.dart';
import 'package:flutter_gps/providers/movement_session_provider.dart';
import 'package:flutter_gps/providers/app_settings.dart';
import 'package:logging/logging.dart';
import 'my_home_page.dart';
import 'package:provider/provider.dart';

void main() {
  _setupLogging();

  // Logger _logger = Logger('Main');

  // runApp(const MyApp());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SettingsProvider(),
        ),

        //NOTE: Only for Provider lifecycle initialization/"Update" events
        // Use ChangeNotifierProxyProvider to create GeoLocationCache
        ChangeNotifierProxyProvider<SettingsProvider, CacheManagerProvider>(
          create: (context) => CacheManagerProvider(),
          // register this update task
          update: (context, settingsProvider, cacheManagerProvider) {
            // called when settingsProvider has an update event from notifyListeners:
            cacheManagerProvider?.updateSettings(settingsProvider.settings);
            return cacheManagerProvider!;
          },
        ),

        //NOTE: Only for Provider lifecycle initialization/"Update" events
        // Use ChangeNotifierProxyProvider to create GeoLocationCache
        ChangeNotifierProxyProvider<SettingsProvider, GeoLocationCacheProvider>(
          create: (context) => GeoLocationCacheProvider(),
          // register this update task
          update: (context, settingsProvider, geoLocationCache) {
            // called when settingsProvider has an update event from notifyListeners:
            geoLocationCache?.updateSettings(settingsProvider.settings);
            return geoLocationCache!;
          },
        ),

        // NOTE: Only for Provider lifecycle initialization/"Update" events
        // Use ChangeNotifierProxyProvider to create GeoLocationCache
        // NOTE: ChangeNotifierProxyProvider2 pass to providers to MovementSessionProvider
        ChangeNotifierProxyProvider2<SettingsProvider, GeoLocationCacheProvider, MovementSessionProvider>(
          create: (context) => MovementSessionProvider(),
          // register this update task
          update: (context, settingsProvider, geoLocationCacheProvider, movementSessionProvider) {
            // called when settingsProvider has an update event from notifyListeners:
            print( context.toString() );
            movementSessionProvider?.checkForMovementSessionEvent(settingsProvider, geoLocationCacheProvider);
            return movementSessionProvider!;
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // NOTE: fetch all Providers if they provide system-level services
    final settingsProvider = Provider.of<SettingsProvider>(context);  // to send update notifications via methods
    final tileCacheManagerProvider = Provider.of<CacheManagerProvider>(context);  // to send update notifications via methods
    final geoLocationCacheProvider = Provider.of<GeoLocationCacheProvider>(context);  // to send update notifications via methods
    final movementSessionProvider = Provider.of<MovementSessionProvider>(context);  // to send update notifications via methods

    // final Logger _logger = Logger('MyApp');
    // final geoLocationCache = Provider.of<GeoLocationCacheProvider>(context);
    // final appSettings = Provider.of<SettingsProvider>(context).settings;
    return MaterialApp(
      title: 'GPS Positioning',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

void _setupLogging() {
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((record) {
    // print( StackTrace.current );
    final String where = StackTrace.current
        .toString()
        .split('\n')[2]
        .split('(')[1]
        .split(')')[0];
    final String ts =
        '${record.time.hour}:${record.time.minute}:${record.time.second}'; //.${record.time.microsecond}';
    print(
        '${record.loggerName} ${where} ${record.level.name} ${ts}: ${record.message}');
  });
}
