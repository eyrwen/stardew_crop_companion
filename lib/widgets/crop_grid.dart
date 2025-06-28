import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../data/crop.dart';
import '../data/interface.dart';
import 'item_grid.dart';
import 'search.dart';

class CropGrid extends HookWidget {
  final List<Crop> crops;
  final Function(Crop) onCropSelected;

  const CropGrid({
    super.key,
    required this.crops,
    required this.onCropSelected,
  });

  List<Crop> get _sortedCrops =>
      crops..sort((a, b) => a.name.compareTo(b.name));

  @override
  Widget build(BuildContext context) {
    final search = useTextEditingController();
    useListenable(search);

    return Column(
      children: [
        Search(controller: search),
        Expanded(
          child: ItemGrid(
            items: _sortedCrops
                .where(
                  (c) =>
                      search.text.isEmpty ||
                      c.name.toLowerCase().contains(search.text.toLowerCase()),
                )
                .toList(),
            onItemSelected: (Item item) => onCropSelected(item as Crop),
          ),
        ),
      ],
    );
  }
}
