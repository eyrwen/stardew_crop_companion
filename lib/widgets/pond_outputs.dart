import 'package:collection/collection.dart';
import 'package:flutter/material.dart' hide Tooltip;
import 'package:stardew_crop_companion/widgets/capitalized_text.dart';

import 'item_image.dart';
import 'tooltip.dart';

class PondOutputs extends StatelessWidget {
  final List<String> pondOutputs;

  const PondOutputs({super.key, required this.pondOutputs});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
                          position: ElTooltipPosition.rightCenter,
                          content: CapitalizedText(output.split('_').join(' ')),
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
