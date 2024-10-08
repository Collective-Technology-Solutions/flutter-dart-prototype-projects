import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/material.dart';

class CachedTileProvider extends NetworkTileProvider {
  final CacheManager cacheManager;

  CachedTileProvider({required this.cacheManager});

  @override
  ImageProvider getImage(TileCoordinates coordinates, TileLayer options) {
    return super.getImage(coordinates, options);
  }
}
