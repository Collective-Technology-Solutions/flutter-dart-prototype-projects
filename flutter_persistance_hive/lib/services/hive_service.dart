import 'package:flutter_persistance_hive/models/user_preferences.dart';
import 'package:hive/hive.dart';

/*
FOCUS ITEMS:
- use of Hive to persist key value pairs locally using models to serialize data to a binary form
-

Notes:
- should determine if this is the best way to create singletons in Dart; Maybe a Provider would be better for larger projects?

 */
class HiveService {
  static final HiveService _instance = HiveService._internal();
  static const String _boxName = 'userPreferences';

  factory HiveService() {
    return _instance;
  }

  HiveService._internal();

  void registerAdapters() {
    Hive.registerAdapter(UserPreferencesAdapter());
  }

  Future<void> openBox() async {
    // Open the box to ensure it is available for use
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<UserPreferences>(_boxName);
    }
  }

  //NOTE: untested, unverified
  Future<void> removeBox() async {
    await openBox();
    var box = Hive.box<UserPreferences>(_boxName);
      box.deleteFromDisk();
  }

  Future<UserPreferences> getUserPreferences() async {
    // Ensure the box is opened before accessing it
    await openBox();
    var box = Hive.box<UserPreferences>(_boxName);
    return box.get('preferences') ??
        UserPreferences(
          alias: 'defaultAlias',
          bookmarkedViewNames: [],
          showSplashScreen: true,
          splashScreenImageIndex: 1,
          allowBadHttpsCertificates: false,
        );
  }

  Future<void> saveUserPreferences(UserPreferences preferences) async {
    // Ensure the box is opened before saving data
    await openBox();
    var box = Hive.box<UserPreferences>(_boxName);
    await box.put('preferences', preferences);
  }
}
