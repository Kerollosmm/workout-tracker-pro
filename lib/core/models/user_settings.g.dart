// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserSettingsAdapter extends TypeAdapter<UserSettings> {
  @override
  final int typeId = 4;

  @override
  UserSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserSettings(
      language: fields[0] as String,
      weightUnit: fields[1] as String,
      isDarkMode: fields[2] as bool,
      notificationDays: (fields[3] as List).cast<String>(),
      notificationTime: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserSettings obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.language)
      ..writeByte(1)
      ..write(obj.weightUnit)
      ..writeByte(2)
      ..write(obj.isDarkMode)
      ..writeByte(3)
      ..write(obj.notificationDays)
      ..writeByte(4)
      ..write(obj.notificationTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
