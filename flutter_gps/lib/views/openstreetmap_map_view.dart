// lib/views/openstreetmap_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_gps/geo_location_cache.dart';
import 'package:flutter_gps/providers/cached_tile_provider.dart';
import 'package:flutter_gps/views/app_settings.dart';
import 'package:flutter_gps/views/map_support.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class OpenStreetMapView extends StatelessWidget {
  late final GeoLocationCache cachedLocations;
  late final CacheManager cacheManager;

  OpenStreetMapView({required this.cachedLocations});

  //TODO to use this, we need to use a StatefulWidget. StateLESSWidget won't use it.
  // @override
  // void initState() {
  //   super.initState();
  //   final settings = Provider.of<SettingsProvider>(context).settings;
  // }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context).settings;

    final cacheManager = CacheManager(
      Config(
        'customCacheKey',
        stalePeriod: Duration(days: settings.cacheExpirationDays),
        maxNrOfCacheObjects: 500,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('OpenStreetMap'),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: cachedLocations.getCurrent() != null
              ? cachedLocations.getCurrentAsLatLgn()
              : LatLng(0, 0),
          initialZoom: 13.0, //zoomForCurrent(cachedLocations.getCurrent()),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            tileProvider: CachedTileProvider(cacheManager: cacheManager),
            // subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: buildMarkers(cachedLocations),
          ),
        ],
      ),
    );
  }
}
