import 'package:flutter/material.dart';
import 'package:flutter_gps/models/app_settings.dart';
import 'package:geolocator/geolocator.dart';

class SettingsProvider extends ChangeNotifier {
  final AppSettings _settings = AppSettings();

  AppSettings get settings => _settings;

  void updateServiceRunning(bool run ) {
    _settings.serviceRunning = run;
    notifyListeners();
  }

  void updateLocationAccuracy( LocationAccuracy locationAccuracy ) {
    _settings.locationAccuracy = locationAccuracy;
    notifyListeners();
  }

  void toogleServiceRunning() {
    _settings.serviceRunning = !_settings.serviceRunning;
    notifyListeners();
  }

  void updateFrequencySeconds(int newFrequency) {
    _settings.updateFrequencySeconds = newFrequency;
    notifyListeners();
  }

  void updateIgnoreRadius(double newRadius) {
    _settings.ignoreRadius = newRadius;
    notifyListeners();
  }

  void toggleZoomOnAccuracy() {
    _settings.zoomOnAccuracy = !_settings.zoomOnAccuracy;
    notifyListeners();
  }

  void updateCacheExpirationDays(int days) {
    _settings.cacheExpirationDays = days;
    notifyListeners();
  }

  void toggleUIIgnoreDeplicatesOnLastUpdate() {
    _settings.uiIgnoreDeplicatesOnLastUpdate = !_settings.uiIgnoreDeplicatesOnLastUpdate;
    notifyListeners();
  }

  void updateUIMaxDataEntryCount(int maxEntryCount) {
    _settings.uiMaxDataEntryCount = maxEntryCount;
    notifyListeners();
  }

  void updateCacheExpirationMaxCount(int maxNrOfCacheObjects) {
    _settings.cacheExpirationMaxCount = maxNrOfCacheObjects;
    notifyListeners();
  }

  void useImperial( bool useImperial ) {
    _settings.useImperial = useImperial;
    notifyListeners();
  }
}
