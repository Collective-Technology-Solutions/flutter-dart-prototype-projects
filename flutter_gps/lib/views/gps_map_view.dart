// lib/views/gps_map_view.dart

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../geo_location_cache.dart';
import '../../logger.dart';

class GPSMapView extends StatelessWidget {
  final GeoLocationCache cache;

  GPSMapView({required this.cache});

  @override
  Widget build(BuildContext context) {
    final position = cache.latest;

    return Scaffold(
      appBar: AppBar(
        title: Text("GPS Map"),
      ),
      body: position == null
          ? Center(child: Text("No location data available"))
          : GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 15,
        ),
        markers: {
          Marker(
            markerId: MarkerId('current_location'),
            position: LatLng(position.latitude, position.longitude),
            infoWindow: InfoWindow(title: 'Current Location'),
          ),
        },
        circles: {
          if (position.accuracy < 50)
            Circle(
              circleId: CircleId('accuracy_circle'),
              center: LatLng(position.latitude, position.longitude),
              radius: position.accuracy,
              fillColor: Colors.blue.withOpacity(0.2),
              strokeColor: Colors.blue,
              strokeWidth: 1,
            ),
        },
      ),
    );
  }
}
