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
      mealTimes: (fields[11] as List?)?.cast<String>() ?? const [],
      mealLabels: (fields[12] as List?)?.cast<String>() ?? const [],
      mealPortionGrams:
          (fields[13] as List?)
              ?.map((value) => (value as num).toDouble())
              .toList() ??
          const [],
      startDate: fields[14] as DateTime? ?? fields[10] as DateTime,
      // appended fields (new in model)
      manualTargetKcal: fields[15] as double?,
      foodKeys: (fields[16] as List?)?.cast<dynamic>() ?? const [],
      portionUnit: (fields[17] as String?) ?? 'g',
      portionUnitGrams: (fields[18] as num?)?.toDouble() ?? 1.0,
      operationalNotes: fields[19] as String?,
      perCatShareWeights:
          (fields[20] as Map?)?.map(
            (key, value) => MapEntry(key.toString(), (value as num).toDouble()),
          ) ??
          const {},
    );
  }

  @override
  void write(BinaryWriter writer, GroupDietPlan obj) {
    writer
      ..writeByte(21)
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
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.mealTimes)
      ..writeByte(12)
      ..write(obj.mealLabels)
      ..writeByte(13)
      ..write(obj.mealPortionGrams)
      ..writeByte(14)
      ..write(obj.startDate)
      // appended fields
      ..writeByte(15)
      ..write(obj.manualTargetKcal)
      ..writeByte(16)
      ..write(obj.foodKeys)
      ..writeByte(17)
      ..write(obj.portionUnit)
      ..writeByte(18)
      ..write(obj.portionUnitGrams)
      ..writeByte(19)
      ..write(obj.operationalNotes)
      ..writeByte(20)
      ..write(obj.perCatShareWeights);
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
