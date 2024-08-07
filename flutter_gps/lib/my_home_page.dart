// lib/my_home_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_gps/providers/desktop_geo_location_provider.dart';
import 'package:flutter_gps/providers/geo_location_provider.dart';
import 'package:flutter_gps/providers/mobile_geo_location_provider.dart';
import 'package:flutter_gps/providers/web_geo_location_provider.dart';
import 'package:flutter_gps/views/current_gps_position_view.dart';
import 'package:flutter_gps/views/gps_history_view.dart';
import 'package:flutter_gps/views/leaflet_map_view.dart';
import 'package:flutter_gps/views/openstreetmap_map_view.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
// import 'providers/geo_location_provider.dart';
import 'geo_location_cache.dart';
import 'logger.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late GeoLocationProvider _geoProvider;
  final GeoLocationCache _cache = GeoLocationCache();
  Position? _currentPosition;
  final int _updateInterval = 10; // seconds
  final String _mapboxAccessToken = 'YOUR_MAPBOX_ACCESS_TOKEN';

  @override
  void initState() {
    super.initState();
    _geoProvider = _createGeoLocationProvider();
    _startLocationUpdates();
  }

  GeoLocationProvider _createGeoLocationProvider() {
    if (kIsWeb) {
      return WebGeoLocationProvider();
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android) {
      return MobileGeoLocationProvider();
    } else {
      return DesktopGeoLocationProvider();
    }
  }

  void _startLocationUpdates() {
    _fetchLocation();
    Future.delayed(Duration(seconds: _updateInterval), _startLocationUpdates);
  }

  Future<void> _fetchLocation() async {
    try {
      final location = await _geoProvider.getCurrentLocation();
      Logger.log("Location fetched: ${location.latitude}, ${location.longitude}");
      _cache.add(location);
      setState(() {
        _currentPosition = location;
      });
    } catch (e) {
      Logger.log("Failed to fetch location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Geolocation App"),
          bottom: TabBar(
            tabs: [
              Tab(text: "Current GPS Position"),
              Tab(text: "GPS History"),
              Tab(text: "OpenStreetMap"),
              Tab(text: "Leaflet"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CurrentGPSPositionView(
              currentPosition: _currentPosition,
              cache: _cache,
              onRefresh: _fetchLocation,
            ),
            GPSHistoryView(cache: _cache),
            OpenStreetMapView(
              currentLocation: _currentPosition != null
                  ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
                  : LatLng(0, 0),
            ),
            LeafletView(
                cachedLocations: _cache.getAll(),
            ),
              // currentLocation: _currentPosition != null
              //     ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
              //     : LatLng(0, 0),
            ),
          ],
        ),
      ),
    );
  }
}
