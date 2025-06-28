import 'package:collection/collection.dart';

import 'interface.dart';
import 'produce_machine.dart';

class Fish extends Edible with Producable {
  final List<Weather> weather;
  final List<int> startTimes;
  final List<int> endTimes;
  final List<String>? pondOutputs;
  final List<FishingLocation> locations;

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
        locations: locations.entries
            .map(
              (location) => FishingLocation(
                place: FishableLocation.from(location.key),
                seasons: (location.value as List)
                    .map((s) => Season.from(s))
                    .toList(),
              ),
            )
            .toList(),
      );
    }
  }

  bool get exclusiveToRain {
    return weather.length == 1 && weather.contains(Weather.rainy);
  }

  bool exclusiveToSeason(Season season) {
    final locationsInSeason = locations
        .where((location) => location.seasons.contains(season))
        .whereNot((location) => FishableLocation.onlySpecial.contains(location.place))
        .toList();
    final seasons = locationsInSeason
        .expand((location) => location.seasons)
        .toSet();

    return seasons.length == 1 && seasons.contains(season);
  }

  bool exclusiveToLocation(FishableLocation location) {
    final locationsOnly = locations.map((location) => location.place);
    return locationsOnly.length == 1 && locationsOnly.first == location;
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
}

enum Weather {
  sunny('sunny'),
  rainy('rainy'),
  windy('windy');

  final String name;

  const Weather(this.name);

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
  crabpot('crabpot', "Crab Pot", special: true);

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

  const FishableLocation(this.key, this.name, {this.special = false});
}

class FishingLocation {
  final FishableLocation place;
  final List<Season> seasons;

  FishingLocation({required this.place, this.seasons = Season.values});
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
             place: FishableLocation.crabpot,
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
