import 'package:stardew_crop_companion/data/recipe.dart';

import 'artisan_good_formulator.dart';
import 'produce_machine.dart';

enum CropType {
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
  other('other');

  final String name;

  static from(String type) {
    return CropType.values.firstWhere(
      (cropType) => cropType.name == type,
      orElse: () => throw ArgumentError('Unknown crop type: $type'),
    );
  }

  const CropType(this.name);
}

class Crop {
  final String key;
  final String name;
  final CropType type;
  final String img;
  final String url;
  final int price;
  final int energy;
  final int health;
  final bool hasQuality;
  final Map? specialProduce;
  final List<String> favorites;

  List<Recipe> recipes = [];

  Crop({
    required this.key,
    required this.name,
    required this.type,
    required this.img,
    required this.url,
    required this.price,
    required this.energy,
    required this.health,
    this.hasQuality = true,
    this.specialProduce,
    this.favorites = const [],
  });

  get isEdible => energy != 0 || health != 0;
  get isPoison => energy < 0 || health < 0;

  ProduceMachineOutput? getSpecialProduce(ProduceMachine machine) {
    if (specialProduce == null) return null;
    final output = specialProduce![machine.name];
    if (output == null) return null;
    return ProduceMachineOutput(
      output['name'],
      output['img'],
      PriceFormulator.exact(output['price'].toDouble()),
      EnergyFormulator.exact(output['energy'].toDouble()),
      HealthFormulator.exact(output['health'].toDouble()),
      output['time'],
      favorites: output['favorites']?.cast<String>() ?? [],
      from: [],
    );
  }

  Map<ProduceMachine, ProduceMachineOutput> get produceOutputs {
    return ProduceMachine.values.fold(
      <ProduceMachine, ProduceMachineOutput>{},
      (outputs, machine) {
        final special = getSpecialProduce(machine);
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
