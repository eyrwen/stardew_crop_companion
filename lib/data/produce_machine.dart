import 'artisan_good_formulator.dart';
import 'interface.dart';

enum ProduceMachine {
  mayonnaiseMachine(
    "mayonnaiseMachine",
    "Mayonnaise Machine",
    "mayonnaise_machine.png",
    [],
  ),
  oilMaker("oilMaker", "Oil Maker", "oil_maker.png", []),
  mill("mill", "Mill", "mill.png", []),
  butterChurn("butterChurn", "Butter Churn", "cornucopia_butter_churn.png", [
    ProduceMachineOutput.nutButter(),
    ProduceMachineOutput.butter(),
  ]),
  compactMill("compactMill", "Compact Mill", "cornucopia_compact_mill.png", []),
  jar("jar", "Jar", "jar.png", [
    ProduceMachineOutput.jelly(),
    ProduceMachineOutput.pickles(),
  ]),
  keg("keg", "Keg", "keg.png", [
    ProduceMachineOutput.wine(),
    ProduceMachineOutput.juice(),
    ProduceMachineOutput.nutMilk(),
  ]),
  juicer('juicer', 'Juice Keg', 'cornucopia_juicer.png', [
    ProduceMachineOutput.juice(
      from: [ItemType.fruit, ItemType.vegetable, ItemType.forage],
    ),
  ]),
  vinegarKeg("vinegarKeg", "Vinegar Keg", "cornucopia_vinegar_keg.png", []),
  yogurtMaker("yogurtJar", "Yogurt Jar", "cornucopia_yogurt_jar.png", [
    ProduceMachineOutput.flavoredYogurt(),
    ProduceMachineOutput.plainYogurt(),
  ]),
  beehive("beehive", "Beehive", "beehive.png", [ProduceMachineOutput.honey()]),
  smoker("smoker", "Fish Smoker", "fish_smoker.png", [
    ProduceMachineOutput.smokedFish(),
  ]),
  deluxeSmoker(
    "deluxeSmoker",
    "Deluxe Smoker",
    "cornucopia_deluxe_smoker.png",
    [ProduceMachineOutput.smokedEgg()],
  ),
  cheesePress("cheesePress", "Cheese Press", "cheesePress.png", [
    ProduceMachineOutput.cheese(),
  ]),
  loom("loom", "Loom", "loom.png", []),
  extruder("extruder", "Extruder", "cornucopia_extruder.png", []),

  waxBarrel("waxBarrel", "Wax Barrel", "cornucopia_wax_barrel.png", [
    ProduceMachineOutput.candles(),
  ]),
  dehydrator("dehydrator", "Dehydrator", "dehydrator.png", [
    ProduceMachineOutput.driedFruit(),
    ProduceMachineOutput.driedMushroom(),
    ProduceMachineOutput.driedVegetable(),
    ProduceMachineOutput.driedFlower(),
    ProduceMachineOutput.driedHerb(),
  ]),
  dryingRack("dryingRack", "Drying Rack", "cornucopia_drying_rack.png", [
    ProduceMachineOutput.driedFlower(),
    ProduceMachineOutput.driedHerb(),
  ]),
  alembic("alembic", "Alembic", "cornucopia_alembic.png", [
    ProduceMachineOutput.essentialOil(),
  ]);

  final String key;
  final String name;
  final String img;
  final List<ProduceMachineOutput> outputs;

  bool supports(ItemType type) {
    return outputs.any((output) => output.from.contains(type));
  }

  static ProduceMachine from(String value) {
    return ProduceMachine.values.firstWhere(
      (e) => e.key == value,
      orElse: () => throw ArgumentError('Unknown produce machine: $value'),
    );
  }

  const ProduceMachine(this.key, this.name, this.img, this.outputs);
}

class ProduceMachineOutput {
  final String outputName;
  final String? outputImg;
  final int outputCount;
  final ArtisanGoodFormulator priceFormulator;
  final ArtisanGoodFormulator energyFormulator;
  final ArtisanGoodFormulator healthFormulator;
  final String time;
  final List<String> favorites;
  final List<ItemType> from;
  final int inputCount;
  final String? outputQuality;

  get multiInput => inputCount > 1;
  get multiOutput => outputCount > 1;

  const ProduceMachineOutput(
    this.outputName,
    this.outputImg,
    this.priceFormulator,
    this.energyFormulator,
    this.healthFormulator,
    this.time, {
    this.favorites = const [],
    required this.from,
    this.inputCount = 1,
    this.outputCount = 1,
    this.outputQuality,
  });

  ProduceMachineOutput.fromJson(Map<String, dynamic> json)
    : outputName = json['name'],
      outputImg = json['img'],
      outputQuality = json['quality'],
      outputCount = json['outputCount'] ?? 1,
      inputCount = json['inputCount'] ?? 1,
      priceFormulator = json['priceFormulator'] != null
          ? PriceFormulator.fromJson(json['priceFormulator'])
          : PriceFormulator.exact(json['price'].toDouble()),
      energyFormulator = EnergyFormulator.exact(json['energy'].toDouble()),
      healthFormulator = HealthFormulator.exact(json['health'].toDouble()),
      time = json['time'],
      favorites = List<String>.from(json['favorite'] ?? []),
      from = List<String>.from(
        json['from'] ?? [],
      ).map((e) => ItemType.from(e)).toList();

  const ProduceMachineOutput.jelly()
    : this(
        "Jelly",
        "jelly.png",
        const PriceFormulator(multiplier: 2.0, plus: 50),
        const EnergyFormulator(multiplier: 2.0, inedibleMultiplier: 0.5),
        const HealthFormulator(multiplier: 2.0, inedibleMultiplier: 0.225),
        "2-3 days",
        from: const [ItemType.fruit],
      );

  const ProduceMachineOutput.pickles()
    : this(
        "Pickles",
        "pickles.png",
        const PriceFormulator(multiplier: 2.0, plus: 50),
        const EnergyFormulator(multiplier: 1.75, inedibleMultiplier: 0.625),
        const HealthFormulator(multiplier: 1.75, inedibleMultiplier: 0.28125),
        "2-3 days",
        favorites: const ["harvey"],
        from: const [ItemType.vegetable, ItemType.forage],
      );

  const ProduceMachineOutput.wine()
    : this(
        "Wine",
        "wine.png",
        const PriceFormulator(multiplier: 3.0),
        const EnergyFormulator(multiplier: 1.75, inedibleMultiplier: 0.25),
        const HealthFormulator(multiplier: 1.75, inedibleMultiplier: 0.1125),
        "6.25 days",
        favorites: const ["olivia"],
        from: const [ItemType.fruit],
      );

  const ProduceMachineOutput.juice({
    from = const [ItemType.vegetable, ItemType.forage],
  }) : this(
         "Juice",
         "juice.png",
         const PriceFormulator(multiplier: 2.25),
         const EnergyFormulator(multiplier: 2.0, inedibleMultiplier: 1.0),
         const HealthFormulator(multiplier: 2.0, inedibleMultiplier: 0.45),
         "4 days",
         favorites: const ["martin"],
         from: from,
       );

  const ProduceMachineOutput.driedFruit()
    : this(
        "Dried Fruit",
        "dried_fruit.png",
        const PriceFormulator(multiplier: 7.5, plus: 25),
        const EnergyFormulator(multiplier: 3, inedibleMultiplier: 1.25),
        const HealthFormulator(multiplier: 3, inedibleMultiplier: 0.5618),
        "1 day",
        from: const [ItemType.fruit],
        inputCount: 5,
      );

  const ProduceMachineOutput.driedMushroom()
    : this(
        "Dried Mushroom",
        "dried_mushrooms.png",
        const PriceFormulator(multiplier: 7.5, plus: 25),
        const EnergyFormulator(multiplier: 3, inedibleMultiplier: 1.25),
        const HealthFormulator(multiplier: 3, inedibleMultiplier: 0.5618),
        "1 day",
        from: const [ItemType.mushroom],
        inputCount: 5,
      );

  const ProduceMachineOutput.driedVegetable()
    : this(
        "Dried Vegetable",
        "cornucopia_dried_vegetable.png",
        const PriceFormulator(multiplier: 7.5, plus: 25),
        const EnergyFormulator.zero(),
        const HealthFormulator.zero(),
        "30 hrs",
        from: const [ItemType.vegetable],
        inputCount: 5,
      );

  const ProduceMachineOutput.driedFlower([String? duration])
    : this(
        "Dried Flower",
        "cornucopia_dried_flower.png",
        const PriceFormulator(multiplier: 10, plus: 50),
        const EnergyFormulator.zero(),
        const HealthFormulator.zero(),
        duration ?? "30 hrs",
        favorites: const ["evelyn", "haley", "penny"],
        from: const [ItemType.flower],
        inputCount: 5,
      );

  const ProduceMachineOutput.driedHerb()
    : this(
        "Dried Herb",
        "cornucopia_dried_herb.png",
        const PriceFormulator(multiplier: 10, plus: 50),
        const EnergyFormulator.zero(),
        const HealthFormulator.zero(),
        "30 hrs",
        favorites: const ["gus", "leah"],
        from: const [ItemType.herb],
        inputCount: 5,
      );

  const ProduceMachineOutput.honey()
    : this(
        "Honey",
        "honey.png",
        const PriceFormulator(multiplier: 2, plus: 100),
        const EnergyFormulator.zero(),
        const HealthFormulator.zero(),
        "4 days",
        favorites: const ["scarlett"],
        from: const [ItemType.flower],
      );

  const ProduceMachineOutput.essentialOil()
    : this(
        "Essential Oil",
        "cornucopia_essential_oil.png",
        const PriceFormulator(multiplier: 10, plus: 50),
        const EnergyFormulator.zero(),
        const HealthFormulator.zero(),
        "40 hrs",
        favorites: const ["emily"],
        from: const [
          ItemType.flower,
          ItemType.forage,
          ItemType.fruit,
          ItemType.herb,
          ItemType.spice,
          ItemType.nut,
          ItemType.vegetable,
        ],
        inputCount: 5,
      );

  const ProduceMachineOutput.candles()
    : this(
        "Candles",
        "cornucopia_candles.png",
        const PriceFormulator(multiplier: 3, plus: 250),
        const EnergyFormulator.zero(),
        const HealthFormulator.zero(),
        "16 hrs",
        favorites: const ["evelyn"],
        from: const [
          ItemType.flower,
          ItemType.forage,
          ItemType.fruit,
          ItemType.herb,
          ItemType.nut,
          ItemType.spice,
        ],
      );

  const ProduceMachineOutput.flavoredYogurt()
    : this(
        "Flavored Yogurt",
        "cornucopia_flavored_yogurt.png",
        const PriceFormulator(multiplier: 2, plus: 250),
        const EnergyFormulator.exact(38.0),
        const HealthFormulator.exact(17.0),
        "16 hrs",
        favorites: const ["jas", "marnie"],
        from: const [ItemType.fruit],
      );

  const ProduceMachineOutput.smokedFish()
    : this(
        "Smoked Fish",
        "smoked_fish.png",
        const PriceFormulator(multiplier: 2),
        const EnergyFormulator(multiplier: 1.5, inedibleMultiplier: 0.3),
        const HealthFormulator(multiplier: 1.5, inedibleMultiplier: 0.3),
        "50 mins",
        from: const [ItemType.fish, ItemType.crabpotcatch],
      );

  const ProduceMachineOutput.nutMilk()
    : this(
        "Nut Milk",
        "nut_milk.png",
        const PriceFormulator(multiplier: 2.25),
        const EnergyFormulator.exact(50.0),
        const HealthFormulator.exact(22.0),
        "38 hrs",
        from: const [ItemType.nut],
      );

  const ProduceMachineOutput.nutButter()
    : this(
        "Nut Butter",
        "nut_butter.png",
        const PriceFormulator(multiplier: 1.5),
        const EnergyFormulator.zero(),
        const HealthFormulator.zero(),
        "3 hrs",
        from: const [ItemType.nut],
      );

  const ProduceMachineOutput.fishOil()
    : this(
        "Fish Oil",
        "fish_oil.png",
        const PriceFormulator.exact(140.0),
        const EnergyFormulator.exact(5.0),
        const HealthFormulator.exact(13.0),
        "16 hrs",
        from: const [ItemType.fish],
      );

  const ProduceMachineOutput.smokedEgg()
    : this(
        "Smoked Egg",
        "smoked_egg.png",
        const PriceFormulator(multiplier: 2),
        const EnergyFormulator.exact(45.0),
        const HealthFormulator.exact(20.0),
        "12 hrs",
        from: const [ItemType.egg],
      );

  const ProduceMachineOutput.mayonnaise()
    : this(
        "Mayonnaise",
        "mayonnaise.png",
        const PriceFormulator.exact(190.0),
        const EnergyFormulator.exact(50.0),
        const HealthFormulator.exact(22.5),
        "3 hrs",
        from: const [ItemType.egg],
      );

  const ProduceMachineOutput.pickledEggs()
    : this(
        "Pickled Eggs",
        "pickled_eggs.png",
        const PriceFormulator(multiplier: 3.0, plus: 50.0),
        const EnergyFormulator.exact(40.0),
        const HealthFormulator.exact(18.0),
        "67 hrs",
        from: const [ItemType.egg],
      );

  const ProduceMachineOutput.pickledFish()
    : this(
        "Pickled Fish",
        "pickled_fish.png",
        const PriceFormulator(multiplier: 3.0, plus: 50),
        const EnergyFormulator.zero(),
        const HealthFormulator.zero(),
        "67 hrs",
        from: const [ItemType.fish],
        favorites: const ["willy"],
      );

  const ProduceMachineOutput.cheese()
    : this(
        "Cheese",
        "cheese.png",
        const PriceFormulator.exact(230.0),
        const EnergyFormulator.exact(125.0),
        const HealthFormulator.exact(56.0),
        "3 hrs",
        from: const [ItemType.milk],
      );

  const ProduceMachineOutput.butter()
    : this(
        "Butter",
        "butter.png",
        const PriceFormulator.exact(200.0),
        const EnergyFormulator.zero(),
        const HealthFormulator.zero(),
        "2 hrs",
        from: const [ItemType.milk],
      );

  const ProduceMachineOutput.plainYogurt()
    : this(
        "Plain Yogurt",
        "plain_yogurt.png",
        const PriceFormulator.exact(200.0),
        const EnergyFormulator.exact(38.0),
        const HealthFormulator.exact(17.0),
        "7 hrs",
        from: const [ItemType.milk],
        favorites: const ["marnie"],
      );
}
