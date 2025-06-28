import 'package:flutter/material.dart';

import 'capitalized_text.dart';
import 'item_image.dart';

class Favorites extends StatelessWidget {
  final List favorites;

  const Favorites({super.key, required this.favorites});

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
          children: favorites
              .map(
                (fav) => Row(
                  spacing: 4,
                  children: [
                    ItemImage.small(fav.toString().toLowerCase()),
                    CapitalizedText(
                      fav,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
