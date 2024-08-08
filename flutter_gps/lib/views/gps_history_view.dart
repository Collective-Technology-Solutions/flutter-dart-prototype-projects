import 'package:flutter/material.dart';
import 'package:flutter_gps/views/app_settings.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../providers/geo_location_cache_provider.dart';

class GPSHistoryView extends StatelessWidget {
  const GPSHistoryView({super.key});

  // if used here, we are no longer stateless
  // final Logger _logger = Logger('GPSHistoryView');

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context).settings;
    final geoLocationCache = Provider.of<GeoLocationCacheProvider>(context);

    List<Position> locations;
    if (settings.deduplicateOnLastUpdate) {
      locations = geoLocationCache.getOverView();
    } else {
      locations = geoLocationCache.getAll();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('GPS History'),
      ),
      body: ListView.builder(
        itemCount: locations.length,
        itemBuilder: (context, index) {
          final position = locations[index];
          return ListTile(
            title: Text(
                "${index}: LAT: ${position.latitude}, LNG: ${position.longitude}, ALT: ${position.altitude}"),
            subtitle: Text("Timestamp: ${position.timestamp}"),
          );
        },
      ),
    );
  }
}
