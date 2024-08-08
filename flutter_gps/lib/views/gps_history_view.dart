// lib/views/gps_history_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_gps/views/app_settings.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../../geo_location_cache.dart';

class GPSHistoryView extends StatelessWidget {
  final GeoLocationCache cache;

  const GPSHistoryView({super.key, required this.cache});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context).settings;
    List<Position> locations;
    if ( settings.deduplateOnLastUpdate )
      locations = cache.getOverView();
    else locations = cache.getAll();

    return Scaffold(
      appBar: AppBar(
        title: const Text("GPS History"),
      ),
      body: ListView.builder(
        itemCount: locations.length,
        itemBuilder: (context, index) {
          final position = locations[index];
          return ListTile(
            title: Text("LAT: ${position.latitude}, LNG: ${position.longitude}, ALT: ${position.altitude}"),
            subtitle: Text("Timestamp: ${position.timestamp}"),
          );
        },
      ),
    );
  }
}
