import 'package:flutter/material.dart';

import '../data/interface.dart';
import 'item_image.dart';

class ItemGrid extends StatelessWidget {
  final List<Item> items;
  final Function(Item) onItemSelected;
  final Widget? Function(Item)? getItemDecoration;

  const ItemGrid({
    super.key,
    required this.items,
    required this.onItemSelected,
    this.getItemDecoration,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.extent(
      maxCrossAxisExtent: 200,
      children: items.map<Widget>((item) {
        return Card(
          child: InkWell(
            onTap: () => onItemSelected(item),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ItemImage(item.img),
                  Text(item.name, overflow: TextOverflow.clip),
                  if (getItemDecoration != null) ...[
                    SizedBox(height: 8.0),
                    getItemDecoration!(item) ?? SizedBox.shrink(),
                  ],
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
