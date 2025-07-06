import 'package:flutter/material.dart';

import 'capitalized_text.dart';
import 'item_image.dart';

class Favorites extends StatelessWidget {
  final List<String> favorites;
  final MainAxisAlignment mainAxisAlignment;

  const Favorites({
    super.key,
    required this.favorites,
    this.mainAxisAlignment = MainAxisAlignment.center,
  });

  List<String> get _sortedFavorites {
    return favorites.map((favorite) => favorite.toLowerCase()).toList()..sort();
  }

  int get _pivot {
    return (favorites.length / 2).ceil();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          spacing: 8,
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(children: [SizedBox(height: 3), ItemImage.small('heart')]),
            favorites.length > 4
                ? Row(
                    spacing: 8.0,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: _sortedFavorites.take(_pivot).map((favorite) {
                          return FavoriteDetails(favorite: favorite);
                        }).toList(),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: _sortedFavorites.skip(_pivot).map((favorite) {
                          return FavoriteDetails(favorite: favorite);
                        }).toList(),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _sortedFavorites
                        .map((favorite) => FavoriteDetails(favorite: favorite))
                        .toList(),
                  ),
          ],
        ),
      ],
    );
  }
}

class FavoriteDetails extends StatelessWidget {
  final String favorite;

  const FavoriteDetails({super.key, required this.favorite});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8.0,
      children: [ItemImage.small(favorite), CapitalizedText(favorite)],
    );
  }
}
