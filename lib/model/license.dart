import 'package:hive/hive.dart';

part 'license.g.dart';

@HiveType(typeId: 2)
class License {
  @HiveField(0)
  String macAddress;

  @HiveField(1)
  String serialNumber;

  License(this.macAddress, this.serialNumber);
}
