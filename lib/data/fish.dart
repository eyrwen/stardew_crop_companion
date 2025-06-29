import 'package:collection/collection.dart';

import 'interface.dart';
import 'produce_machine.dart';

class Fish extends Edible with Producable {
  final List<Weather> weather;
  final List<int> startTimes;
  final List<int> endTimes;
  final List<String>? pondOutputs;
  final List<FishingLocation> locations;
  final bool legendary;

  Fish({
    required super.key,
    required super.name,
    required super.img,
    super.url,
    required super.price,
    required this.pondOutputs,
    required this.locations,
    super.hasQuality = true,
    super.favorites = const [],
    super.energy = 0,
    super.health = 0,
    super.specialProduce,
    this.weather = Weather.values,
    this.startTimes = const [600], // 6:00 AM
    this.endTimes = const [2600], // 2:00 AM (next day)
    type,
    this.legendary = false,
  }) : super(type: type ?? ItemType.fish);

  factory Fish.fromJson(key, json) {
    final locations = (json['locations'] as Map<String, dynamic>);
    if (locations.keys.first == FishableLocation.crabpot.key) {
      return CrabPotCatch.fromJson(key, json);
    } else {
      return Fish(
        key: key,
        name: json['name'],
        img: json['img'],
        url: json['url'],
        price: json['price'],
        hasQuality: json['hasQuality'] ?? true,
        favorites: List<String>.from(json['favorite'] ?? []),
        energy: json['energy'] ?? 0,
        health: json['health'] ?? 0,
        legendary: json['legendary'] ?? false,
        pondOutputs: json['pond'] != null
            ? (json['pond'] as Map<String, dynamic>).keys.toList()
            : [],
        specialProduce: json['specialProduce'] != null
            ? (json['specialProduce'] as Map<String, dynamic>).map(
                (key, value) => MapEntry(
                  ProduceMachine.from(key),
                  ProduceMachineOutput.fromJson(value as Map<String, dynamic>),
                ),
              )
            : null,
        weather: json['weather'] != null
            ? List<String>.from(
                json['weather'],
              ).map((e) => Weather.from(e)).toList()
            : Weather.values, // Default to all weather types
        startTimes: json['startTimes'] != null
            ? List<int>.from(json['startTimes'])
            : [json['startTime'] ?? 600], // Default to 6:00 AM
        endTimes: json['endTimes'] != null
            ? List<int>.from(json['endTimes'])
            : [json['endTime'] ?? 2600], // Default to 2:00 AM (next day)
        locations: _buildLocations(json['locations'] as Map<String, dynamic>),
      );
    }
  }

  static List<FishingLocation> _buildLocations(
    Map<String, dynamic> locationsJson,
  ) {
    final locations = <FishingLocation>[];

    for (var entry in locationsJson.entries) {
      final place = FishableLocation.from(entry.key);
      final seasons = (entry.value as List<dynamic>)
          .map((season) => Season.from(season as String))
          .toList();

      final matching = locations.firstWhereOrNull(
        (loc) => ListEquality().equals(loc.seasons, seasons),
      );

      matching != null
          ? matching.places.add(place)
          : locations.add(FishingLocation(places: [place], seasons: seasons));
    }
    return locations;
  }

  bool get exclusiveToRain {
    return weather.length == 1 && weather.contains(Weather.rainy);
  }

  bool exclusiveToWeather(Weather weather) {
    return this.weather.length == 1 && this.weather.first == weather;
  }

  bool exclusiveToSeason(Season season) {
    return locations.length == 1 &&
        locations.first.seasons.length == 1 &&
        locations.first.seasons.contains(season);
  }

  bool exclusiveToLocation(FishableLocation location) {
    return locations.length == 1 &&
        locations.first.places.length == 1 &&
        locations.first.places.contains(location);
  }
}

enum Season {
  spring('spring', 'spring.png'),
  summer('summer', 'summer.png'),
  fall('fall', 'fall.png'),
  winter('winter', 'winter.png');

  final String name;
  final String img;

  const Season(this.name, this.img);

  static Season from(String value) {
    return Season.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => throw ArgumentError('Unknown season: $value'),
    );
  }

  static bool isAll(List<Season> seasons) {
    return seasons.length == Season.values.length &&
        seasons.every((s) => Season.values.contains(s));
  }
}

enum Weather {
  sunny('sunny', 'weather_sunny.png'),
  rainy('rainy', 'weather_rainy.png'),
  windy('windy', 'weather_windy.png');

  final String name;
  final String img;

  const Weather(this.name, this.img);

  static Weather from(String value) {
    return Weather.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => throw ArgumentError('Unknown weather: $value'),
    );
  }
}

enum FishableLocation {
  townriver('townriver', "Town River"),
  forestriver('forestriver', "Forest River"),
  forestpond('forestpond', "Forest Pond"),
  mountainlake('mountainlake', "Mountain Lake"),
  ocean('ocean', "Ocean"),
  secretwoods('secretwoods', "Secret Woods", special: true),
  desert('desert', "Desert", special: true),
  gingerisland('gingerisland', "Ginger Island", special: true),
  forestwaterfalls('forestwaterfalls', "Forest Waterfalls"),
  sewers('sewers', "Sewers", special: true),
  buglair('buglair', "Bug Lair", special: true),
  piratecove('piratecove', "Pirate Cove", special: true),
  swamp('swamp', "Swamp", special: true),
  volcano('volcano', "Volcano", special: true),
  mines('mines', "Mines", special: true),
  submarine('submarine', "Submarine", special: true),
  crabpot('crabpot', "Crab Pot", special: true),
  forbiddenmaze('forbiddenmaze', "Forbidden Maze", special: true),
  fablereef('fablereef', "Fable Reef", special: true),
  crimsonbadlands('crimsonbadlands', "Crimson Badlands", special: true),
  forestwestriver('forestwestriver', "Western Forest River"),
  adventurersummit('adventurersummit', "Adventurer's Summit"),
  highlandsriver('highlandsriver', "Highlands River", special: true),
  highlandsruinspond(
    'highlandsruinspond',
    "Highlands Ruins Pond",
    special: true,
  ),
  highlandscavern('highlandscavern', "Highlands Cavern", special: true),
  shearwaterbridge('shearwaterbridge', "Shearwater Bridge"),
  diamondcavern('diamondcavern', "Diamond Cavern", special: true),
  spritespring('spritespring', "Sprite Spring", special: true),
  junimowoods('junimowoods', "Junimo Woods", special: true),
  bluemoonvineyardriver('bluemoonvineyardriver', "Blue Moon Vineyard River"),
  bluemoonvineyardbeach('bluemoonvineyardbeach', "Blue Moon Vineyard Beach"),
  farm("farm", "Farm");

  final String key;
  final String name;
  final bool special;

  static FishableLocation from(String key) {
    return FishableLocation.values.firstWhere(
      (e) => e.key == key.toLowerCase(),
      orElse: () => throw ArgumentError('Unknown fishable location: $key'),
    );
  }

  static List<FishableLocation> get onlySpecial {
    return FishableLocation.values
        .where((location) => location.special)
        .toList();
  }

  static List<FishableLocation> sort(List<FishableLocation> locations) {
    return locations.sorted((a, b) {
      if (a.special && !b.special) return 1;
      if (!a.special && b.special) return -1;
      return a.index.compareTo(b.index);
    });
  }

  const FishableLocation(this.key, this.name, {this.special = false});
}

class FishingLocation {
  final List<FishableLocation> places;
  final List<Season> seasons;

  FishingLocation({required this.places, this.seasons = Season.values});

  static List<FishingLocation> sort(List<FishingLocation> locations) {
    return locations.sorted((a, b) {
      if (a.seasons.length != b.seasons.length) {
        return a.seasons.length.compareTo(b.seasons.length);
      }
      return a.seasons.first.index.compareTo(b.seasons.first.index);
    });
  }
}

enum WaterType {
  freshwater('freshwater'),
  saltwater('saltwater');

  final String name;

  const WaterType(this.name);

  static WaterType from(String value) {
    return WaterType.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => throw ArgumentError('Unknown water type: $value'),
    );
  }
}

class CrabPotCatch extends Fish {
  final WaterType waterType;

  CrabPotCatch({
    required super.key,
    required super.name,
    required super.img,
    required super.url,
    required super.price,
    required this.waterType,
    super.hasQuality = true,
    super.favorites = const [],
    super.energy = 0,
    super.health = 0,
    super.specialProduce,
    super.pondOutputs,
  }) : super(
         type: ItemType.crabpotcatch,
         locations: [
           FishingLocation(
             places: [FishableLocation.crabpot],
             seasons: Season.values,
           ),
         ],
       );

  factory CrabPotCatch.fromJson(key, Map<String, dynamic> json) {
    return CrabPotCatch(
      key: key,
      name: json['name'],
      img: json['img'],
      url: json['url'],
      waterType: WaterType.from(
        json['locations'][FishableLocation.crabpot.key].first,
      ),
      price: json['price'],
      hasQuality: json['hasQuality'] ?? true,
      favorites: List<String>.from(json['favorite'] ?? []),
      energy: json['energy'] ?? 0,
      health: json['health'] ?? 0,
      specialProduce: json['specialProduce'] != null
          ? (json['specialProduce'] as Map<String, dynamic>).map(
              (key, value) => MapEntry(
                ProduceMachine.from(key),
                ProduceMachineOutput.fromJson(value as Map<String, dynamic>),
              ),
            )
          : null,
      pondOutputs: json['pond'] != null
          ? (json['pond'] as Map<String, dynamic>).keys.toList()
          : [],
    );
  }
}
