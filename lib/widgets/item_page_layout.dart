import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../data/interface.dart';
import '../data/recipe.dart';
import 'buffs.dart';
import 'details_card.dart';
import 'favorites.dart';
import 'item_image.dart';
import 'item_link.dart';
import 'item_produce_column.dart';
import 'item_value_column.dart';
import 'recipe_details.dart';

class ItemPageLayout<T extends Item> extends StatelessWidget {
  final VoidCallback onBack;
  final T item;
  final Widget? seasons;
  final List<Recipe> recipes;
  final Widget? additionalDetails;

  const ItemPageLayout({
    super.key,
    required this.onBack,
    required this.item,
    this.seasons,
    this.recipes = const [],
    this.additionalDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        spacing: 16.0,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(icon: Icon(Icons.arrow_back), onPressed: () => onBack()),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300, minWidth: 200),
            child: Column(
              spacing: 16.0,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DetailsCard(
                        child: Column(
                          spacing: 8.0,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ItemImage(item.img),
                            ItemLink(item: item),
                            if(item.buffs.isNotEmpty) Buffs(buffs: item.buffs),
                            seasons ?? SizedBox.shrink(),
                            if (item.favorites.isNotEmpty)
                              Favorites(favorites: item.favorites),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (recipes.isNotEmpty)
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: DetailsCard.scrollable(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              spacing: 8.0,
                              children: Recipe.sort(recipes)
                                  .map(
                                    (recipe) => RecipeDetails(recipe: recipe),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 8,
            child: Column(
              spacing: 16.0,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    DetailsCard(
                      child: Row(
                        spacing: 48,
                        children: [
                          ItemValueColumn(
                            price: item.price,
                            health: item.health,
                            energy: item.energy,
                          ),
                          if (item.hasQuality) ...[
                            ItemValueColumn.silver(
                              price: item.price,
                              health: item.health,
                              energy: item.energy,
                            ),
                            ItemValueColumn.gold(
                              price: item.price,
                              health: item.health,
                              energy: item.energy,
                            ),
                            ItemValueColumn.iridium(
                              price: item.price,
                              health: item.health,
                              energy: item.energy,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (item.producable)
                        DetailsCard.scrollable(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: item.produceOutputs.entries
                                .slices(6)
                                .map(
                                  (subset) => Row(
                                    spacing: 16.0,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: subset
                                        .map(
                                          (entry) => ItemProduceColumn(
                                            output: entry.value,
                                            machine: entry.key,
                                            item: item,
                                          ),
                                        )
                                        .toList(),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      if (additionalDetails != null)
                        DetailsCard(child: additionalDetails!),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
