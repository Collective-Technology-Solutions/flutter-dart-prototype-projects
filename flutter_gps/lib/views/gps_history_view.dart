// lib/views/gps_history_view.dart

import 'package:flutter/material.dart';
import '../../geo_location_cache.dart';

class GPSHistoryView extends StatelessWidget {
  final GeoLocationCache cache;

  const GPSHistoryView({super.key, required this.cache});

  @override
  Widget build(BuildContext context) {
    final locations = cache.getAll();

    return Scaffold(
      appBar: AppBar(
        title: const Text("GPS History"),
      ),
      body: ListView.builder(
        itemCount: locations.length,
        itemBuilder: (context, index) {
          final position = locations[index];
          return ListTile(
            title: Text("LAT: ${position.latitude}, LNG: ${position.longitude}"),
            subtitle: Text("Timestamp: ${position.timestamp}"),
          );
        },
      ),
    );
  }
}
