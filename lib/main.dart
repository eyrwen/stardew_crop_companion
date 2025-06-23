import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:url_launcher/url_launcher_string.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stardew Crop Companion',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends HookWidget {
  const MyHomePage({super.key});

  _loadCrops() async {
    return json.decode(await rootBundle.loadString('assets/crops.json'));
  }

  @override
  Widget build(BuildContext context) {
    final crops = useFuture(_loadCrops());
    final viewingCrop = useState<Map?>(null);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/bg_day.png'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(8.0),
        child: viewingCrop.value == null
            ? (crops.data == null
                  ? CircularProgressIndicator()
                  : CropGrid(
                      crops: (crops.data as Map),
                      onCropSelected: (crop) => viewingCrop.value = crop,
                    ))
            : CropPage(
                crop: viewingCrop.value!,
                onBack: () => viewingCrop.value = null,
              ),
      ),
    );
  }
}

class CropPage extends StatelessWidget {
  final Map crop;
  final VoidCallback onBack;

  const CropPage({super.key, required this.crop, required this.onBack});

  get type => switch (crop['type']) {
    'fruit' => CropType.fruit,
    'vegetable' => CropType.vegetable,
    'forage' => CropType.forage,
    'mushroom' => CropType.mushroom,
    'flower' => CropType.flower,
    'seed' => CropType.seed,
    'other' => CropType.other,
    _ => throw ArgumentError('Unknown crop type: ${crop['type']}'),
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        spacing: 16.0,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(icon: Icon(Icons.arrow_back), onPressed: () => onBack()),
          CropGeneralDetails(
            name: crop['name'],
            img: crop['img'],
            seasons: crop['seasons'],
            url: crop['url'],
            favorites: crop?['favorite'] ?? [],
          ),
          Column(
            spacing: 16.0,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CropRawValues(
                basePrice: crop['price'],
                baseEnergy: crop['energy'],
                baseHealth: crop['health'],
                hasQuality: crop['quality'] != false && crop['energy'] >= 0,
              ),
              type == CropType.other || crop['energy'] < 0
                  ? SizedBox.shrink()
                  : CropProduceValues(
                      type: type,
                      basePrice: crop['price'],
                      baseEnergy: crop['energy'],
                      baseHealth: crop['health'],
                      special: crop['specialProduce'],
                    ),
            ],
          ),
        ],
      ),
    );
  }
}

class CropRawValues extends StatelessWidget {
  final int basePrice;
  final int baseEnergy;
  final int baseHealth;
  final bool hasQuality;

  const CropRawValues({
    super.key,
    required this.basePrice,
    required this.baseEnergy,
    required this.baseHealth,
    this.hasQuality = false,
  });

  get silverPrice => (basePrice * 1.25).floor();
  get silverEnergy => (baseEnergy * 1.4).floor();
  get silverHealth => (baseHealth * 1.4).round();

  get goldPrice => (basePrice * 1.5).floor();
  get goldEnergy => (baseEnergy * 1.8).floor();
  get goldHealth => (baseHealth * 1.8).round();

  get iridiumPrice => (basePrice * 2).floor();
  get iridiumEnergy => (baseEnergy * 2.6).floor();
  get iridiumHealth => (baseHealth * 2.6).round();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          spacing: 48,
          children: [
            CropValueColumn(
              price: basePrice,
              energy: baseEnergy,
              health: baseHealth,
            ),
            if (hasQuality) ...[
              CropValueColumn.silver(
                price: silverPrice,
                energy: silverEnergy,
                health: silverHealth,
              ),
              CropValueColumn.gold(
                price: goldPrice,
                energy: goldEnergy,
                health: goldHealth,
              ),
              CropValueColumn.iridium(
                price: iridiumPrice,
                energy: iridiumEnergy,
                health: iridiumHealth,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class CropProduceValues extends StatelessWidget {
  final int basePrice;
  final int baseEnergy;
  final int baseHealth;
  final CropType type;
  final Map? special;

  const CropProduceValues({
    super.key,
    required this.basePrice,
    required this.baseEnergy,
    required this.baseHealth,
    required this.type,
    this.special,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 32,
          children: [
            if (![CropType.flower, CropType.seed].contains(type))
              CropProduceColumn.jar(
                type: type,
                basePrice: basePrice,
                baseEnergy: baseEnergy,
                baseHealth: baseHealth,
              ),
            if (![CropType.mushroom, CropType.flower].contains(type))
              CropProduceColumn.keg(
                type: type,
                basePrice: basePrice,
                baseEnergy: baseEnergy,
                baseHealth: baseHealth,
                price: special?['keg']?['price'],
                energy: special?['keg']?['energy'],
                health: special?['keg']?['health'],
                duration: special?['keg']?['time'],
                outputImg: special?['keg']?['img'],
                favorites: special?['keg']?['favorite'],
              ),
            if ([
              CropType.mushroom,
              CropType.fruit,
              CropType.vegetable,
            ].contains(type))
              CropProduceColumn.dehydrator(
                type: type,
                basePrice: basePrice,
                baseEnergy: baseEnergy,
                baseHealth: baseHealth,
                price: special?['dehydrator']?['price'],
                energy: special?['dehydrator']?['energy'],
                health: special?['dehydrator']?['health'],
                outputImg: special?['dehydrator']?['img'],
                favorites: special?['dehydrator']?['favorite'],
              ),
            if (special?['mill'] != null)
              CropProduceColumn.mill(
                type: type,
                energy: special!['mill']['energy'],
                health: special!['mill']['health'],
                price: special!['mill']['price'],
                outputImg: special!['mill']['img'],
                favorites: special!['mill']['favorite'] ?? [],
              ),
            if (special?['oilMaker'] != null)
              CropProduceColumn.oilMaker(
                type: type,
                outputImg: special!['oilMaker']['img'],
                duration: special!['oilMaker']['time'],
                price: special!['oilMaker']['price'],
                energy: special!['oilMaker']['energy'],
                health: special!['oilMaker']['health'],
                favorites: special!['oilMaker']['favorite'] ?? [],
              ),
            if (type == CropType.flower) ...[
              CropProduceColumn.beehive(basePrice: basePrice),
              CropProduceColumn.dryingRack(type: type, basePrice: basePrice),
            ],
          ],
        ),
      ),
    );
  }
}

class CropProduceColumn extends StatelessWidget {
  final String machineImg;
  final String outputImg;
  final String duration;
  final int price;
  final int energy;
  final int health;
  final CropType type;
  final List? favorites;

  const CropProduceColumn({
    super.key,
    required this.machineImg,
    required this.outputImg,
    required this.duration,
    required this.price,
    required this.energy,
    required this.health,
    required this.type,
    favorites,
  }) : favorites = favorites ?? const [];

  CropProduceColumn.jar({
    super.key,
    outputImg,
    required this.type,
    required basePrice,
    required baseEnergy,
    required baseHealth,
    favorites,
  }) : machineImg = 'jar.png',
       outputImg =
           outputImg ?? (type == CropType.fruit ? 'jelly.png' : 'pickles.png'),
       favorites =
           favorites ??
           ([CropType.vegetable, CropType.forage].contains(type)
               ? ['harvey']
               : []),
       price = basePrice * 2 + 50,
       duration = '2-3 days',
       energy = switch (type) {
         CropType.fruit =>
           baseEnergy == 0 ? (basePrice * 0.5).ceil() : (baseEnergy * 2),
         CropType.vegetable || CropType.forage || CropType.mushroom =>
           baseEnergy == 0
               ? (basePrice * 0.625).ceil()
               : (baseEnergy * 1.75).ceil(),
         _ => throw ArgumentError('Jar is not applicable for type $type'),
       },
       health = switch (type) {
         CropType.fruit =>
           baseHealth == 0 ? (basePrice * 0.225).floor() : (baseHealth * 2),
         CropType.vegetable || CropType.forage || CropType.mushroom =>
           baseHealth == 0
               ? (basePrice * 0.28125).floor()
               : (baseHealth * 1.75).floor(),
         _ => throw ArgumentError('Jar is not applicable for type $type'),
       };

  CropProduceColumn.keg({
    super.key,
    outputImg,
    required this.type,
    basePrice,
    baseEnergy,
    baseHealth,
    price,
    energy,
    health,
    duration,
    favorites,
  }) : assert(
         basePrice != null || price != null,
         "Base price or price must be provided",
       ),
       assert(
         baseEnergy != null || energy != null,
         "Base energy or energy must be provided",
       ),
       assert(
         baseHealth != null || health != null,
         "Base health or health must be provided",
       ),
       machineImg = 'keg.png',
       outputImg =
           outputImg ?? (type == CropType.fruit ? 'wine.png' : 'juice.png'),
       favorites =
           favorites ??
           (switch (type) {
             CropType.fruit => ['olivia'],
             CropType.vegetable || CropType.forage => ['martin'],
             _ => [],
           }),
       price =
           price ??
           switch (type) {
             CropType.fruit => basePrice * 3,
             CropType.vegetable ||
             CropType.forage => (basePrice * 2.25).floor(),
             _ => throw ArgumentError('Keg is not applicable for type $type'),
           },
       duration =
           duration ??
           switch (type) {
             CropType.fruit => '6.25 days',
             CropType.vegetable || CropType.forage => '4 days',
             _ => throw ArgumentError('Keg is not applicable for type $type'),
           },
       energy =
           energy ??
           switch (type) {
             CropType.fruit =>
               (baseEnergy == 0 ? (basePrice * 0.25) : (baseEnergy * 1.75))
                   .ceil(),
             CropType.vegetable ||
             CropType.forage => baseEnergy == 0 ? basePrice : baseEnergy * 2,
             _ => throw ArgumentError('Keg is not applicable for type $type'),
           },
       health =
           health ??
           switch (type) {
             CropType.fruit =>
               (baseHealth == 0 ? (basePrice * 0.1125) : (baseHealth * 1.75))
                   .floor(),
             CropType.vegetable || CropType.forage =>
               baseHealth == 0 ? (basePrice * 0.45).floor() : baseHealth * 2,
             _ => throw ArgumentError('Keg is not applicable for type $type'),
           };

  CropProduceColumn.dehydrator({
    super.key,
    outputImg,
    required this.type,
    basePrice,
    baseEnergy,
    baseHealth,
    energy,
    health,
    price,
    this.favorites = const [],
  }) : assert(
         basePrice != null || price != null,
         "Base price or price must be provided",
       ),
       assert(
         baseEnergy != null || energy != null,
         "Base energy or energy must be provided",
       ),
       assert(
         baseHealth != null || health != null,
         "Base health or health must be provided",
       ),
       machineImg = 'dehydrator.png',
       outputImg =
           outputImg ??
           (switch (type) {
             CropType.fruit => 'dried_fruit.png',
             CropType.mushroom => 'dried_mushroom.png',
             CropType.vegetable => 'dried_vegetable.png',
             _ => throw ArgumentError(
               'Dehydrator is not applicable for type $type',
             ),
           }),
       price = price ?? (basePrice * 1.5 + 5).floor(),
       duration = type == CropType.vegetable ? "30 hr" : '1 day',
       energy =
           energy ??
           (type == CropType.vegetable
               ? 0
               : ((baseEnergy == 0
                             ? (basePrice * 1.25).ceil()
                             : (baseEnergy * 3)) /
                         5)
                     .round()),
       health =
           health ??
           (type == CropType.vegetable
               ? 0
               : ((baseHealth == 0
                             ? (basePrice * 0.5618).floor()
                             : (baseHealth * 3)) /
                         5)
                     .round());

  const CropProduceColumn.mill({
    super.key,
    required this.outputImg,
    required this.type,
    required this.energy,
    required this.health,
    required this.price,
    this.favorites = const [],
  }) : machineImg = 'mill.png',
       duration = '1 day';

  const CropProduceColumn.beehive({
    super.key,
    required basePrice,
    favorites = const [],
  }) : machineImg = 'beehive.png',
       outputImg = 'honey.png',
       favorites = favorites ?? const ['scarlett'],
       duration = '4 days',
       price = basePrice * 2 + 100,
       energy = 0,
       health = 0,
       type = CropType.flower;

  const CropProduceColumn.dryingRack({
    super.key,
    required this.type,
    basePrice,
    favorites = const [],
  }) : machineImg = 'drying_rack.png',
       outputImg = type == CropType.flower
           ? 'dried_flower.png'
           : 'dried_herb.png',
       favorites =
           favorites ??
           (type == CropType.flower
               ? const ['evelyn', 'haley', 'penny']
               : const []),
       duration = '34 hrs',
       price = (basePrice * 10 + 50) ~/ 5,
       energy = 0,
       health = 0;

  const CropProduceColumn.oilMaker({
    super.key,
    required this.type,
    required this.outputImg,
    required this.duration,
    required this.price,
    required this.energy,
    required this.health,
    this.favorites = const [],
  }) : machineImg = 'oil_maker.png';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomLeft,
          clipBehavior: Clip.none,
          children: [
            Image.asset('assets/img/$machineImg', height: 96),
            Positioned(
              left: -8,
              bottom: -4,
              child: Image.asset('assets/img/$outputImg', scale: 2),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          spacing: 8.0,
          children: [
            Image.asset('assets/img/time.png', height: 16),
            Text(
              duration,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        CropValueColumn(price: price, energy: energy, health: health),
        favorites != null && favorites!.isNotEmpty
            ? Favorites(favorites: favorites!)
            : SizedBox.shrink(),
      ],
    );
  }
}

class CropValueColumn extends StatelessWidget {
  final int price;
  final int energy;
  final int health;
  final String? quality;

  const CropValueColumn({
    super.key,
    required this.price,
    required this.energy,
    required this.health,
    this.quality,
  });

  const CropValueColumn.gold({
    super.key,
    required this.price,
    required this.energy,
    required this.health,
  }) : quality = 'gold';

  const CropValueColumn.silver({
    super.key,
    required this.price,
    required this.energy,
    required this.health,
  }) : quality = 'silver';

  const CropValueColumn.iridium({
    super.key,
    required this.price,
    required this.energy,
    required this.health,
  }) : quality = 'iridium';

  _overlayedImage(String img) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Image.asset('assets/img/$img'),
        if (quality != null)
          Image.asset('assets/img/${quality}_quality_overlay.png', scale: 1.25),
      ],
    );
  }

  get inedible => energy == 0 && health == 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (energy != 0)
          Row(
            children: [
              _overlayedImage(energy < 0 ? 'poison.png' : 'energy.png'),
              Text('$energy', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        if (health != 0)
          Row(
            children: [
              _overlayedImage('health.png'),
              Text('$health', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        Row(
          children: [
            _overlayedImage('gold.png'),
            Text('${price}G', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}

class CropGeneralDetails extends StatelessWidget {
  final String name;
  final String img;
  final List seasons;
  final List favorites;
  final String url;

  const CropGeneralDetails({
    super.key,
    required this.name,
    required this.img,
    required this.seasons,
    required this.url,
    required this.favorites,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 8,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/img/$img'),
            InkWell(
              onTap: () => launchUrlString(url),
              child: Text(
                name,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: seasons.map((season) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Image.asset('assets/img/$season.png', height: 16),
                    Text(
                      season.replaceFirst(season[0], season[0].toUpperCase()),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                );
              }).toList(),
            ),
            favorites.isNotEmpty
                ? Favorites(favorites: favorites)
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

class Favorites extends StatelessWidget {
  final List favorites;

  const Favorites({super.key, required this.favorites});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            SizedBox(height: 3),
            Image.asset('assets/img/heart.png', height: 16),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: favorites
              .map(
                (fav) => Row(
                  spacing: 4,
                  children: [
                    Image.asset(
                      'assets/img/${fav.toString().toLowerCase()}.png',
                      height: 16,
                    ),
                    Text(
                      fav.replaceFirst(fav[0], fav[0].toUpperCase()),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class CropGrid extends StatelessWidget {
  final Map crops;
  final Function(Map) onCropSelected;

  const CropGrid({
    super.key,
    required this.crops,
    required this.onCropSelected,
  });

  get _sortedCrops =>
      crops.values.toList()..sort((a, b) => a['name'].compareTo(b['name']));

  @override
  Widget build(BuildContext context) {
    return GridView.extent(
      maxCrossAxisExtent: 200,
      children: _sortedCrops.map<Widget>((crop) {
        return Card(
          child: InkWell(
            onTap: () => onCropSelected(crop),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/img/${crop['img']}'),
                  Text(crop['name'], overflow: TextOverflow.clip),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

enum CropType { fruit, vegetable, forage, mushroom, flower, herb, seed, other }
