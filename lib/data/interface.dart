import 'produce_machine.dart';

enum ItemType {
  fruit('fruit'),
  vegetable('vegetable'),
  forage('forage'),
  mushroom('mushroom'),
  flower('flower'),
  herb('herb'),
  nut('nut'),
  spice('spice'),
  seed('seed'),
  fiber('fiber'),
  fish('fish'),
  crabpotcatch('crabpotcatch'),
  animalproduct('animalproduct'),
  recipe('recipe'),
  other('other');

  final String name;

  static ItemType from(String type) {
    return ItemType.values.firstWhere(
      (itemType) => itemType.name == type,
      orElse: () => throw ArgumentError('Unknown item type: $type'),
    );
  }

  const ItemType(this.name);
}

abstract class Item {
  final String key;
  final ItemType type;
  final String name;
  final String img;
  final String url;
  final int price;
  final bool hasQuality;
  final List<String> favorites;
  final bool cookable;

  Item({
    required this.key,
    required this.type,
    required this.name,
    required this.img,
    url,
    required this.price,
    this.hasQuality = true,
    this.favorites = const [],
    this.cookable = true,
  }) : url =
           url ?? 'https://stardewvalleywiki.com/${name.split(' ').join('_')}';

  Item.fromJson(this.key, Map<String, dynamic> json)
    : type = ItemType.from(json['type']),
      name = json['name'],
      img = json['img'],
      url = json['url'],
      price = json['price'],
      hasQuality = json['hasQuality'] ?? true,
      favorites = List<String>.from(json['favorite'] ?? []),
      cookable = json['cookable'] ?? true;
}

abstract class Edible extends Item {
  final int energy;
  final int health;
  final Map<ProduceMachine, ProduceMachineOutput>? specialProduce;

  Edible({
    required super.key,
    required super.type,
    required super.name,
    required super.img,
    super.url,
    required super.price,
    super.cookable = true,
    super.hasQuality = true,
    super.favorites = const [],
    this.energy = 0,
    this.health = 0,
    this.specialProduce,
  });

  bool get isEdible => energy != 0 || health != 0;
  bool get isPoison => energy < 0 || health < 0;

  Edible.fromJson(super.key, super.json)
    : energy = json['energy'] ?? 0,
      health = json['health'] ?? 0,
      specialProduce = json['specialProduce'] != null
          ? (json['specialProduce'] as Map<String, dynamic>).map(
              (key, value) => MapEntry(
                ProduceMachine.from(key),
                ProduceMachineOutput.fromJson(value as Map<String, dynamic>),
              ),
            )
          : null,
      super.fromJson();
}

mixin Producable on Edible {
  Map<ProduceMachine, ProduceMachineOutput> get produceOutputs {
    return ProduceMachine.values.fold(
      <ProduceMachine, ProduceMachineOutput>{},
      (outputs, machine) {
        final special = specialProduce?[machine];
        if (special != null) {
          return {...outputs, machine: special};
        } else if (machine.supports(type)) {
          return {
            ...outputs,
            machine: machine.outputs.firstWhere(
              (output) => output.from.contains(type),
            ),
          };
        }

        return outputs;
      },
    );
  }
}
