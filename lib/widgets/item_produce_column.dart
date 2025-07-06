import 'package:flutter/material.dart' hide Tooltip;
import 'package:stardew_crop_companion/widgets/arrow_right.dart';

import 'capitalized_text.dart';
import 'tooltip.dart';
import '../data/interface.dart';
import '../data/produce_machine.dart';
import 'favorites.dart';
import 'item_image.dart';
import 'item_value_column.dart';

class ItemProduceColumn extends StatelessWidget {
  final ProduceMachineOutput output;
  final ProduceMachine machine;
  final Item item;

  const ItemProduceColumn({
    super.key,
    required this.output,
    required this.machine,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomLeft,
          clipBehavior: Clip.none,
          children: [
            Stack(
              alignment: Alignment.bottomLeft,
              clipBehavior: Clip.none,
              children: [
                Tooltip(
                  content: CapitalizedText(machine.name),
                  child: ItemImage.xlarge(machine.img),
                ),
                if (!output.multiInput && !output.multiOutput)
                  Positioned(
                    bottom: 0,
                    left: -8,
                    child: Tooltip(
                      content: CapitalizedText(output.outputName),
                      child: ItemImage.medium(
                        output.outputImg,
                        overlay: output.outputQuality != null
                            ? "${output.outputQuality!}_quality_overlay.png"
                            : null,
                        overlayScale: 2.0,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        if (output.multiInput || output.multiOutput)
          Row(
            spacing: 4.0,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ItemImage.medium(item.img),
                  if (output.multiInput)
                    Text(
                      'x${output.inputCount}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                ],
              ),
              ArrowRight(),
              Tooltip(
                position: ElTooltipPosition.rightCenter,
                content: Text(output.outputName),
                child: Row(
                  children: [
                    ItemImage.medium(output.outputImg),
                    if (output.multiOutput)
                      Text(
                        'x${output.outputCount}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                  ],
                ),
              ),
            ],
          ),
        SizedBox(height: 8.0),
        Row(
          spacing: 8.0,
          children: [
            ItemImage.small('time'),
            Text(
              output.time,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        ItemValueColumn(
          price: output.priceFormulator.calculate(item),
          energy: output.energyFormulator.calculate(item),
          health: output.healthFormulator.calculate(item),
        ),
        output.favorites.isNotEmpty
            ? Favorites(favorites: output.favorites)
            : SizedBox.shrink(),
      ],
    );
  }
}
