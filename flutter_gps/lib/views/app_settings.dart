import 'package:flutter/material.dart';

class AppSettings {
  int updateFrequency; // in seconds
  bool isFinePrecision;
  int ignoreRadius; // in meters
  bool zoomOnAccuracy;
  int cacheExpirationDays; // in days
  bool deduplateOnLastUpdate;

  AppSettings({
    this.updateFrequency = 10,
    this.isFinePrecision = false,
    this.ignoreRadius = 1,
    this.zoomOnAccuracy = false,
    this.cacheExpirationDays = 7,
    this.deduplateOnLastUpdate = true,
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

  void updateIgnoreRadius(int newRadius) {
    _settings.ignoreRadius = newRadius;
    notifyListeners();
  }

  void toggleZoomOnAccuracy() {
    _settings.zoomOnAccuracy = !_settings.zoomOnAccuracy;
    notifyListeners();
  }

  void cacheExpiration (int days) {
    _settings.cacheExpirationDays = days;
    notifyListeners();
  }

  void deduplateOnLastUpdate( bool enabled ) {
    _settings.deduplateOnLastUpdate = enabled;
    notifyListeners();
  }
}
