// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_diet_plan.dart';

class GroupDietPlanAdapter extends TypeAdapter<GroupDietPlan> {
  @override
  final int typeId = 5;

  @override
  GroupDietPlan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GroupDietPlan(
      groupId: fields[0] as String,
      foodKey: fields[1],
      foodName: fields[2] as String,
      catCount: fields[3] as int,
      targetKcalPerCatPerDay: fields[4] as double,
      targetKcalPerGroupPerDay: fields[5] as double,
      portionGramsPerCatPerDay: fields[6] as double,
      portionGramsPerGroupPerDay: fields[7] as double,
      mealsPerDay: fields[8] as int,
      portionGramsPerGroupPerMeal: fields[9] as double,
      createdAt: fields[10] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, GroupDietPlan obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.groupId)
      ..writeByte(1)
      ..write(obj.foodKey)
      ..writeByte(2)
      ..write(obj.foodName)
      ..writeByte(3)
      ..write(obj.catCount)
      ..writeByte(4)
      ..write(obj.targetKcalPerCatPerDay)
      ..writeByte(5)
      ..write(obj.targetKcalPerGroupPerDay)
      ..writeByte(6)
      ..write(obj.portionGramsPerCatPerDay)
      ..writeByte(7)
      ..write(obj.portionGramsPerGroupPerDay)
      ..writeByte(8)
      ..write(obj.mealsPerDay)
      ..writeByte(9)
      ..write(obj.portionGramsPerGroupPerMeal)
      ..writeByte(10)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GroupDietPlanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
