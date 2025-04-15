// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finance_operation_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FinanceOperationModelAdapter extends TypeAdapter<FinanceOperationModel> {
  @override
  final int typeId = 4;

  @override
  FinanceOperationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FinanceOperationModel(
      operationCategory: fields[0] as String,
      operationType: fields[1] as String,
      sum: fields[2] as double,
      date: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, FinanceOperationModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.operationCategory)
      ..writeByte(1)
      ..write(obj.operationType)
      ..writeByte(2)
      ..write(obj.sum)
      ..writeByte(3)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FinanceOperationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
