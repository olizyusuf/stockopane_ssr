import 'package:hive/hive.dart';

part 'stock.g.dart';

@HiveType(typeId: 1)
class Stock {
  @HiveField(0)
  String code;

  @HiveField(1)
  int qty;

  Stock(this.code, this.qty);
}
