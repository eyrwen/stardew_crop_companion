import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'item_image.dart';

class PondOutputs extends StatelessWidget {
  final List<String> pondOutputs;

  const PondOutputs({super.key, required this.pondOutputs});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ItemImage.xlarge('fish_pond'),
        SizedBox(height: 8.0),
        Column(
          children: pondOutputs
              .slices(2)
              .map(
                (pair) => Row(
                  spacing: 4.0,
                  children: pair
                      .map(
                        (output) => Tooltip(
                          message: output,
                          child: ItemImage.large(output),
                        ),
                      )
                      .toList(),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
