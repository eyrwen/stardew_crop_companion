import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../data/buff.dart';
import 'item_image.dart';

class Buffs extends StatelessWidget {
  final BuffList buffs;

  const Buffs({super.key, required this.buffs});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: buffs
          .toList()
          .groupListsBy((buff) => buff.time)
          .entries
          .map(
            (entry) => Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 8.0,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 2.0,
                      children: entry.value
                          .map((buff) => ItemImage.small(buff.type.img))
                          .toList(),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: entry.value
                          .map((buff) => Text(buff.type.name))
                          .toList(),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: entry.value
                          .map(
                            (buff) => Text(
                              '${buff.value > 0 ? '+' : ''}${buff.value}',
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
                Row(
                  spacing: 8.0,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [ItemImage.small('time'), Text(entry.key)],
                ),
              ],
            ),
          )
          .toList(),
    );
  }
}
