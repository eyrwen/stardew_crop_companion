import 'package:stardew_crop_companion/data/crop.dart';

enum RecipeType { crafting, building, cooking, clothing }

sealed class Recipe {
  static List<Recipe> sort(List<Recipe> recipes) {
    return recipes..sort((a, b) => a.type.index.compareTo(b.type.index));
  }

  final String name;
  final String img;
  final RecipeType type;
  final Map<String, int> ingredients;

  const Recipe({
    required this.name,
    required this.img,
    required this.type,
    required this.ingredients,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    final type = RecipeType.values.firstWhere(
      (e) => e.name == json['type'],
      orElse: () => throw ArgumentError('Unknown recipe type: ${json['type']}'),
    );

    switch (type) {
      case RecipeType.cooking:
        return CookingRecipe(
          name: json['name'],
          img: json['img'],
          ingredients: Map<String, int>.from(json['ingredients']),
          price: json['price'],
          energy: json['energy'],
          health: json['health'],
          favorites: List<String>.from(json['favorite'] ?? []),
        );
      case RecipeType.crafting:
        return CraftingRecipe(
          name: json['name'],
          img: json['img'],
          ingredients: Map<String, int>.from(json['ingredients']),
        );
      case RecipeType.building:
        return BuildingRecipe(
          name: json['name'],
          img: json['img'],
          ingredients: Map<String, int>.from(json['ingredients']),
        );
      case RecipeType.clothing:
        return ClothingRecipe(
          name: json['name'],
          img: json['img'],
          ingredients: Map<String, int>.from(json['ingredients']),
        );
    }
  }

  bool requires(Crop crop) {
    return ingredients.containsKey(crop.key);
  }
}

class CookingRecipe extends Recipe {
  final int price;
  final int energy;
  final int health;
  final List<String> favorites;

  const CookingRecipe({
    required super.name,
    required super.img,
    required super.ingredients,
    required this.price,
    required this.energy,
    required this.health,
    this.favorites = const [],
  }) : super(type: RecipeType.cooking);
}

class CraftingRecipe extends Recipe {
  const CraftingRecipe({
    required super.name,
    required super.img,
    required super.ingredients,
  }) : super(type: RecipeType.crafting);
}

class BuildingRecipe extends Recipe {
  const BuildingRecipe({
    required super.name,
    required super.img,
    required super.ingredients,
  }) : super(type: RecipeType.building);
}

class ClothingRecipe extends Recipe {
  const ClothingRecipe({
    required super.name,
    required super.img,
    required super.ingredients,
  }) : super(type: RecipeType.clothing);
}
