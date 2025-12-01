// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PaymentModelAdapter extends TypeAdapter<PaymentModel> {
  @override
  final int typeId = 1;

  @override
  PaymentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PaymentModel(
      id: fields[0] as String?,
      debtId: fields[1] as String,
      userId: fields[2] as String,
      amount: fields[3] as double,
      paymentDate: fields[4] as DateTime?,
      paymentType: fields[5] as String,
      xpEarned: fields[6] as int,
      notes: fields[7] as String?,
      createdAt: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, PaymentModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.debtId)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.amount)
      ..writeByte(4)
      ..write(obj.paymentDate)
      ..writeByte(5)
      ..write(obj.paymentType)
      ..writeByte(6)
      ..write(obj.xpEarned)
      ..writeByte(7)
      ..write(obj.notes)
      ..writeByte(8)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
