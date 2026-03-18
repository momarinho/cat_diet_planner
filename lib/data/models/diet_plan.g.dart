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
      mealTimes: (fields[9] as List?)?.cast<String>() ?? const [],
      mealLabels: (fields[10] as List?)?.cast<String>() ?? const [],
      mealPortionGrams:
          (fields[11] as List?)
              ?.map((value) => (value as num).toDouble())
              .toList() ??
          const [],
      startDate: fields[12] as DateTime? ?? fields[7] as DateTime,
      // appended fields (new in model)
      planId: fields[13] as String?,
      foodKeys: (fields[14] as List?)?.cast<dynamic>() ?? const [],
      foodNames: (fields[15] as List?)?.cast<String>() ?? const [],
      portionUnit: (fields[16] as String?) ?? 'g',
      portionUnitGrams: (fields[17] as num?)?.toDouble() ?? 1.0,
      dailyOverrides:
          (fields[18] as Map?)?.cast<int, Map<dynamic, dynamic>>() ?? const {},
      operationalNotes: fields[19] as String?,
      foodSplitPercentByKcal:
          (fields[20] as Map?)?.map(
            (key, value) => MapEntry(key, (value as num).toDouble()),
          ) ??
          const {},
    );
  }

  @override
  void write(BinaryWriter writer, DietPlan obj) {
    writer
      ..writeByte(21)
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
      ..write(obj.goal)
      ..writeByte(9)
      ..write(obj.mealTimes)
      ..writeByte(10)
      ..write(obj.mealLabels)
      ..writeByte(11)
      ..write(obj.mealPortionGrams)
      ..writeByte(12)
      ..write(obj.startDate)
      // appended fields
      ..writeByte(13)
      ..write(obj.planId)
      ..writeByte(14)
      ..write(obj.foodKeys)
      ..writeByte(15)
      ..write(obj.foodNames)
      ..writeByte(16)
      ..write(obj.portionUnit)
      ..writeByte(17)
      ..write(obj.portionUnitGrams)
      ..writeByte(18)
      ..write(obj.dailyOverrides)
      ..writeByte(19)
      ..write(obj.operationalNotes)
      ..writeByte(20)
      ..write(obj.foodSplitPercentByKcal);
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
