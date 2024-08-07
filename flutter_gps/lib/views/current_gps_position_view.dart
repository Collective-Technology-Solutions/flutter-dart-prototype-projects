// lib/views/current_gps_position_view.dart

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../geo_location_cache.dart';

class CurrentGPSPositionView extends StatelessWidget {
  final Position? currentPosition;
  final GeoLocationCache cache;
  final Future<void> Function() onRefresh;

  const CurrentGPSPositionView({super.key, 
    required this.currentPosition,
    required this.cache,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Current GPS Position"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (currentPosition != null)
              Text(
                "LAT: ${currentPosition!.latitude}, LNG: ${currentPosition!.longitude}",
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onRefresh,
              child: const Text("Refresh Location"),
            ),
          ],
        ),
      ),
    );
  }
}
