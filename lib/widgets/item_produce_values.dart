import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../data/interface.dart';
import 'crop_value_column.dart';
import 'favorites.dart';
import '../data/produce_machine.dart';

class ItemProduceValues extends StatelessWidget {
  final Producable item;

  const ItemProduceValues({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: item.produceOutputs.entries
              .slices(6)
              .expand(
                (slice) => [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 32,
                    children: slice
                        .map(
                          (entry) => ItemProduceColumn(
                            output: entry.value,
                            machine: entry.key,
                            item: item,
                          ),
                        )
                        .toList(),
                  ),
                ],
              )
              .toList(),
        ),
      ),
    );
  }
}

class ItemProduceColumn extends StatelessWidget {
  final ProduceMachineOutput output;
  final ProduceMachine machine;
  final Producable item;

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
            Image.asset('assets/img/${machine.img}', height: 96),
            Positioned(
              left: -8,
              bottom: -4,
              child: Tooltip(
                message: output.outputName,
                child: Image.asset(
                  'assets/img/${output.outputImg}',
                  height: 24,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          spacing: 8.0,
          children: [
            Image.asset('assets/img/time.png', height: 16),
            Text(
              output.time,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        CropValueColumn(
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
