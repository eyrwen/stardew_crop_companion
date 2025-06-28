import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../data/interface.dart';
import '../data/recipe.dart';
import 'favorites.dart';
import 'item_image.dart';

class ItemGeneralDetails extends StatelessWidget {
  final Item item;
  final List<Recipe> recipes;

  const ItemGeneralDetails({
    super.key,
    required this.item,
    required this.recipes,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              spacing: 8,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ItemImage(item.img),
                InkWell(
                  onTap: () => launchUrlString(item.url),
                  child: Text(
                    item.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                item.favorites.isNotEmpty
                    ? Favorites(favorites: item.favorites)
                    : SizedBox.shrink(),
                SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8.0,
                  children: Recipe.sort(recipes)
                      .map(
                        (recipe) => Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 8,
                          children: [
                            ItemImage.large(recipe.img),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  recipe.name,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                (recipe.favorites.isNotEmpty
                                    ? Favorites(favorites: recipe.favorites)
                                    : SizedBox.shrink()),
                              ],
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
