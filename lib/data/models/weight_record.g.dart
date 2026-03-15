// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weight_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WeightRecordAdapter extends TypeAdapter<WeightRecord> {
  @override
  final int typeId = 2;

  @override
  WeightRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WeightRecord(
      catId: fields[12] as String? ?? '',
      date: fields[0] as DateTime,
      weight: fields[1] as double,
      notes: fields[2] as String?,
      weightContext: fields[3] as String?,
      appetite: fields[4] as String?,
      stool: fields[5] as String?,
      vomit: fields[6] as String?,
      energy: fields[7] as String?,
      clinicalAssessment: fields[8] as String?,
      clinicalPlan: fields[9] as String?,
      clinicalAlertLevel: fields[10] as String?,
      alertTriggered: fields[11] as bool? ?? false,
    );
  }

  @override
  void write(BinaryWriter writer, WeightRecord obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.weight)
      ..writeByte(2)
      ..write(obj.notes)
      ..writeByte(3)
      ..write(obj.weightContext)
      ..writeByte(4)
      ..write(obj.appetite)
      ..writeByte(5)
      ..write(obj.stool)
      ..writeByte(6)
      ..write(obj.vomit)
      ..writeByte(7)
      ..write(obj.energy)
      ..writeByte(8)
      ..write(obj.clinicalAssessment)
      ..writeByte(9)
      ..write(obj.clinicalPlan)
      ..writeByte(10)
      ..write(obj.clinicalAlertLevel)
      ..writeByte(11)
      ..write(obj.alertTriggered)
      ..writeByte(12)
      ..write(obj.catId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeightRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
