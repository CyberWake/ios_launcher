// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_info_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppInfoAdapter extends TypeAdapter<AppInfo> {
  @override
  final int typeId = 1;

  @override
  AppInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppInfo(
      appName: fields[0] as String,
      appPackage: fields[1] as String,
      appIcon: fields[2] as Uint8List,
      appCategory: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AppInfo obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.appName)
      ..writeByte(1)
      ..write(obj.appPackage)
      ..writeByte(2)
      ..write(obj.appIcon)
      ..writeByte(3)
      ..write(obj.appCategory);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
