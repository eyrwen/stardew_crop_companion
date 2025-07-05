import 'package:flutter/material.dart';

import 'item_image.dart';

class ItemValueColumn extends StatelessWidget {
  final int price;
  final int energy;
  final int health;
  final String? quality;

  const ItemValueColumn({
    super.key,
    required this.price,
    required this.energy,
    required this.health,
    this.quality,
  });

  const ItemValueColumn.gold({
    super.key,
    required this.price,
    required this.energy,
    required this.health,
  }) : quality = 'gold';

  const ItemValueColumn.silver({
    super.key,
    required this.price,
    required this.energy,
    required this.health,
  }) : quality = 'silver';

  const ItemValueColumn.iridium({
    super.key,
    required this.price,
    required this.energy,
    required this.health,
  }) : quality = 'iridium';

  get inedible => energy == 0 && health == 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (energy != 0)
          Row(
            children: [
              ItemImage(
                energy < 0 ? 'poison.png' : 'energy.png',
                overlay: quality != null
                    ? '${quality}_quality_overlay.png'
                    : null,
              ),
              Text('$energy', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        if (health != 0)
          Row(
            children: [
              ItemImage(
                'health.png',
                overlay: quality != null
                    ? '${quality}_quality_overlay.png'
                    : null,
              ),
              Text('$health', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        Row(
          children: [
            ItemImage(
              'gold.png',
              overlay: quality != null
                  ? '${quality}_quality_overlay.png'
                  : null,
            ),
            Text('${price}G', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}
