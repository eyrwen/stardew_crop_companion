import 'package:flutter/material.dart';

import '../data/buff.dart';
import 'item_image.dart';

class Buffs extends StatelessWidget {
  final List<Buff> buffs;

  const Buffs({super.key, required this.buffs});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: buffs
          .map(
            (buff) => Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  spacing: 8.0,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ItemImage.small(buff.type.img),
                    Text(
                      '${buff.type.name} (${buff.value > 0 ? '+' : ''}${buff.value})',
                    ),
                  ],
                ),
                Row(
                  spacing: 8.0,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [ItemImage.small('time'), Text(buff.time)],
                ),
              ],
            ),
          )
          .toList(),
    );
  }
}
