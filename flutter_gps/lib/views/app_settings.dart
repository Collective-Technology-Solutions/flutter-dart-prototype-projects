import 'package:flutter/material.dart';

class AppSettings {
  bool serviceRunning;
  int updateFrequency; // in seconds
  bool isFinePrecision;
  double ignoreRadius; // in meters
  bool zoomOnAccuracy;
  int cacheExpirationDays; // in days
  bool uiDeduplicateOnLastUpdate;
  int maxDataEntryCount;
  int maxNrOfCacheObjects;

  AppSettings({
    this.serviceRunning = false,
    this.updateFrequency = 3,
    this.isFinePrecision = false,
    this.ignoreRadius = 1,
    this.zoomOnAccuracy = false,
    this.cacheExpirationDays = 7,
    this.uiDeduplicateOnLastUpdate = true,
    this.maxDataEntryCount = 100,
    this.maxNrOfCacheObjects = 500,
  });
}

class SettingsProvider extends ChangeNotifier {
  final AppSettings _settings = AppSettings();

  AppSettings get settings => _settings;

  void updateServiceRunning(bool run ) {
    _settings.serviceRunning = run;
  }

  void toogleServiceRunning() {
    _settings.serviceRunning = !_settings.serviceRunning;
  }

  void updateFrequency(int newFrequency) {
    _settings.updateFrequency = newFrequency;
    notifyListeners();
  }

  void togglePrecision() {
    _settings.isFinePrecision = !_settings.isFinePrecision;
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

  void cacheExpiration(int days) {
    _settings.cacheExpirationDays = days;
    notifyListeners();
  }

  void toggleDeduplicateOnLastUpdate() {
    _settings.uiDeduplicateOnLastUpdate = !_settings.uiDeduplicateOnLastUpdate;
    notifyListeners();
  }

  void maxEntryCount(int maxEntryCount) {
    _settings.maxDataEntryCount = maxEntryCount;
    notifyListeners();
  }

  void maxNrOfCacheObjects(int maxNrOfCacheObjects) {
    _settings.maxNrOfCacheObjects = maxNrOfCacheObjects;
    notifyListeners();
  }
}
