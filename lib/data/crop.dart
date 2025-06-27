import 'interface.dart';

class Crop extends Edible with Producable {
  Crop({
    required super.key,
    required super.type,
    required super.name,
    required super.img,
    required super.url,
    required super.price,
    super.hasQuality = true,
    super.favorites = const [],
    super.energy = 0,
    super.health = 0,
    specialProduce = const {},
  });

  Crop.fromJson(super.key, super.json) : super.fromJson();
}
