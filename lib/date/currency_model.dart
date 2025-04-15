import 'package:hive_flutter/hive_flutter.dart';
part 'currency_model.g.dart';

@HiveType(typeId: 3)
class CurrencyModel {
  @HiveField(0)
  String currency;
  CurrencyModel({required this.currency});
}
