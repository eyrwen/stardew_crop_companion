import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../data/interface.dart';
import '../data/recipe.dart';
import 'favorites.dart';
import 'item_image.dart';
import 'recipes_column.dart';

class ItemGeneralDetails extends StatelessWidget {
  final Item item;
  final List<Recipe> recipes;
  final Widget? seasons;
  final bool includeRecipeFavorites;
  final bool favoritesSplit;

  const ItemGeneralDetails({
    super.key,
    required this.item,
    required this.recipes,
    this.seasons,
    this.includeRecipeFavorites = true,
    this.favoritesSplit = false,
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
                if (item.favorites.isNotEmpty)
                  Favorites(
                    favorites: item.favorites,
                    splitLayout: favoritesSplit,
                  ),
                seasons ?? SizedBox.shrink(),
                RecipesColumn(
                  recipes: recipes,
                  includeFavorites: includeRecipeFavorites,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
