import 'package:hive_flutter/hive_flutter.dart';

part 'finance_operation_model.g.dart';

@HiveType(typeId: 4)
class FinanceOperationModel {
  @HiveField(0)
  String operationCategory;
  @HiveField(1)
  String operationType;
  @HiveField(2)
  double sum;
  @HiveField(3)
  DateTime date;
  FinanceOperationModel(
      {required this.operationCategory,
      required this.operationType,
      required this.sum,
      required this.date});
}
