import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../providers/geo_location_cache_provider.dart';

class CurrentGPSPositionView extends StatelessWidget {
  // if used here, we are no longer stateless
  // final Logger _logger = Logger('CurrentGPSPositionView');

  @override
  Widget build(BuildContext context) {
    final geoLocationCache = Provider.of<GeoLocationCacheProvider>(context);
    Position? currentPosition = geoLocationCache.latest;

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
                "LAT: ${currentPosition!.latitude},\nLNG: ${currentPosition!.longitude},\nALT: ${currentPosition!.altitude}\nACC: ${currentPosition!.accuracy}\nSPE: ${currentPosition!.speed}",
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.normal),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: geoLocationCache.fetchLocation,
              child: const Text("Refresh Location"),
            ),
          ],
        ),
      ),
    );
  }
}
