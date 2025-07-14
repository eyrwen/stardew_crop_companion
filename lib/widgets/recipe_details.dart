import 'dart:math' as math;

import 'package:flutter/material.dart' hide Tooltip;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stardew_crop_companion/widgets/item_value_column.dart';

import '../data/recipe.dart';
import 'buffs.dart';
import 'favorites.dart';
import 'item_image.dart';
import 'tooltip.dart';

class RecipeDetails extends HookWidget {
  final Recipe recipe;

  const RecipeDetails({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final tooltipController = useMemoized(() => ElTooltipController());

    return Row(
      crossAxisAlignment: recipe.favorites.isEmpty
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      spacing: 8.0,
      children: [
        recipe is CookingRecipe
            ? Tooltip(
                content: Container(
                  constraints: BoxConstraints(
                    maxWidth: recipe.buffs.isNotEmpty ? 200 : 60,
                    maxHeight: math.max(
                      65,
                      (20.0 * recipe.buffs.length) +
                          (24.0 * recipe.buffs.times.length),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        spacing: 4.0,
                        children: [
                          Column(
                            spacing: 4.0,
                            children: [
                              SizedBox(height: 0.25),
                              ItemImage.small('energy.png'),
                              ItemImage.small('health.png'),
                              ItemImage.small('gold.png'),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${recipe.energy}'),
                              Text('${recipe.health}'),
                              Text('${recipe.price}G'),
                            ],
                          ),
                        ],
                      ),
                      if (recipe.buffs.isNotEmpty) Buffs(buffs: recipe.buffs),
                    ],
                  ),
                ),
                controller: tooltipController,
                position: ElTooltipPosition.topStart,
                child: ItemImage.large(recipe.img),
              )
            : ItemImage.large(recipe.img),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MouseRegion(
                onEnter: (_) {
                  if (recipe is CookingRecipe) tooltipController.show();
                },
                onExit: (_) {
                  if (recipe is CookingRecipe) tooltipController.hide();
                },
                child: Text(recipe.name),
              ),
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
