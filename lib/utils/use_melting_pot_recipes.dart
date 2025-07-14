import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../data/buff.dart';
import '../data/recipe.dart';
import 'load_json_asset.dart';

typedef JSON = Map<String, dynamic>;

AsyncSnapshot<List<Recipe>> useMeltingPotRecipes() {
  final locations = MeltingPotLocation.values.map((location) {
    return MeltingPotLocationData(location);
  }).toList();

  return useFuture(
    useMemoized(() async {
      List<Recipe> recipes = [];

      for (final location in locations) {
        final stitchedRecipes = await location.stitch();
        recipes.addAll(stitchedRecipes);
      }

      return recipes;
    }),
  );
}

enum MeltingPotLocation {
  africa('Africa', 'AF'),
  asia('Asia', 'AS'),
  australiaNewZealand('ANZ', 'ANZ'),
  europe('Europe', 'EU'),
  latin('Latin', 'L'),
  northAmerica('NA', 'NA');

  final String name;
  final String id;

  const MeltingPotLocation(this.name, this.id);
}

class MeltingPotLocationData {
  final MeltingPotLocation location;
  final LocationObjectData objectData;
  final LocationRecipeData recipeData;
  final MeltingPotI18n i18n = MeltingPotI18n();

  MeltingPotLocationData(this.location)
    : objectData = LocationObjectData(location),
      recipeData = LocationRecipeData(location);

  Future<List<Recipe>> stitch() async {
    final loadedRecipes = await recipeData.loadedRecipes;
    final loadedObjects = await objectData.loadedObjects;
    final translations = await i18n.translations;

    return loadedRecipes.map((recipe) {
      final object = loadedObjects.firstWhere((obj) => obj.key == recipe.key);

      return CookingRecipe(
        key: recipe.key,
        name: translations[object.i18nKey] ?? '',
        img:
            '${location.id}${object.spriteIndex.toString().padLeft(3, '0')}.png',
        imgScale: .5,
        price: object.price,
        health: object.health,
        energy: object.energy,
        buffs: BuffList(
          object.buffs.fold([], (acc, b) {
            acc.addAll(
              b.effects.entries
                  .where((e) => e.value != 0.0)
                  .map(
                    (e) => Buff(
                      BuffData.toBuffType(e.key),
                      b.durationInRealMinutes,
                      e.value.toInt(),
                    ),
                  ),
            );
            return acc;
          }),
        ),
        url: '',
        ingredients: recipe.ingredientsAsList,
      );
    }).toList();
  }
}

class LocationObjectData {
  final MeltingPotLocation location;

  LocationObjectData(this.location);

  final List<ObjectData> _loadedObjects = [];

  get objectDataPath => 'assets/melting_pot/${location.name}Objects.json';

  Future<List<ObjectData>> get loadedObjects async {
    if (_loadedObjects.isEmpty) {
      final jsonData = await loadJsonAsset(objectDataPath);
      final dataObjects = List<JSON>.from(
        jsonData['Changes'],
      ).where((element) => element['Target'] == 'Data/Objects');

      for (var object in dataObjects) {
        final entries = JSON.from(object['Entries']).entries;
        _loadedObjects.addAll(
          entries.map((entry) {
            return ObjectData.fromJson(
              entry.key
                  .replaceAll('{{ModId}}_', '')
                  .replaceAll('${location.id}_', ''),
              entry.value,
            );
          }).toList(),
        );
      }
    }
    return _loadedObjects;
  }
}

class ObjectData {
  final String key;
  final int price;
  final int edibility;
  final int spriteIndex;
  final String i18nKey;
  final List<BuffData> buffs;

  ObjectData({
    required this.key,
    required this.price,
    required this.edibility,
    required this.spriteIndex,
    required this.buffs,
    required this.i18nKey,
  });

  factory ObjectData.fromJson(String key, JSON json) {
    return ObjectData(
      key: key,
      price: json['Price'],
      edibility: json['Edibility'],
      spriteIndex: json['SpriteIndex'],
      i18nKey: json['DisplayName']
          .replaceAll('{{i18n:', '')
          .replaceAll('}}', ''),
      buffs: json['Buffs'] == null
          ? []
          : List<JSON>.from(
              json['Buffs'],
            ).map((buffJson) => BuffData.fromJson(buffJson)).toList(),
    );
  }

  get health => (edibility * 1.125).round();
  get energy => (edibility * 2.5).round();
}

class BuffData {
  final int durationInGameMinutes;
  final Map<String, double> effects;

  BuffData({required this.durationInGameMinutes, required this.effects});

  factory BuffData.fromJson(JSON json) {
    return BuffData(
      durationInGameMinutes: json['Duration'],
      effects: Map<String, double>.from(json['CustomAttributes']),
    );
  }

  String get durationInRealMinutes {
    // game minute == .7 real seconds
    final realMinutes = (durationInGameMinutes * 0.7) / 60;
    final wholeMinutes = realMinutes.floor();
    final seconds = ((realMinutes - wholeMinutes) * 60).floor();
    return '${wholeMinutes}m ${seconds}s';
  }

  static BuffType toBuffType(String key) {
    return switch (key) {
      'FarmingLevel' => BuffType.farming,
      'FishingLevel' => BuffType.fishing,
      'ForagingLevel' => BuffType.foraging,
      'MiningLevel' => BuffType.mining,
      'LuckLevel' => BuffType.luck,
      'MaxStamina' => BuffType.maxEnergy,
      'MagneticRadius' => BuffType.magnetism,
      'Speed' => BuffType.speed,
      'Defense' => BuffType.defense,
      'Attack' => BuffType.attack,
      _ => throw Exception('Unknown buff type: $key'),
    };
  }
}

class LocationRecipeData {
  final MeltingPotLocation location;

  LocationRecipeData(this.location);

  final List<RecipeData> _loadedRecipes = [];

  get recipeDataPath =>
      'assets/melting_pot/${location.name}CookingRecipes.json';

  Future<List<RecipeData>> get loadedRecipes async {
    if (_loadedRecipes.isEmpty) {
      final jsonData = await loadJsonAsset(recipeDataPath);
      final dataRecipes = List<JSON>.from(
        jsonData['Changes'],
      ).where((element) => element['Target'] == 'Data/CookingRecipes');

      for (var recipe in dataRecipes) {
        final entries = Map<String, String>.from(recipe['Entries']).entries;
        _loadedRecipes.addAll(
          entries.map((entry) {
            return RecipeData.fromJson(
              entry.key
                  .replaceAll('{{ModId}}_', '')
                  .replaceAll('${location.id}_', ''),
              entry.value,
            );
          }).toList(),
        );
      }
    }
    return _loadedRecipes;
  }
}

class RecipeData {
  final String key;
  final JSON ingredients;

  RecipeData({required this.key, required this.ingredients});

  factory RecipeData.fromJson(String key, String ingredientsRaw) {
    return RecipeData(key: key, ingredients: _parseIngredients(ingredientsRaw));
  }

  static JSON _parseIngredients(String ingredientsRaw) {
    final actualIngredients = ingredientsRaw.split('/').first;
    final ingredients = <String, dynamic>{};

    final r = RegExp(r'(-?\w+)(\s*)(\d*)');
    r.allMatches(actualIngredients).forEach((match) {
      ingredients[match.group(1)!] = match.group(3)!.isNotEmpty
          ? int.parse(match.group(3)!)
          : 1;
    });

    return ingredients;
  }

  IngredientList get ingredientsAsList {
    final strictIngredients = <String, int>{};
    final strictTypeIngredients = <String>[];

    for (var i in ingredients.keys) {
      try {
        final intValue = int.parse(i.toString());
        if (intValue < 0) {
          strictTypeIngredients.add(getTypeFromId(intValue));
        } else {
          strictIngredients[i] = int.parse(ingredients[i].toString());
        }
      } catch (e) {
        strictIngredients[i] = int.parse(ingredients[i].toString());
      }
    }

    return IngredientList(strictIngredients, strictTypeIngredients, []);
  }

  static getTypeFromId(int id) {
    return switch (id) {
      -4 => 'fish',
      -5 => 'egg',
      -6 => 'milk',
      _ => throw Exception('Unknown ingredient type ID: $id'),
    };
  }
}

class MeltingPotI18n {
  MeltingPotI18n();

  final Map<String, String> _loadedTranslations = {};
  final String i18nPath = 'assets/melting_pot/i18n.json';

  Future<Map<String, String>> get translations async {
    if (_loadedTranslations.isEmpty) {
      final jsonData = await loadJsonAsset(i18nPath);
      _loadedTranslations.addAll(Map<String, String>.from(jsonData));
    }
    return _loadedTranslations;
  }
}
