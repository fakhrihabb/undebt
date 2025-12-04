// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 2;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      id: fields[0] as String?,
      email: fields[1] as String,
      createdAt: fields[2] as DateTime?,
      subscriptionStatus: fields[3] as String?,
      subscriptionExpires: fields[4] as DateTime?,
      selectedMethod: fields[5] as String?,
      level: fields[6] as int?,
      totalXp: fields[7] as int?,
      totalDebtDefeated: fields[8] as double?,
      totalInterestSaved: fields[9] as double?,
      currentStreakDays: fields[10] as int?,
      lastCheckIn: fields[11] as DateTime?,
      notificationsEnabled: fields[12] as bool?,
      soundEnabled: fields[13] as bool?,
      hapticsEnabled: fields[14] as bool?,
      darkMode: fields[15] as String?,
      onboardingComplete: fields[16] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.subscriptionStatus)
      ..writeByte(4)
      ..write(obj.subscriptionExpires)
      ..writeByte(5)
      ..write(obj.selectedMethod)
      ..writeByte(6)
      ..write(obj.level)
      ..writeByte(7)
      ..write(obj.totalXp)
      ..writeByte(8)
      ..write(obj.totalDebtDefeated)
      ..writeByte(9)
      ..write(obj.totalInterestSaved)
      ..writeByte(10)
      ..write(obj.currentStreakDays)
      ..writeByte(11)
      ..write(obj.lastCheckIn)
      ..writeByte(12)
      ..write(obj.notificationsEnabled)
      ..writeByte(13)
      ..write(obj.soundEnabled)
      ..writeByte(14)
      ..write(obj.hapticsEnabled)
      ..writeByte(15)
      ..write(obj.darkMode)
      ..writeByte(16)
      ..write(obj.onboardingComplete);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
