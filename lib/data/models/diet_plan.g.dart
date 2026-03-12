// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diet_plan.dart';

class DietPlanAdapter extends TypeAdapter<DietPlan> {
  @override
  final int typeId = 3;

  @override
  DietPlan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DietPlan(
      catId: fields[0] as String,
      foodKey: fields[1],
      foodName: fields[2] as String,
      targetKcalPerDay: fields[3] as double,
      portionGramsPerDay: fields[4] as double,
      mealsPerDay: fields[5] as int,
      portionGramsPerMeal: fields[6] as double,
      createdAt: fields[7] as DateTime,
      goal: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DietPlan obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.catId)
      ..writeByte(1)
      ..write(obj.foodKey)
      ..writeByte(2)
      ..write(obj.foodName)
      ..writeByte(3)
      ..write(obj.targetKcalPerDay)
      ..writeByte(4)
      ..write(obj.portionGramsPerDay)
      ..writeByte(5)
      ..write(obj.mealsPerDay)
      ..writeByte(6)
      ..write(obj.portionGramsPerMeal)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.goal);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DietPlanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
