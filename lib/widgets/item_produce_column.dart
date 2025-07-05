import 'package:flutter/material.dart';
import 'package:stardew_crop_companion/data/interface.dart';
import 'package:stardew_crop_companion/data/produce_machine.dart';
import 'package:stardew_crop_companion/widgets/favorites.dart';
import 'package:stardew_crop_companion/widgets/item_image.dart';
import 'package:stardew_crop_companion/widgets/item_value_column.dart';

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
            ItemImage.xlarge(machine.img),
            Positioned(
              left: -8,
              bottom: -4,
              child: Tooltip(
                message: output.outputName,
                child: ItemImage.medium(output.outputImg),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
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
