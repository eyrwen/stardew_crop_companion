import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'item_image.dart';

class ArrowRight extends StatelessWidget {
  const ArrowRight({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.flip(
      flipX: true,
      child: Transform.rotate(
        angle: -90 * (math.pi / 180),
        child: ItemImage.small('arrow_up'),
      ),
    );
  }
}
