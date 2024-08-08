import 'package:flutter/material.dart';

class AppSettings {
  int updateFrequency; // in seconds
  bool isFinePrecision;
  double ignoreRadius; // in meters
  bool zoomOnAccuracy;
  int cacheExpirationDays; // in days
  bool deduplicateOnLastUpdate;
  int maxEntryCount;
  int maxNrOfCacheObjects;

  AppSettings({
    this.updateFrequency = 10,
    this.isFinePrecision = false,
    this.ignoreRadius = 1,
    this.zoomOnAccuracy = false,
    this.cacheExpirationDays = 7,
    this.deduplicateOnLastUpdate = true,
    this.maxEntryCount = 100,
    this.maxNrOfCacheObjects = 500,
  });
}

class SettingsProvider extends ChangeNotifier {
  AppSettings _settings = AppSettings();

  AppSettings get settings => _settings;

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

  void deduplicateOnLastUpdate(bool enabled) {
    _settings.deduplicateOnLastUpdate = enabled;
    notifyListeners();
  }

  void maxEntryCount(int maxEntryCount) {
    _settings.maxEntryCount = maxEntryCount;
    notifyListeners();
  }

  void maxNrOfCacheObjects(int maxNrOfCacheObjects) {
    _settings.maxNrOfCacheObjects = maxNrOfCacheObjects;
    notifyListeners();
  }
}
