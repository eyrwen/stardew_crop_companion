import 'package:flutter/material.dart';

import '../data/crop.dart';
import '../data/interface.dart';
import '../data/recipe.dart';
import 'item_general_details.dart';
import 'item_produce_values.dart';
import 'item_raw_values.dart';

class CropPage extends StatelessWidget {
  final Crop crop;
  final List<Recipe> recipes;
  final VoidCallback onBack;

  const CropPage({super.key, required this.crop, required this.recipes, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        spacing: 16.0,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(icon: Icon(Icons.arrow_back), onPressed: () => onBack()),
          ItemGeneralDetails(item: crop, recipes: recipes),
          Column(
            spacing: 16.0,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ItemRawValues(item: crop),
              crop.type == ItemType.other
                  ? SizedBox.shrink()
                  : ItemProduceValues(item: crop),
            ],
          ),
        ],
      ),
    );
  }
}
