import 'package:hive/hive.dart';

part 'generator.g.dart';

@HiveType(typeId: 0)
class Generator extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String code;

  @HiveField(2)
  String fuel;

  @HiveField(3)
  String usage;

  @HiveField(4)
  String runtime;

  @HiveField(5)
  String remaining;

  @HiveField(6)
  String? imagePath;

  @HiveField(7)
  double? latitude;

  @HiveField(8)
  double? longitude;

  Generator({
    required this.name,
    required this.code,
    required this.fuel,
    required this.usage,
    required this.runtime,
    required this.remaining,
    this.imagePath,
    this.latitude,
    this.longitude,
  });
}
