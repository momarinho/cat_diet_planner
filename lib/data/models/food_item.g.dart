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
      category: fields[6] as String?,
      manufacturer: fields[7] as String?,
      productLine: fields[8] as String?,
      flavor: fields[9] as String?,
      texture: fields[10] as String?,
      packageSize: fields[11] as String?,
      servingUnit: fields[12] as String?,
      fiber: fields[13] as double?,
      moisture: fields[14] as double?,
      carbohydrate: fields[15] as double?,
      sodium: fields[16] as double?,
      palatabilityNotes: fields[17] as String?,
      userTags: (fields[18] as List?)?.cast<String>() ?? const [],
    );
  }

  @override
  void write(BinaryWriter writer, FoodItem obj) {
    writer
      ..writeByte(19)
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
      ..write(obj.fat)
      ..writeByte(6)
      ..write(obj.category)
      ..writeByte(7)
      ..write(obj.manufacturer)
      ..writeByte(8)
      ..write(obj.productLine)
      ..writeByte(9)
      ..write(obj.flavor)
      ..writeByte(10)
      ..write(obj.texture)
      ..writeByte(11)
      ..write(obj.packageSize)
      ..writeByte(12)
      ..write(obj.servingUnit)
      ..writeByte(13)
      ..write(obj.fiber)
      ..writeByte(14)
      ..write(obj.moisture)
      ..writeByte(15)
      ..write(obj.carbohydrate)
      ..writeByte(16)
      ..write(obj.sodium)
      ..writeByte(17)
      ..write(obj.palatabilityNotes)
      ..writeByte(18)
      ..write(obj.userTags);
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
