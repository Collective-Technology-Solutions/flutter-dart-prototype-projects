import 'package:hive/hive.dart';

part 'user_preferences.g.dart';

/*
FOCUS ITEMS:
- Using Hive and HiveType here to autogenerate @user_preferences.g.dart


NOTE:
- recording HiveField means prior data will not load

 */


@HiveType(typeId: 0)
class UserPreferences extends HiveObject {
  @HiveField(0)
  String alias;

  @HiveField(1)
  List<String> bookmarkedViewNames;

  @HiveField(2)
  bool showSplashScreen;

  @HiveField(3)
  int splashScreenImageIndex;

  @HiveField(4)
  bool allowBadHttpsCertificates;

  UserPreferences({
    required this.alias,
    required this.bookmarkedViewNames,
    required this.showSplashScreen,
    required this.splashScreenImageIndex,
    required this.allowBadHttpsCertificates,
  });

  UserPreferences copyWith({
    String? alias,
    List<String>? bookmarkedViewNames,
    bool? showSplashScreen,
    int? splashScreenImageIndex,
    bool? allowBadHttpsCertificates,
  }) {
    return UserPreferences(
      alias: alias ?? this.alias,
      bookmarkedViewNames: bookmarkedViewNames ?? this.bookmarkedViewNames,
      showSplashScreen: showSplashScreen ?? this.showSplashScreen,
      splashScreenImageIndex: splashScreenImageIndex ?? this.splashScreenImageIndex,
      allowBadHttpsCertificates: allowBadHttpsCertificates ?? this.allowBadHttpsCertificates,
    );
  }
}
