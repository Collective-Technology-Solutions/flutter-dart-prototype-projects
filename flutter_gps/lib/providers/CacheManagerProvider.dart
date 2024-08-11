// Define a CacheManagerProvider
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_gps/models/app_settings.dart';

class CacheManagerProvider with ChangeNotifier {
  CacheManager _cacheManager;

  CacheManagerProvider()
      : _cacheManager = CacheManager(Config(
          'customCacheKey',
          stalePeriod: Duration(days: 7),
          maxNrOfCacheObjects: 100,
        ));

  CacheManager get cacheManager => _cacheManager;

  void updateSettings(AppSettings settings) {
    // check for any changes to be concerned with
    if (_cacheManager.config.maxNrOfCacheObjects !=
            settings.cacheExpirationMaxCount ||
        _cacheManager.config.stalePeriod != settings.cacheExpirationDays) {
      _cacheManager = CacheManager(Config(
        'customCacheKey',
        stalePeriod: Duration(days: settings.cacheExpirationDays),
        maxNrOfCacheObjects: settings.cacheExpirationMaxCount,
      ));
    }
  }
}
