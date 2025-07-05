import 'package:stardew_crop_companion/data/produce_machine.dart';

import 'interface.dart';

class AnimalProduct extends Item{
  AnimalProduct({
    required super.key,
    required super.type,
    required super.name,
    required super.img,
    required super.price,
    super.energy = 0,
    super.health = 0,
    super.specialProduce,
    super.url,
    super.hasQuality = true,
    super.favorites = const [],
    super.cookable = true,
  });

  factory AnimalProduct.fromJson(String key, Map<String, dynamic> json) {
    return AnimalProduct(
      key: key,
      type: ItemType.from(json['type']),
      name: json['name'],
      img: json['img'],
      price: json['price'],
      energy: json['energy'] ?? 0,
      health: json['health'] ?? 0,
      hasQuality: json['hasQuality'] ?? true,
      favorites: List<String>.from(json['favorite'] ?? []),
      url: json['url'],
      specialProduce: json['specialProduce'] != null
          ? (json['specialProduce'] as Map<String, dynamic>).map(
              (key, value) => MapEntry(
                ProduceMachine.from(key),
                ProduceMachineOutput.fromJson(value as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }
}
