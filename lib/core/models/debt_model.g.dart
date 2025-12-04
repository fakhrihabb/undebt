// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debt_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DebtModelAdapter extends TypeAdapter<DebtModel> {
  @override
  final int typeId = 0;

  @override
  DebtModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DebtModel(
      id: fields[0] as String?,
      name: fields[1] as String,
      debtType: fields[2] as String,
      originalBalance: fields[3] as double,
      currentBalance: fields[4] as double,
      apr: fields[5] as double,
      minimumPayment: fields[6] as double,
      dueDate: fields[7] as int?,
      createdAt: fields[8] as DateTime?,
      paidOffAt: fields[9] as DateTime?,
      status: fields[10] as String?,
      priority: fields[11] as int?,
      monsterType: fields[12] as String?,
      userId: fields[13] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DebtModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.debtType)
      ..writeByte(3)
      ..write(obj.originalBalance)
      ..writeByte(4)
      ..write(obj.currentBalance)
      ..writeByte(5)
      ..write(obj.apr)
      ..writeByte(6)
      ..write(obj.minimumPayment)
      ..writeByte(7)
      ..write(obj.dueDate)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.paidOffAt)
      ..writeByte(10)
      ..write(obj.status)
      ..writeByte(11)
      ..write(obj.priority)
      ..writeByte(12)
      ..write(obj.monsterType)
      ..writeByte(13)
      ..write(obj.userId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DebtModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
