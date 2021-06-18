// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_app_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CategoryAppsAdapter extends TypeAdapter<CategoryApps> {
  @override
  final int typeId = 2;

  @override
  CategoryApps read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CategoryApps(
      categoryApps: (fields[0] as List).cast<AppInfo>(),
      categoryName: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CategoryApps obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.categoryApps)
      ..writeByte(1)
      ..write(obj.categoryName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryAppsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
