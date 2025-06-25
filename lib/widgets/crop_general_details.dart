import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../data/crop.dart';
import '../data/recipe.dart';
import 'favorites.dart';

class CropGeneralDetails extends StatelessWidget {
  final Crop crop;

  const CropGeneralDetails({super.key, required this.crop});

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
                Image.asset('assets/img/${crop.img}'),
                InkWell(
                  onTap: () => launchUrlString(crop.url),
                  child: Text(
                    crop.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                crop.favorites.isNotEmpty
                    ? Favorites(favorites: crop.favorites)
                    : SizedBox.shrink(),
                SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8.0,
                  children: Recipe.sort(crop.recipes)
                      .map(
                        (recipe) => Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 8,
                          children: [
                            Image.asset('assets/img/${recipe.img}', height: 32),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  recipe.name,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                (recipe.type == RecipeType.cooking &&
                                        (recipe as CookingRecipe)
                                            .favorites
                                            .isNotEmpty
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
