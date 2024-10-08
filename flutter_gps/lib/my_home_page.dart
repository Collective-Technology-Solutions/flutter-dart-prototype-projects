import 'package:flutter/material.dart';
import 'package:flutter_gps/providers/app_settings.dart';
import 'package:flutter_gps/views/current_gps_position_view.dart';
import 'package:flutter_gps/views/gps_history_view.dart';
import 'package:flutter_gps/views/movement_session_list_view.dart';
import 'package:flutter_gps/views/openstreetmap_map_view.dart';
import 'package:flutter_gps/views/settings_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import 'providers/geo_location_cache_provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // final Logger _logger = Logger('MyHomePage');

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    final geoLocationCache = Provider.of<GeoLocationCacheProvider>(context);
    geoLocationCache.stopService();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context); // to send events
    final settings = settingsProvider.settings; // for read only
    final geoLocationCache = Provider.of<GeoLocationCacheProvider>(context);

    final tabs = _createTabs();
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Geolocation App"),
          bottom: TabBar(
            tabs: tabs.keys.toList(),
          ),
          actions: [
            // Toggle button on the right side of the AppBar
            Switch(
              value: settings.serviceRunning,
              onChanged: (value) {
                setState(() {
                  settingsProvider.updateServiceRunning( value );
                  if ( settings.serviceRunning )
                    geoLocationCache.startService();
                  else geoLocationCache.stopService();
                });
              },
            ),
          ],
        ),
        body: TabBarView(
          children: tabs.values.toList(),
        ),
      ),
    );
  }

  Map<Tab, Widget> _createTabs() {
    return Map.from({
      const Tab(text: "Settings"): const SettingsScreen(),
      const Tab(text: "Position"): const CurrentGPSPositionView(),
      const Tab(text: "History"): const GPSHistoryView(),
      const Tab(text: "OpenStreetMap"): const OpenStreetMapView(),
      const Tab(text: "Overview"): MovementSessionListView(),
      // Tab(text: "Leaflet") : LeafletView(),
    });
  }
}
