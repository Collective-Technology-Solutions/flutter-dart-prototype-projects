// lib/views/openstreetmap_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_gps/providers/CacheManagerProvider.dart';
import 'package:flutter_gps/providers/geo_location_cache_provider.dart';
import 'package:flutter_gps/providers/cached_tile_provider.dart';
import 'package:flutter_gps/providers/app_settings.dart';
import 'package:flutter_gps/utils/map_support.dart';
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
    final settings = Provider.of<SettingsProvider>(context).settings; // for read only
    final cacheManager = Provider.of<CacheManagerProvider>(context).cacheManager; // for read only
    final geoLocationCache = Provider.of<GeoLocationCacheProvider>(context);  // to send update notifications via methods

    return Scaffold(
      appBar: AppBar(
        title: const Text('OpenStreetMap'),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: geoLocationCache.latest != null
              ? geoLocationCache.getCurrentAsLatLgn()
              : const LatLng(0, 0),
          initialZoom: (settings.zoomOnAccuracy) ? zoomForCurrent(geoLocationCache!.latest) : 13.0,
          onMapEvent: (p0) {
            print( p0 );
          },
          onTap:(tapPosition, point)  {
            //TODO recenter display
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // domains are deprecated
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
