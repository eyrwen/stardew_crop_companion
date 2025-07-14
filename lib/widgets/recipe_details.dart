import 'package:flutter/material.dart' hide Tooltip;

import '../data/recipe.dart';
import 'buffs.dart';
import 'favorites.dart';
import 'item_image.dart';
import 'tooltip.dart';

class RecipeDetails extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetails({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final details = Row(
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

    return recipe.buffs.isNotEmpty
        ? Tooltip(
            content: Row(
              children: [
                Column(
                  children: [
                    Text(recipe.name),
                  ],
                ),
              ],
            ),
            position: ElTooltipPosition.rightStart,
            child: details,
          )
        : details;
  }
}
