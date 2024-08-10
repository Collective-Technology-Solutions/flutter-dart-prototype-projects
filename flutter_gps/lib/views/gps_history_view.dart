import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gps/views/app_settings.dart';
import 'package:flutter_gps/utils/map_support.dart';
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
    if (settings.uiIgnoreDeplicatesOnLastUpdate) {
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
          String label = '(${position.latitude}:${position.longitude}:${position.altitude}) ${position.speed}';
          return ExpansionTile(
            title: Text("$index: ${label}"),
            subtitle: Text("Timestamp: ${position.timestamp.toLocal()}"),
            children: <Widget>[
              ListTile(
                title: Text("Latitude: ${position.latitude}"),
                subtitle: Text("Accuracy: ${position.accuracy ?? 'N/A'}"),
              ),
              ListTile(
                title: Text("Longitude: ${position.longitude}"),
                subtitle: Text("Accuracy: ${position.accuracy ?? 'N/A'}"),
              ),
              ListTile(
                title: Text("Altitude: ${position.altitude}"),
                subtitle: Text("Accuracy: ${position.altitudeAccuracy ?? 'N/A'}"),
              ),
              ListTile(
                title: Text("Speed: ${position.speed ?? 'N/A'}"),
                subtitle: Text("Accuracy: ${position.speedAccuracy ?? 'N/A'}"),
              ),
              ListTile(
                title: Text("Heading: ${position.heading ?? 'N/A'}"),
                subtitle: Text("Accuracy: ${position.headingAccuracy ?? 'N/A'}"),
              ),
              // ListTile(
              //   title: Text("Timestamp: ${position.timestamp.toLocal()}"),
              // ),
              ListTile(
                title: IconButton(
                  icon: Icon(Icons.copy),
                  onPressed: () {
                    String onPressedData = position != null ? positionAsJson(position) : "";
                    Clipboard.setData(ClipboardData(text: onPressedData));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Copied location to clipboard')),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
