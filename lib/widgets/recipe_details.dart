import 'package:flutter/material.dart';
import 'package:stardew_crop_companion/data/recipe.dart';
import 'package:stardew_crop_companion/widgets/favorites.dart';
import 'package:stardew_crop_companion/widgets/item_image.dart';

class RecipeDetails extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetails({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: recipe.favorites.isEmpty
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      spacing: 8.0,
      children: [
        ItemImage.large(recipe.img),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(recipe.name),
              if (recipe.favorites.isNotEmpty)
                Favorites(
                  favorites: recipe.favorites,
                  mainAxisAlignment: MainAxisAlignment.start,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
