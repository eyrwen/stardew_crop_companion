import 'package:flutter/material.dart';

import '../data/interface.dart';
import 'crop_value_column.dart';

class ItemRawValues extends StatelessWidget {
  final Edible item;

  const ItemRawValues({super.key, required this.item});

  get silverPrice => (item.price * 1.25).floor();
  get silverEnergy => (item.energy * 1.4).floor();
  get silverHealth => (item.health * 1.4).round();

  get goldPrice => (item.price * 1.5).floor();
  get goldEnergy => (item.energy * 1.8).floor();
  get goldHealth => (item.health * 1.8).round();

  get iridiumPrice => (item.price * 2).floor();
  get iridiumEnergy => (item.energy * 2.6).floor();
  get iridiumHealth => (item.health * 2.6).round();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          spacing: 48,
          children: [
            CropValueColumn(
              price: item.price,
              energy: item.energy,
              health: item.health,
            ),
            if (item.hasQuality) ...[
              CropValueColumn.silver(
                price: silverPrice,
                energy: silverEnergy,
                health: silverHealth,
              ),
              CropValueColumn.gold(
                price: goldPrice,
                energy: goldEnergy,
                health: goldHealth,
              ),
              CropValueColumn.iridium(
                price: iridiumPrice,
                energy: iridiumEnergy,
                health: iridiumHealth,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
