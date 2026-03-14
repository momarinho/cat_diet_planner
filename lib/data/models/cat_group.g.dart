// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cat_group.dart';

class CatGroupAdapter extends TypeAdapter<CatGroup> {
  @override
  final int typeId = 4;

  @override
  CatGroup read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CatGroup(
      id: fields[0] as String,
      name: fields[1] as String,
      catCount: fields[2] as int,
      description: fields[3] as String?,
      colorValue: fields[4] as int,
      createdAt: fields[5] as DateTime,
      catIds: (fields[6] as List?)?.cast<String>() ?? const [],
      subgroup: fields[7] as String?,
      category: fields[8] as String?,
      feedingShareByCat:
          (fields[9] as Map?)?.map(
            (key, value) => MapEntry(key.toString(), (value as num).toDouble()),
          ) ??
          const {},
      enclosure: fields[10] as String?,
      environment: fields[11] as String?,
      shiftMorningNotes: fields[12] as String?,
      shiftAfternoonNotes: fields[13] as String?,
      shiftNightNotes: fields[14] as String?,
      secondaryColorValue: fields[15] as int?,
      iconName: fields[16] as String?,
      badgeEmoji: fields[17] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CatGroup obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.catCount)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.colorValue)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.catIds)
      ..writeByte(7)
      ..write(obj.subgroup)
      ..writeByte(8)
      ..write(obj.category)
      ..writeByte(9)
      ..write(obj.feedingShareByCat)
      ..writeByte(10)
      ..write(obj.enclosure)
      ..writeByte(11)
      ..write(obj.environment)
      ..writeByte(12)
      ..write(obj.shiftMorningNotes)
      ..writeByte(13)
      ..write(obj.shiftAfternoonNotes)
      ..writeByte(14)
      ..write(obj.shiftNightNotes)
      ..writeByte(15)
      ..write(obj.secondaryColorValue)
      ..writeByte(16)
      ..write(obj.iconName)
      ..writeByte(17)
      ..write(obj.badgeEmoji);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CatGroupAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
