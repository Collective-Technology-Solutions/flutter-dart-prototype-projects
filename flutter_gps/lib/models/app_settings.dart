
import 'package:geolocator/geolocator.dart';

class AppSettings {
  bool serviceRunning;
  int updateFrequencySeconds; // in seconds
  LocationAccuracy locationAccuracy;
  double ignoreRadius; // in meters
  bool zoomOnAccuracy;
  int cacheExpirationDays; // in days
  bool uiIgnoreDeplicatesOnLastUpdate;
  int uiMaxDataEntryCount;
  int cacheExpirationMaxCount;

  bool useImperial;

  AppSettings({
    this.serviceRunning = false,
    this.updateFrequencySeconds = 3,
    this.locationAccuracy = LocationAccuracy.reduced,
    this.ignoreRadius = 1,
    this.zoomOnAccuracy = false,
    this.cacheExpirationDays = 7,
    this.uiIgnoreDeplicatesOnLastUpdate = true,
    this.uiMaxDataEntryCount = 100,
    this.cacheExpirationMaxCount = 500,
    this.useImperial = false,
  });
}