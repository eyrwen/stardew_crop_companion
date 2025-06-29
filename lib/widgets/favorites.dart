import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:stardew_crop_companion/widgets/capitalized_text.dart';

import 'item_image.dart';

class Favorites extends StatelessWidget {
  final List favorites;
  final bool splitLayout;

  const Favorites({
    super.key,
    required this.favorites,
    this.splitLayout = false,
  });

  const Favorites.split({super.key, required this.favorites})
    : splitLayout = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(children: [SizedBox(height: 3), ItemImage.small('heart')]),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: splitLayout
              ? favorites
                    .slices(2)
                    .map(
                      (pair) => Row(
                        spacing: 8.0,
                        children: pair
                            .map(
                              (fav) => Row(
                                spacing: 8.0,
                                children: [
                                  ItemImage.small(fav),
                                  CapitalizedText(fav),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    )
                    .toList()
              : favorites
                    .map(
                      (favorite) => Row(
                        spacing: 8.0,
                        children: [
                          ItemImage.small(favorite),
                          CapitalizedText(favorite),
                        ],
                      ),
                    )
                    .toList(),
        ),
      ],
    );
  }
}
