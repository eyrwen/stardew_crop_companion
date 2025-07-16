import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../data/interface.dart';
import 'item_image.dart';
import 'search.dart';

class ItemGrid extends HookWidget {
  final List<Item> items;
  final Function(Item) onItemSelected;
  final Widget? Function(Item)? getItemDecoration;
  final Widget? filterTools;
  final TextEditingController searchController;

  const ItemGrid({
    super.key,
    required this.items,
    required this.onItemSelected,
    this.getItemDecoration,
    this.filterTools,
    required this.searchController,
  });

  List<Item> get _sortedItems =>
      items..sort((a, b) => a.name.compareTo(b.name));

  @override
  Widget build(BuildContext context) {
    useListenable(searchController);

    final filteredItems = _sortedItems.where((item) {
      return searchController.text.isEmpty ||
          item.name.toLowerCase().contains(searchController.text.toLowerCase());
    }).toList();

    return Column(
      children: [
        Search(controller: searchController),
        filterTools ?? SizedBox.shrink(),
        Expanded(
          child: GridView.extent(
            maxCrossAxisExtent: 200,
            children: filteredItems.map<Widget>((item) {
              return Card(
                child: InkWell(
                  onTap: () => onItemSelected(item),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ItemImage(item.img),
                        Text(
                          item.name,
                          overflow: TextOverflow.clip,
                          textAlign: TextAlign.center,
                        ),
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
          ),
        ),
      ],
    );
  }
}
