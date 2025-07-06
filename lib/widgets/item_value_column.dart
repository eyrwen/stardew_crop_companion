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

  ItemValueColumn.silver({super.key, price, energy, health})
    : quality = 'silver',
      price = (price * 1.25).floor(),
      energy = (energy * 1.4).floor(),
      health = (health * 1.4).round();

  ItemValueColumn.gold({super.key, price, energy, health})
    : quality = 'gold',
      price = (price * 1.5).floor(),
      energy = (energy * 1.8).floor(),
      health = (health * 1.8).round();

  ItemValueColumn.iridium({super.key, price, energy, health})
    : quality = 'iridium',
      price = (price * 2).floor(),
      energy = (energy * 2.6).floor(),
      health = (health * 2.6).round();

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
