// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClientModelAdapter extends TypeAdapter<ClientModel> {
  @override
  final int typeId = 1;

  @override
  ClientModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClientModel(
      company: fields[0] as String,
      contactPerson: fields[1] as String,
      phoneNumber: fields[2] as String,
      email: fields[3] as String,
      paymentHistory: (fields[4] as List).cast<IssueAnInvoiceModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, ClientModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.company)
      ..writeByte(1)
      ..write(obj.contactPerson)
      ..writeByte(2)
      ..write(obj.phoneNumber)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.paymentHistory);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClientModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class IssueAnInvoiceModelAdapter extends TypeAdapter<IssueAnInvoiceModel> {
  @override
  final int typeId = 2;

  @override
  IssueAnInvoiceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IssueAnInvoiceModel(
      client: fields[0] as String,
      sum: fields[1] as double,
      paymentDate: fields[2] as DateTime,
      comment: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, IssueAnInvoiceModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.client)
      ..writeByte(1)
      ..write(obj.sum)
      ..writeByte(2)
      ..write(obj.paymentDate)
      ..writeByte(3)
      ..write(obj.comment);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IssueAnInvoiceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
