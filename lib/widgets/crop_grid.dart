import 'package:flutter/material.dart';

import '../data/crop.dart';

class CropGrid extends StatelessWidget {
  final List<Crop> crops;
  final Function(Crop) onCropSelected;

  const CropGrid({
    super.key,
    required this.crops,
    required this.onCropSelected,
  });

  get _sortedCrops => crops..sort((a, b) => a.name.compareTo(b.name));

  @override
  Widget build(BuildContext context) {
    return GridView.extent(
      maxCrossAxisExtent: 200,
      children: _sortedCrops.map<Widget>((crop) {
        return Card(
          child: InkWell(
            onTap: () => onCropSelected(crop),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/img/${crop.img}'),
                  Text(crop.name, overflow: TextOverflow.clip),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
