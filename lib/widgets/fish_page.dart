import 'package:flutter/material.dart';

import '../data/fish.dart';
import '../data/recipe.dart';
import 'item_general_details.dart';
import 'item_produce_values.dart';
import 'item_raw_values.dart';

class FishPage extends StatelessWidget {
  final Fish fish;
  final VoidCallback onBack;
  final List<Recipe> recipes;

  const FishPage({
    super.key,
    required this.fish,
    required this.onBack,
    required this.recipes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.all(8.0), child: Row(
      spacing: 16.0,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(icon: Icon(Icons.arrow_back), onPressed: () => onBack()),
        ItemGeneralDetails(item: fish, recipes: recipes),
        Column(spacing: 16.0, crossAxisAlignment: CrossAxisAlignment.start, children: [
          ItemRawValues(item: fish),
          ItemProduceValues(item: fish)
        ]),
      ]
    ));
  }
}