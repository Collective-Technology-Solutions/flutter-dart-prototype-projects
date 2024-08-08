import 'package:flutter/material.dart';
import 'package:flutter_gps/providers/geo_location_cache_provider.dart';
import 'package:flutter_gps/views/app_settings.dart';
import 'package:logging/logging.dart';
import 'my_home_page.dart';
import 'package:provider/provider.dart';

void main() {
  _setupLogging();

  Logger _logger = Logger('Main');

  // runApp(const MyApp());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SettingsProvider(),

        ),

        // Use ChangeNotifierProxyProvider to create GeoLocationCache
        ChangeNotifierProxyProvider<SettingsProvider, GeoLocationCacheProvider>(
          create: (context) => GeoLocationCacheProvider(),
          update: (context, settingsProvider, geoLocationCache) {
            geoLocationCache?.updateSettings(settingsProvider.settings);
            return geoLocationCache!;
          },
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Logger _logger = Logger('MyApp');
    final geoLocationCache = Provider.of<GeoLocationCacheProvider>(context);
    final appSettings = Provider.of<SettingsProvider>(context).settings;
    return MaterialApp(
      title: 'GPS Positioning',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

void _setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    // print( StackTrace.current );
    final String where = StackTrace.current.toString().split('\n')[2].split('(')[1].split(')')[0];
    final String ts = '${record.time.hour}:${record.time.minute}:${record.time.second}'; //.${record.time.microsecond}';
    print('${record.loggerName} ${where} ${record.level.name} ${ts}: ${record.message}');
  });
}