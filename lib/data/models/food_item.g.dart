// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FoodItemAdapter extends TypeAdapter<FoodItem> {
  @override
  final int typeId = 1;

  @override
  FoodItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FoodItem(
      barcode: fields[0] as String?,
      name: fields[1] as String,
      brand: fields[2] as String?,
      kcalPer100g: fields[3] as double,
      protein: fields[4] as double?,
      fat: fields[5] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, FoodItem obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.barcode)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.brand)
      ..writeByte(3)
      ..write(obj.kcalPer100g)
      ..writeByte(4)
      ..write(obj.protein)
      ..writeByte(5)
      ..write(obj.fat);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoodItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
