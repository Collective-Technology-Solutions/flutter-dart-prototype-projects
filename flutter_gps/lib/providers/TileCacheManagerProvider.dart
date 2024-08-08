// Define a CacheManagerProvider
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class TileCacheManagerProvider with ChangeNotifier {
  final CacheManager _cacheManager;

  TileCacheManagerProvider()
      : _cacheManager = CacheManager(
    Config(
      'customCacheKey',
      stalePeriod: Duration(days: 7),
      maxNrOfCacheObjects: 100,
    ),
  );

  CacheManager get cacheManager => _cacheManager;
}