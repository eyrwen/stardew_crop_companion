import 'buff.dart';
import 'interface.dart';

enum RecipeType {
  crafting('crafting'),
  building('building'),
  cooking('cooking'),
  clothing('clothing');

  final String name;
  const RecipeType(this.name);

  static RecipeType from(String type) {
    return RecipeType.values.firstWhere(
      (e) => e.name == type,
      orElse: () => throw ArgumentError('Unknown recipe type: $type'),
    );
  }
}

sealed class Recipe extends Item {
  static List<Recipe> sort(List<Recipe> recipes) {
    return recipes
      ..sort((a, b) => a.recipeType.index.compareTo(b.recipeType.index));
  }

  final IngredientList ingredients;
  final RecipeType recipeType;

  Recipe({
    required super.key,
    required super.name,
    super.url,
    required super.price,
    required super.img,
    required super.favorites,
    required this.ingredients,
    required this.recipeType,
    super.buffs = const [],
  }) : super(type: ItemType.recipe, hasQuality: false);

  factory Recipe.fromJson(String key, Map<String, dynamic> json) {
    final type = RecipeType.from(json['type'] as String);

    switch (type) {
      case RecipeType.cooking:
        return CookingRecipe(
          key: key,
          url: json['url'],
          name: json['name'],
          img: json['img'],
          ingredients: IngredientList.fromJson(json['ingredients']),
          price: json['price'] ?? 0,
          energy: json['energy'],
          health: json['health'],
          favorites: List<String>.from(json['favorite'] ?? []),
          buffs: (json['buffs'] as List<dynamic>?)
              ?.map((b) => Buff.fromJson(b as Map<String, dynamic>))
              .toList() ??
          []
        );
      case RecipeType.crafting:
        return CraftingRecipe(
          key: key,
          url: json['url'],
          name: json['name'],
          img: json['img'],
          ingredients: IngredientList.fromJson(json['ingredients']),
          price: json['price'] ?? 0,
          favorites: List<String>.from(json['favorite'] ?? []),
          buffs: (json['buffs'] as List<dynamic>?)
              ?.map((b) => Buff.fromJson(b as Map<String, dynamic>))
              .toList() ??
          []
        );
      case RecipeType.building:
        return BuildingRecipe(
          key: key,
          url: json['url'],
          name: json['name'],
          img: json['img'],
          ingredients: IngredientList.fromJson(json['ingredients']),
          price: json['price'] ?? 0,
          favorites: List<String>.from(json['favorite'] ?? []),
          buffs: (json['buffs'] as List<dynamic>?)
              ?.map((b) => Buff.fromJson(b as Map<String, dynamic>))
              .toList() ??
          []
        );
      case RecipeType.clothing:
        return ClothingRecipe(
          key: key,
          url: json['url'],
          name: json['name'],
          img: json['img'],
          ingredients: IngredientList.fromJson(json['ingredients']),
          price: json['price'] ?? 0,
          favorites: List<String>.from(json['favorite'] ?? []),
          buffs: (json['buffs'] as List<dynamic>?)
              ?.map((b) => Buff.fromJson(b as Map<String, dynamic>))
              .toList() ??
          []
        );
    }
  }

  bool requires(Item item) {
    return ingredients.requires(item);
  }
}

class CookingRecipe extends Recipe {
  final int energy;
  final int health;

  CookingRecipe({
    required super.key,
    required super.url,
    required super.name,
    required super.img,
    required super.price,
    required super.ingredients,
    required this.energy,
    required this.health,
    super.favorites = const [],
    super.buffs = const [],
  }) : super(recipeType: RecipeType.cooking);

  @override
  bool requires(Item item) {
    return item.cookable && super.requires(item);
  }
}

class CraftingRecipe extends Recipe {
  CraftingRecipe({
    required super.key,
    required super.url,
    required super.name,
    required super.img,
    required super.price,
    required super.ingredients,
    super.favorites = const [],
    super.buffs = const [],
  }) : super(recipeType: RecipeType.crafting);
}

class BuildingRecipe extends Recipe {
  BuildingRecipe({
    required super.key,
    required super.url,
    required super.name,
    required super.img,
    required super.price,
    super.favorites = const [],
    required super.ingredients,
    super.buffs = const [],
  }) : super(recipeType: RecipeType.building);
}

class ClothingRecipe extends Recipe {
  ClothingRecipe({
    required super.key,
    required super.url,
    required super.name,
    required super.img,
    required super.price,
    super.favorites = const [],
    required super.ingredients,
    super.buffs = const [], 
  }) : super(recipeType: RecipeType.clothing);
}

class IngredientList {
  final Map<String, int> strictIngredients;
  final List<String> strictTypeIngredients;
  final List<String> flexibleIngredient;

  IngredientList(
    this.strictIngredients,
    this.strictTypeIngredients,
    this.flexibleIngredient,
  );

  factory IngredientList.fromJson(Map<String, dynamic> json) {
    var strictIngredients = <String, int>{};
    var strictTypeIngredients = <String>[];
    var flexibleIngredient = <String>[];

    for (var entry in json.entries) {
      switch (entry.key) {
        case ':any:':
          strictTypeIngredients.add(entry.value as String);
          break;
        case ':any_each:':
          strictTypeIngredients.addAll(List<String>.from(entry.value as List));
          break;
        case ':one_of:':
          flexibleIngredient.addAll(List<String>.from(entry.value as List));
          break;
        default:
          strictIngredients[entry.key] = entry.value as int;
          break;
      }
    }

    return IngredientList(
      strictIngredients,
      strictTypeIngredients,
      flexibleIngredient,
    );
  }

  bool requires(Item item) {
    return strictIngredients.containsKey(item.key) ||
        strictTypeIngredients.any(
          (type) =>
              (item.type.name.contains(type)) ||
              item.key.toLowerCase().contains(type),
        ) ||
        flexibleIngredient.contains(item.key);
  }
}
