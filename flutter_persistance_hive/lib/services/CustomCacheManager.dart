import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/*
FOCUS ITEMS:
- cache network assets for speed and persistence even when resource isn't available an more

NOTES:
- web cache all data take from the internet whenever possible
 */
class CustomCacheManager {
  static const key = 'customCache';

  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: Duration(days: 7),
      maxNrOfCacheObjects: 100,
    ),
  );
}
