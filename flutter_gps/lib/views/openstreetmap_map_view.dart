// lib/views/openstreetmap_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_gps/providers/TileCacheManagerProvider.dart';
import 'package:flutter_gps/providers/geo_location_cache_provider.dart';
import 'package:flutter_gps/providers/cached_tile_provider.dart';
import 'package:flutter_gps/views/app_settings.dart';
import 'package:flutter_gps/views/map_support.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

class OpenStreetMapView extends StatefulWidget {
  const OpenStreetMapView({super.key});

  @override
  _OpenStreetMapViewState createState() => _OpenStreetMapViewState();
}

class _OpenStreetMapViewState extends State<OpenStreetMapView> {
  final Logger _logger = Logger('OpenStreetMapView');

  @override
  void initState() {
    super.initState(); // should be called first

  }

  @override
  void dispose() {

    super.dispose(); // should be be called last
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context).settings;
    final cacheManager = Provider.of<TileCacheManagerProvider>(context).cacheManager;
    final geoLocationCache = Provider.of<GeoLocationCacheProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('OpenStreetMap'),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: geoLocationCache.latest != null
              ? geoLocationCache.getCurrentAsLatLgn()
              : const LatLng(0, 0),
          initialZoom: (settings.zoomOnAccuracy) ? zoomForCurrent(geoLocationCache.latest) : 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            tileProvider: CachedTileProvider(cacheManager: cacheManager),
            errorTileCallback: (tile, error, stackTrace) => Center(child: Text('Failed to load map tiles ${error}.'))
          ),
          MarkerLayer(
            markers: buildMarkers(geoLocationCache),
          ),
        ],
      ),
    );
  }
}
