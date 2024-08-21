// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preferences.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserPreferencesAdapter extends TypeAdapter<UserPreferences> {
  @override
  final int typeId = 0;

  @override
  UserPreferences read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserPreferences(
      alias: fields[0] as String,
      bookmarkedViewNames: (fields[1] as List).cast<String>(),
      showSplashScreen: fields[2] as bool,
      splashScreenImageIndex: fields[3] as int,
      allowBadHttpsCertificates: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, UserPreferences obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.alias)
      ..writeByte(1)
      ..write(obj.bookmarkedViewNames)
      ..writeByte(2)
      ..write(obj.showSplashScreen)
      ..writeByte(3)
      ..write(obj.splashScreenImageIndex)
      ..writeByte(4)
      ..write(obj.allowBadHttpsCertificates);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserPreferencesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
