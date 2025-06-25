import 'package:flutter/material.dart';

import '../data/crop.dart';
import 'crop_value_column.dart';

class CropRawValues extends StatelessWidget {
  final Crop crop;

  const CropRawValues({super.key, required this.crop});

  get silverPrice => (crop.price * 1.25).floor();
  get silverEnergy => (crop.energy * 1.4).floor();
  get silverHealth => (crop.health * 1.4).round();

  get goldPrice => (crop.price * 1.5).floor();
  get goldEnergy => (crop.energy * 1.8).floor();
  get goldHealth => (crop.health * 1.8).round();

  get iridiumPrice => (crop.price * 2).floor();
  get iridiumEnergy => (crop.energy * 2.6).floor();
  get iridiumHealth => (crop.health * 2.6).round();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          spacing: 48,
          children: [
            CropValueColumn(
              price: crop.price,
              energy: crop.energy,
              health: crop.health,
            ),
            if (crop.hasQuality) ...[
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
