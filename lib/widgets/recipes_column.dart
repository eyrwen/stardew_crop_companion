import 'package:flutter/material.dart';

import '../data/recipe.dart';
import 'favorites.dart';
import 'item_image.dart';

class RecipesColumn extends StatelessWidget {
  final List<Recipe> recipes;
  final bool includeFavorites;

  const RecipesColumn({
    super.key,
    required this.recipes,
    this.includeFavorites = true,
  });

  const RecipesColumn.withoutFavorites({super.key, required this.recipes})
    : includeFavorites = false;

  static int recipeItemCount(List<Recipe> recipes) {
    return recipes.fold<int>(
      0,
      (count, recipe) => count + recipe.favorites.length + 1,
    );
  }

  List<Recipe> get sortedRecipes => Recipe.sort(recipes);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.vertical,
      crossAxisAlignment: WrapCrossAlignment.start,
      runSpacing: 16.0,
      spacing: 8.0,
      runAlignment: WrapAlignment.start,
      children: sortedRecipes
          .map(
            (r) => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 8.0,
              children: [
                ItemImage.large(r.img),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.name),
                    if (includeFavorites && r.favorites.isNotEmpty)
                      Favorites(favorites: r.favorites),
                  ],
                ),
              ],
            ),
          )
          .toList(),
    );

    // return Row(
    //   children: [
    //     Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: sortedRecipes.mapIndexed((index, recipe) {
    //         if (itemCount > 20) {
    //           secondColumnStartIndex = index;
    //           return SizedBox.shrink();
    //         }
    //         itemCount += recipe.favorites.length + 1;

    //         return RecipeRow(recipe: recipe);
    //       }).toList(),
    //     ),
    //     if (secondColumnStartIndex > 0)
    //       SizedBox(width: 16), // Space between columns
    //     if (secondColumnStartIndex > 0)
    //       Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: recipes
    //             .skip(secondColumnStartIndex - 1)
    //             .map((recipe) => RecipeRow(recipe: recipe))
    //             .toList(),
    //       ),
    //   ],
    // );
  }
}

class RecipeRow extends StatelessWidget {
  final Recipe recipe;

  const RecipeRow({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        ItemImage.large(recipe.img),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(recipe.name, style: Theme.of(context).textTheme.bodyMedium),
            (recipe.favorites.isNotEmpty
                ? Favorites(favorites: recipe.favorites)
                : SizedBox.shrink()),
          ],
        ),
      ],
    );
  }
}
