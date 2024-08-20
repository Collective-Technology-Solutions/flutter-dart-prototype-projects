
import 'package:flutter/material.dart';
import 'package:async/async.dart'; // Import the async package
import 'package:flutter_gps/models/movement_session.dart';
import 'package:flutter_gps/providers/app_settings.dart';
import 'package:flutter_gps/providers/geo_location_cache_provider.dart';
import 'package:flutter_gps/utils/position_support.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logging/logging.dart';


class MovementSessionProvider with ChangeNotifier {
  final _lock = Lock();
  List<MovementSession> _sessions = [];

  String _sessionNamePrefix = "Session";
  int _sessionId = 0;

  List<MovementSession> get sessions => _sessions;

  Future<void> checkForMovementSessionEvent(SettingsProvider settingsProvider, GeoLocationCacheProvider geoLocationCacheProvider) async {
    await _lock.synchronized(() async {
      final Logger _logger = Logger('checkForMovementSessionEvent');
      if (settingsProvider.settings.serviceRunning == false &&
          geoLocationCacheProvider.isNotEmpty()) {
        print(StackTrace.current);
        try {
          addMovementSession(geoLocationCacheProvider);
          _logger.info("Create a MovementSession." +
              _sessions.last.positions.length.toString());
        }
        catch (e) {
          _logger.severe(e);
        }
      }
      else
        _logger.info("Waiting before creating MovementSession.");
    }
  }

  void addSession(MovementSession session) {
    _sessions.add(session);
    notifyListeners();
  }

  void updateSession(int index, MovementSession updatedSession) {
    if (index >= 0 && index < _sessions.length) {
      _sessions[index] = updatedSession;
      notifyListeners();
    }
  }

  void removeSession(int index) {
    if (index >= 0 && index < _sessions.length) {
      _sessions.removeAt(index);
      notifyListeners();
    }
  }

  void clearSessions() {
    _sessions.clear();
    notifyListeners();
  }


  void addMovementSession(GeoLocationCacheProvider geoLocationCacheProvider) {
    List<Position> positions = geoLocationCacheProvider.transferAndReset();
    positions = applyQualityDataFilter(positions, 1.5);
    String name = '${_sessionNamePrefix} ${++_sessionId}';
    MovementSession session = MovementSession(name: name, positions : List.from(positions), heartRates: []);
    geoLocationCacheProvider.clear();
    registerNewSession( session );
  }

  void registerNewSession(MovementSession session) {
    _sessions.add( session );
    notifyListeners();
  }

}
