// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cat_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CatProfileAdapter extends TypeAdapter<CatProfile> {
  @override
  final int typeId = 0;

  @override
  CatProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CatProfile(
      id: fields[0] as String,
      name: fields[1] as String,
      weight: fields[2] as double,
      age: fields[3] as int,
      neutered: fields[4] as bool,
      activityLevel: fields[5] as String,
      goal: fields[6] as String,
      createdAt: fields[7] as DateTime,
      weightHistory: (fields[8] as List).cast<WeightRecord>(),
      photoPath: fields[9] as String?,
      photoBase64: fields[10] as String?,
      preferredMealsPerDay: fields[11] as int? ?? 4,
      manualTargetKcal: fields[12] as double?,
      notes: fields[13] as String?,
      // Appended clinical & routine fields (safe defaults when absent)
      idealWeight: fields[14] as double?,
      bcs: fields[15] as int?,
      sex: (fields[16] as String?) ?? 'unknown',
      breed: fields[17] as String?,
      birthDate: fields[18] as DateTime?,
      customActivityLevel: fields[19] as String?,
      clinicalConditions: (fields[20] as List?)?.cast<String>() ?? const [],
      allergies: (fields[21] as List?)?.cast<String>() ?? const [],
      dietaryPreferences: (fields[22] as List?)?.cast<String>() ?? const [],
      vetNotes: fields[23] as String?,
      activePlanId: fields[24] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CatProfile obj) {
    writer
      ..writeByte(25)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.weight)
      ..writeByte(3)
      ..write(obj.age)
      ..writeByte(4)
      ..write(obj.neutered)
      ..writeByte(5)
      ..write(obj.activityLevel)
      ..writeByte(6)
      ..write(obj.goal)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.weightHistory)
      ..writeByte(9)
      ..write(obj.photoPath)
      ..writeByte(10)
      ..write(obj.photoBase64)
      ..writeByte(11)
      ..write(obj.preferredMealsPerDay)
      ..writeByte(12)
      ..write(obj.manualTargetKcal)
      ..writeByte(13)
      ..write(obj.notes)
      // appended fields
      ..writeByte(14)
      ..write(obj.idealWeight)
      ..writeByte(15)
      ..write(obj.bcs)
      ..writeByte(16)
      ..write(obj.sex)
      ..writeByte(17)
      ..write(obj.breed)
      ..writeByte(18)
      ..write(obj.birthDate)
      ..writeByte(19)
      ..write(obj.customActivityLevel)
      ..writeByte(20)
      ..write(obj.clinicalConditions)
      ..writeByte(21)
      ..write(obj.allergies)
      ..writeByte(22)
      ..write(obj.dietaryPreferences)
      ..writeByte(23)
      ..write(obj.vetNotes)
      ..writeByte(24)
      ..write(obj.activePlanId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CatProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
