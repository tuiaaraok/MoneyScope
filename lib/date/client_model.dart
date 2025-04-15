import 'package:hive_flutter/hive_flutter.dart';

part 'client_model.g.dart';

@HiveType(typeId: 1)
class ClientModel {
  @HiveField(0)
  String company;
  @HiveField(1)
  String contactPerson;
  @HiveField(2)
  String phoneNumber;
  @HiveField(3)
  String email;
  @HiveField(4)
  List<IssueAnInvoiceModel> paymentHistory;
  ClientModel({
    required this.company,
    required this.contactPerson,
    required this.phoneNumber,
    required this.email,
    required this.paymentHistory,
  });
}

@HiveType(typeId: 2)
class IssueAnInvoiceModel {
  @HiveField(0)
  String client;
  @HiveField(1)
  double sum;
  @HiveField(2)
  DateTime paymentDate;
  @HiveField(3)
  String comment;
  IssueAnInvoiceModel({
    required this.client,
    required this.sum,
    required this.paymentDate,
    required this.comment,
  });
}
