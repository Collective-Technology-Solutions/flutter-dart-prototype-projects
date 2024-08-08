import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gps/views/map_support.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import '../providers/geo_location_cache_provider.dart';

class CurrentGPSPositionView extends StatelessWidget {
  const CurrentGPSPositionView({super.key});

  // if used here, we are no longer stateless
  // final Logger _logger = Logger('CurrentGPSPositionView');

  @override
  Widget build(BuildContext context) {
    final geoLocationCache = Provider.of<GeoLocationCacheProvider>(context);
    Position? currentPosition = geoLocationCache.latest;
    // final Logger logger = Logger('CurrentGPSPositionView');
    // logger.fine( "build called: ${currentPosition}");
    String label = currentPosition != null ? positionAsJson(currentPosition!) : "";
    return Scaffold(
      appBar: AppBar(
        title: const Text("Current GPS Position"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            if (currentPosition != null)
              GestureDetector(
                onTap: () {
                  // Action to perform on tap
                  Clipboard.setData(ClipboardData(text: label));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Location copied to clipboard')),
                  );
                },
                child: Text(
                  label,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.normal),
                ),
              ),

            // const SizedBox(height: 220),
            // ElevatedButton(
            //   onPressed: geoLocationCache.fetchLocation,
            //   child: const Text("Refresh Location"),
            // ),
          ],
        ),
      ),
    );
  }
}
