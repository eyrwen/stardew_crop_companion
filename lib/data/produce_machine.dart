import 'artisan_good_formulator.dart';
import 'crop.dart';

enum ProduceMachine {
  jar("jar", "jar.png", [
    ProduceMachineOutput.jelly(),
    ProduceMachineOutput.pickles(),
  ]),
  keg("keg", "keg.png", [
    ProduceMachineOutput.wine(),
    ProduceMachineOutput.juice(),
  ]),
  vinegarKeg("vinegarKeg", "cornucopia_vinegar_keg.png", []),
  dehydrator("dehydrator", "dehydrator.png", [
    ProduceMachineOutput.driedFruit(),
    ProduceMachineOutput.driedMushroom(),
    ProduceMachineOutput.driedVegetable(),
    ProduceMachineOutput.driedFlower(),
    ProduceMachineOutput.driedHerb(),
  ]),
  yogurtMaker("yogurtJar", "cornucopia_yogurt_jar.png", [
    ProduceMachineOutput.flavoredYogurt(),
  ]),
  oilMaker("oilMaker", "oil_maker.png", []),
  butterChurn("butterChurn", "cornucopia_butter_churn.png", []),

  dryingRack("dryingRack", "cornucopia_drying_rack.png", [
    ProduceMachineOutput.driedFlower(),
    ProduceMachineOutput.driedHerb(),
  ]),
  beehive("beehive", "beehive.png", [ProduceMachineOutput.honey()]),
  alembic("alembic", "cornucopia_alembic.png", [
    ProduceMachineOutput.essentialOil(),
  ]),
  waxBarrel("waxBarrel", "cornucopia_wax_barrel.png", [
    ProduceMachineOutput.candles(),
  ]),
  mill("mill", "mill.png", []),
  cheesePress("cheesePress", "cheese_press.png", []),
  loom("loom", "loom.png", []),
  compactMill("compactMill", "cornucopia_compact_mill.png", []),
  extruder("extruder", "cornucopia_extruder.png", []);

  final String name;
  final String img;
  final List<ProduceMachineOutput> outputs;

  bool supports(CropType crop) {
    return outputs.any((output) => output.from.contains(crop));
  }

  const ProduceMachine(this.name, this.img, this.outputs);
}

class ProduceMachineOutput {
  final String outputName;
  final String outputImg;
  final ArtisanGoodFormulator priceFormulator;
  final ArtisanGoodFormulator energyFormulator;
  final ArtisanGoodFormulator healthFormulator;
  final String time;
  final List<String> favorites;
  final List<CropType> from;

  const ProduceMachineOutput(
    this.outputName,
    this.outputImg,
    this.priceFormulator,
    this.energyFormulator,
    this.healthFormulator,
    this.time, {
    this.favorites = const [],
    required this.from,
  });

  const ProduceMachineOutput.jelly()
    : this(
        "Jelly",
        "jelly.png",
        const PriceFormulator(multiplier: 2.0, plus: 50),
        const EnergyFormulator(multiplier: 2.0, inedibleMultiplier: 0.5),
        const HealthFormulator(multiplier: 2.0, inedibleMultiplier: 0.225),
        "2-3 days",
        from: const [CropType.fruit],
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
        from: const [CropType.vegetable, CropType.forage],
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
        from: const [CropType.fruit],
      );

  const ProduceMachineOutput.juice()
    : this(
        "Juice",
        "juice.png",
        const PriceFormulator(multiplier: 2.25),
        const EnergyFormulator(multiplier: 2.0, inedibleMultiplier: 1.0),
        const HealthFormulator(multiplier: 2.0, inedibleMultiplier: 0.45),
        "4 days",
        favorites: const ["martin"],
        from: const [CropType.vegetable, CropType.forage],
      );

  const ProduceMachineOutput.driedFruit()
    : this(
        "Dried Fruit",
        "dried_fruit.png",
        const PriceFormulator(multiplier: 1.5, plus: 5),
        const EnergyFormulator(
          multiplier: 3,
          inedibleMultiplier: 1.25,
          dividedBy: 5,
        ),
        const HealthFormulator(
          multiplier: 3,
          inedibleMultiplier: 0.5618,
          dividedBy: 5,
        ),
        "1 day",
        from: const [CropType.fruit],
      );

  const ProduceMachineOutput.driedMushroom()
    : this(
        "Dried Mushroom",
        "dried_mushrooms.png",
        const PriceFormulator(multiplier: 1.5, plus: 5),
        const EnergyFormulator(
          multiplier: 3,
          inedibleMultiplier: 1.25,
          dividedBy: 5,
        ),
        const HealthFormulator(
          multiplier: 3,
          inedibleMultiplier: 0.5618,
          dividedBy: 5,
        ),
        "1 day",
        from: const [CropType.mushroom],
      );

  const ProduceMachineOutput.driedVegetable()
    : this(
        "Dried Vegetable",
        "cornucopia_dried_vegetable.png",
        const PriceFormulator(multiplier: 1.5, plus: 5),
        const EnergyFormulator.zero(),
        const HealthFormulator.zero(),
        "30 hrs",
        from: const [CropType.vegetable],
      );

  const ProduceMachineOutput.driedFlower()
    : this(
        "Dried Flower",
        "cornucopia_dried_flower.png",
        const PriceFormulator(multiplier: 10, plus: 50, dividedBy: 5),
        const EnergyFormulator.zero(),
        const HealthFormulator.zero(),
        "30 hrs",
        favorites: const ["evelyn", "haley", "penny"],
        from: const [CropType.flower],
      );

  const ProduceMachineOutput.driedHerb()
    : this(
        "Dried Herb",
        "cornucopia_dried_herb.png",
        const PriceFormulator(multiplier: 10, plus: 50, dividedBy: 5),
        const EnergyFormulator.zero(),
        const HealthFormulator.zero(),
        "30 hrs",
        favorites: const ["gus", "leah"],
        from: const [CropType.herb],
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
        from: const [CropType.flower],
      );

  const ProduceMachineOutput.essentialOil()
    : this(
        "Essential Oil",
        "cornucopia_essential_oil.png",
        const PriceFormulator(multiplier: 10, plus: 50, dividedBy: 5),
        const EnergyFormulator.zero(),
        const HealthFormulator.zero(),
        "40 hrs",
        favorites: const ["emily"],
        from: const [
          CropType.flower,
          CropType.forage,
          CropType.fruit,
          CropType.herb,
          CropType.spice,
          CropType.nut,
          CropType.vegetable,
        ],
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
          CropType.flower,
          CropType.forage,
          CropType.fruit,
          CropType.herb,
          CropType.nut,
          CropType.spice,
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
        from: const [CropType.fruit],
      );
}
