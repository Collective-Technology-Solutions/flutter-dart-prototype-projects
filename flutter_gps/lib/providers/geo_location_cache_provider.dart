import 'package:flutter/foundation.dart';
import 'package:flutter_gps/models/app_settings.dart';
import 'package:flutter_gps/services/geo_location_service.dart';
import 'package:flutter_gps/services/web_geo_location_service.dart';
import 'package:flutter_gps/providers/app_settings.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:logging/logging.dart';

import '../services/desktop_geo_location_service.dart';
import '../services/mobile_geo_location_service.dart';

class GeoLocationCacheProvider extends ChangeNotifier implements PositionCache {
  final Logger _logger = Logger('GeoLocationCacheProvider');
  late AppSettings _settings;
  late GeoLocationService _provider;
  late _PositionCache _positionCache;
  final PositionCacheUtils _positionCacheUtils = PositionCacheUtils();

  GeoLocationCacheProvider() {
    _positionCache = _PositionCache();
    // _provider = _createGeoLocationProvider();
  }

  @override
  void dispose() {
    _positionCache.clear();
    super.dispose();
  }

  PositionCacheUtils getUtils() {
    return _positionCacheUtils;
  }

  @override
  Position? get latest => _positionCache.latest;

  LatLng getCurrentAsLatLgn() {
    final latestPosition = _positionCache.latest;

    if (latestPosition == null) {
      return const LatLng(0, 0);
    } else {
      return _positionCacheUtils.getAsLatLgn(latestPosition);
    }
  }

  void setSettingsProvider(AppSettings settings) {
    this._settings = settings;
  }

  void updateSettings(AppSettings settings) {
    this._settings = settings;
    _provider = _createGeoLocationProvider();
  }

  Future<void> startService() async {
    _positionCache.updateSettings(_settings);
    if (!_settings.serviceRunning) return;
    try {
      _fetchLocation();
    } catch (e) {
      _logger.severe(e);
    }
  }

  //Note: this method should be kept private again so we do not have uncontrolled task scheduling from the UI
  Future<void> _fetchLocation() async {
    try {
      final location = await _getCurrentLocation();
      add(location);
      notifyListeners();
    } catch (e) {
      _logger.severe(e);
    } finally {
      if (_settings.serviceRunning) {
        _logger.fine( 'fetchLocation scheduled.');
        Future.delayed(
            Duration(seconds: _settings.updateFrequencySeconds), _fetchLocation);
      }
    }
  }

  void stopService() {
    _settings.serviceRunning = false;
    notifyListeners();
  }

  @override
  void add(Position location) {
    _positionCache.add(location);
  }

  @override
  double calculateDistance(Position pos1, Position pos2) {
    return _positionCache.calculateDistance(pos1, pos2);
  }

  @override
  List<Position> getAll() {
    return _positionCache.getAll();
  }

  @override
  List<Position> getAllFiltered([List<Position> Function()? filter]) {
    return _positionCache.getAllFiltered(filter);
  }

  @override
  List<Position> getOverView() {
    return _positionCache.getOverView();
  }

  @override
  List<Position> removeTrailingDuplicates() {
    return _positionCache.removeTrailingDuplicates();
  }

  @override
  void clear() {
    _positionCache.clear();
  }

  @override
  bool isEmpty() {
    return _positionCache.isEmpty();
  }

  @override
  bool isNotEmpty() {
    return _positionCache.isNotEmpty();
  }

  GeoLocationService _createGeoLocationProvider() {
    if (kIsWeb) {
      return WebGeoLocationService();
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android) {
      return MobileGeoLocationService();
    } else {
      return DesktopGeoLocationService();
    }
  }

  Future<Position> _getCurrentLocation() async {
    return await _provider.getCurrentLocation(_settings.locationAccuracy);
  }

  @override
  List<Position> transferAndReset() {
    return _positionCache.transferAndReset();
  }
}

abstract class PositionCache {
  Position? get latest;
  void add(Position location);
  List<Position> getAll();
  List<Position> getOverView();
  List<Position> getAllFiltered([List<Position> Function()? filter]);
  List<Position> removeTrailingDuplicates();
  double calculateDistance(Position pos1, Position pos2);
  bool isEmpty();
  bool isNotEmpty();
  List<Position> transferAndReset();
  void clear();
}

class _PositionCache implements PositionCache {
  double _ignoreRadius = 0.0;
  int _maxSize = 100;

  List<Position> _locations = [];

  @override
  Position? get latest => _locations.isNotEmpty ? _locations.last : null;

  @override
  void add(Position location) {
    if (_locations.length >= _maxSize) {
      _locations.removeAt(0);
    }
    if (_locations.isNotEmpty) {
      final double distanceInMeters =
          calculateDistance(_locations.last, location);
      // print("Add/Distance: ${distanceInMeters.toStringAsFixed(2)} meters");

      if (distanceInMeters >= _ignoreRadius) {
        _locations.add(location);
      }
      // else
      // _locations.add(location);
    }
    else {
      _locations.add(location);
    }
  }

  @override
  List<Position> getAll() {
    return _locations;
  }

  @override
  List<Position> getOverView() {
    return getAllFiltered(this.removeTrailingDuplicates);
  }

  @override
  List<Position> getAllFiltered([List<Position> Function()? filter]) {
    if (filter == null) {
      return getAll();
    }
    return filter();
  }

  // Remove trailing duplicates from the list
  @override
  List<Position> removeTrailingDuplicates() {
    if (_locations.isEmpty) return [];

    final uniquePositions = <Position>[];
    Position? lastPosition;

    for (var position in _locations.reversed) {
      if (lastPosition == null ||
          lastPosition.latitude != position.latitude ||
          lastPosition.longitude != position.longitude) {
        uniquePositions.add(position);
        lastPosition = position;
      }
    }
    return uniquePositions.reversed.toList();
  }

  @override
  double calculateDistance(Position pos1, Position pos2) {
    // Convert Position to LatLng
    LatLng latLng1 = LatLng(pos1.latitude, pos1.longitude);
    LatLng latLng2 = LatLng(pos2.latitude, pos2.longitude);

    // Create a Distance object from latlong2
    const Distance distance = Distance();

    // Calculate the distance between the two LatLng points
    return distance(latLng1, latLng2);
  }

  void updateSettings(AppSettings settings) {
    _ignoreRadius = settings.ignoreRadius;
    _maxSize = settings.uiMaxDataEntryCount;
  }

  @override
  bool isEmpty() {
    return _locations.isEmpty;
  }

  @override
  bool isNotEmpty() {
    return _locations.isNotEmpty;
  }

  @override
  void clear() {
    _locations.clear();
  }

  @override
  List<Position> transferAndReset() {
    final transferOwnership = this._locations;
    this._locations = [];
    return transferOwnership;
  }
}

class PositionCacheUtils {
  LatLng getAsLatLgn(Position p) {
    return LatLng(p.latitude, p.longitude);
  }

  List<LatLng> asLatLngs(List<Position> positions) {
    return positions.map((p) => LatLng(p.latitude, p.longitude)).toList();
  }
}
