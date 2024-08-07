// lib/views/leaflet_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../geo_location_cache.dart';

class LeafletView extends StatelessWidget {
  final List<Position> cachedLocations;

  LeafletView({required this.cachedLocations});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaflet Map'),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: cachedLocations.isNotEmpty ? cachedLocations.first : LatLng(0, 0),
          initialZoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: _buildMarkers(),
          ),
        ],
      ),
    );
  }

  List<Marker> _buildMarkers() {
    List<Marker> results = cachedLocations.map((location) {
        return Marker(
          point: location,
          child: Container(
            child: Icon(Icons.location_pin, color: Colors.blue, size: 40),
          ),
        );
      }).toList();
    return results;
  }

}
