import 'package:flutter/material.dart';

class CropValueColumn extends StatelessWidget {
  final int price;
  final int energy;
  final int health;
  final String? quality;

  const CropValueColumn({
    super.key,
    required this.price,
    required this.energy,
    required this.health,
    this.quality,
  });

  const CropValueColumn.gold({
    super.key,
    required this.price,
    required this.energy,
    required this.health,
  }) : quality = 'gold';

  const CropValueColumn.silver({
    super.key,
    required this.price,
    required this.energy,
    required this.health,
  }) : quality = 'silver';

  const CropValueColumn.iridium({
    super.key,
    required this.price,
    required this.energy,
    required this.health,
  }) : quality = 'iridium';

  _overlayedImage(String img) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Image.asset('assets/img/$img'),
        if (quality != null)
          Image.asset('assets/img/${quality}_quality_overlay.png', scale: 1.25),
      ],
    );
  }

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
              _overlayedImage(energy < 0 ? 'poison.png' : 'energy.png'),
              Text('$energy', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        if (health != 0)
          Row(
            children: [
              _overlayedImage('health.png'),
              Text('$health', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        Row(
          children: [
            _overlayedImage('gold.png'),
            Text('${price}G', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}
