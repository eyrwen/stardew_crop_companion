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
                basePrice: crop['value'],
                baseEnergy: crop['energy'],
                baseHealth: crop['health'],
              ),
              crop['energy'] < 0 || crop['health'] < 0
                  ? SizedBox.shrink()
                  : CropProduceValues(
                      type: crop['type'],
                      basePrice: crop['value'],
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

  const CropRawValues({
    super.key,
    required this.basePrice,
    required this.baseEnergy,
    required this.baseHealth,
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
        padding: const EdgeInsets.all(8.0),
        child: Row(
          spacing: 16,
          children: [
            CropValueColumn(
              price: basePrice,
              energy: baseEnergy,
              health: baseHealth,
            ),
            VerticalDivider(thickness: 2),
            CropValueColumn.silver(
              price: silverPrice,
              energy: silverEnergy,
              health: silverHealth,
            ),
            VerticalDivider(thickness: 2),
            CropValueColumn.gold(
              price: goldPrice,
              energy: goldEnergy,
              health: goldHealth,
            ),
            VerticalDivider(thickness: 2),
            CropValueColumn.iridium(
              price: iridiumPrice,
              energy: iridiumEnergy,
              health: iridiumHealth,
            ),
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
  final String type;
  final Map? special;

  const CropProduceValues({
    super.key,
    required this.basePrice,
    required this.baseEnergy,
    required this.baseHealth,
    required this.type,
    this.special,
  });

  get baseInedible => baseEnergy == 0 && baseHealth == 0;

  get jarDuration => "2-3 days";
  get dehydratorDuration {
    if (special?['dehydrator'] != null) {
      return special!['dehydrator']!['time'];
    }

    return "1 day";
  }

  get kegDuration {
    if (special?['keg'] != null) {
      return special!['keg']!['time'];
    }

    switch (type) {
      case 'fruit':
        return "6.25 days";
      case 'vegetable':
      case 'forage':
        return "4 days";
    }
  }

  get jarPrice => basePrice * 2 + 50;
  get dehydratorPrice {
    if (special?['dehydrator'] != null) {
      return (special!['dehydrator']!['price'] / 5).floor();
    }

    return (basePrice * 2 + 5).floor();
  }

  get kegPrice {
    if (special?['keg'] != null) {
      return special!['keg']!['price'];
    }

    switch (type) {
      case 'fruit':
        return basePrice * 3;
      case 'vegetable':
      case 'forage':
        return (basePrice * 2.25).floor();
    }
  }

  get jarEnergy {
    switch (type) {
      case 'fruit':
        return (baseInedible ? (basePrice * 0.5) : (baseEnergy * 2)).ceil();
      case 'vegetable':
      case 'forage':
      case 'mushroom':
        return (baseInedible ? (basePrice * 0.625) : (baseEnergy * 1.75))
            .ceil();
    }
  }

  get kegEnergy {
    if (special?['keg'] != null) {
      return special!['keg']!['energy'];
    }

    switch (type) {
      case 'fruit':
        return (baseInedible ? (basePrice * 0.25) : (baseEnergy * 1.75)).ceil();
      case 'vegetable':
      case 'forage':
        return baseInedible ? basePrice : baseEnergy * 2;
    }
  }

  get dehydratorEnergy {
    if (special?['dehydrator'] != null) {
      return (special!['dehydrator']!['energy'] / 5).ceil();
    }

    return ((baseInedible ? (basePrice * 1.25) : (baseEnergy * 3)) / 5).round();
  }

  get jarHealth {
    switch (type) {
      case 'fruit':
        return (baseInedible ? (basePrice * 0.225) : (baseHealth * 2)).floor();
      case 'vegetable':
      case 'forage':
      case 'mushroom':
        return (baseInedible ? (basePrice * 0.28125) : (baseHealth * 1.75))
            .floor();
    }
  }

  get kegHealth {
    if (special?['keg'] != null) {
      return special!['keg']!['health'];
    }

    switch (type) {
      case 'fruit':
        return (baseInedible ? (basePrice * 0.1125) : (baseHealth * 1.75))
            .floor();
      case 'vegetable':
      case 'forage':
        return baseInedible ? (basePrice * 0.45).floor() : baseHealth * 2;
    }
  }

  get dehydratorHealth {
    if (special?['dehydrator'] != null) {
      return (special!['dehydrator']!['health'] / 5).floor();
    }

    return ((baseInedible ? (basePrice * 0.5618) : (baseHealth * 3)) / 5)
        .round();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            Column(
              children: [
                Image.asset('assets/img/jar.png'),
                SizedBox(height: 8),
                Row(
                  spacing: 8.0,
                  children: [
                    Image.asset('assets/img/time.png', height: 16),
                    Text(
                      jarDuration,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                CropValueColumn(
                  price: jarPrice,
                  energy: jarEnergy,
                  health: jarHealth,
                ),
              ],
            ),
            ...(type == 'mushroom'
                ? []
                : [
                    VerticalDivider(thickness: 2),
                    Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.bottomLeft,
                          children: [
                            Image.asset('assets/img/keg.png'),
                            if (special?['keg']?['img'] != null)
                              Positioned(
                                left: -8,
                                bottom: -4,
                                child: Image.asset(
                                  'assets/img/${special!['keg']!['img']}',
                                  scale: 2,
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          spacing: 8.0,
                          children: [
                            Image.asset('assets/img/time.png', height: 16),
                            Text(
                              kegDuration,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        CropValueColumn(
                          price: kegPrice,
                          energy: kegEnergy,
                          health: kegHealth,
                        ),
                      ],
                    ),
                  ]),
            ...(type == 'vegetable'
                ? []
                : [
                    VerticalDivider(thickness: 2),
                    Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.bottomLeft,
                          children: [
                            Image.asset('assets/img/dehydrator.png'),
                            if (special?['dehydrator']?['img'] != null)
                              Positioned(
                                left: -8,
                                bottom: -4,
                                child: Image.asset(
                                  'assets/img/${special!['dehydrator']!['img']}',
                                  scale: 2,
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          spacing: 8.0,
                          children: [
                            Image.asset('assets/img/time.png', height: 16),
                            Text(
                              dehydratorDuration,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        CropValueColumn(
                          price: dehydratorPrice,
                          energy: dehydratorEnergy,
                          health: dehydratorHealth,
                        ),
                      ],
                    ),
                  ]),
            ...(special?['mill'] != null
                ? [
                    VerticalDivider(thickness: 2),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Stack(
                          alignment: Alignment.bottomLeft,
                          clipBehavior: Clip.none,
                          children: [
                            Image.asset('assets/img/mill.png', height: 96),
                            if (special!['mill']!['img'] != null)
                              Positioned(
                                left: -8,
                                bottom: -4,
                                child: Image.asset(
                                  'assets/img/${special!['mill']!['img']}',
                                  scale: 2,
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 8),

                        Row(
                          spacing: 8.0,
                          children: [
                            Image.asset('assets/img/time.png', height: 16),
                            Text(
                              special!['mill']!['time'],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        CropValueColumn(
                          price: special!['mill']!['price'],
                          energy: special!['mill']!['energy'],
                          health: special!['mill']!['health'],
                          quality: special!['mill']!['quality'],
                        ),
                      ],
                    ),
                  ]
                : []),
          ],
        ),
      ),
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
        if (!inedible) ...[
          Row(
            children: [
              _overlayedImage('energy.png'),
              Text('$energy', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            children: [
              _overlayedImage('health.png'),
              Text('$health', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
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
        padding: const EdgeInsets.all(8.0),
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
                ? Row(
                    spacing: 8,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset('assets/img/heart.png', height: 16),
                      Column(
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
                                    fav.replaceFirst(
                                      fav[0],
                                      fav[0].toUpperCase(),
                                    ),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
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
