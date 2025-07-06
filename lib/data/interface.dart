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
  egg('egg'),
  milk('milk'),
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

  final int energy;
  final int health;
  final Map<ProduceMachine, ProduceMachineOutput>? specialProduce;

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
    this.energy = 0,
    this.health = 0,
    this.specialProduce = const {},
  }) : url =
           url ?? 'https://stardewvalleywiki.com/${name.split(' ').join('_')}';

  Item.fromJson(this.key, Map<String, dynamic> json)
    : type = ItemType.from(json['type']),
      name = json['name'],
      img = json['img'],
      url =
          json['url'] ??
          'https://stardewvalleywiki.com/${json['name'].split(' ').join('_')}',
      price = json['price'],
      hasQuality = json['hasQuality'] ?? true,
      favorites = List<String>.from(json['favorite'] ?? []),
      cookable = json['cookable'] ?? true,
      energy = json['energy'] ?? 0,
      health = json['health'] ?? 0,
      specialProduce = json['specialProduce'] != null
          ? (json['specialProduce'] as Map<String, dynamic>).map(
              (key, value) => MapEntry(
                ProduceMachine.from(key),
                ProduceMachineOutput.fromJson(value as Map<String, dynamic>),
              ),
            )
          : null;

  get producable => produceOutputs.isNotEmpty;

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
