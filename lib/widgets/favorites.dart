import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:stardew_crop_companion/widgets/capitalized_text.dart';

import 'item_image.dart';

class Favorites extends StatelessWidget {
  final List favorites;
  final MainAxisAlignment mainAxisAlignment;

  const Favorites({
    super.key,
    required this.favorites,
    this.mainAxisAlignment = MainAxisAlignment.center,
  });

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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: favorites.length > 10
                  ? favorites
                        .slices(2)
                        .map(
                          (pair) => Row(
                            spacing: 8.0,
                            children: pair
                                .map(
                                  (fav) => Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    spacing: 8.0,
                                    children: [
                                      ItemImage.small(fav),
                                      CapitalizedText(
                                        fav,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall,
                                      ),
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
        ),
      ],
    );
  }
}
