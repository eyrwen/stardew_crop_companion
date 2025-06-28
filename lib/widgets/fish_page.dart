import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

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
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        spacing: 16.0,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(icon: Icon(Icons.arrow_back), onPressed: () => onBack()),
          ItemGeneralDetails(item: fish, recipes: recipes),
          Column(
            spacing: 16.0,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ItemRawValues(item: fish),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16.0,
                children: [
                  ItemProduceValues(item: fish),
                  fish.pondOutputs != null && fish.pondOutputs!.isNotEmpty
                      ? Card(
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/img/fish_pond.png',
                                  height: 96,
                                  semanticLabel: 'Fish Pond',
                                ),
                                SizedBox(height: 8.0),
                                Column(
                                  children: fish.pondOutputs!
                                      .slices(2)
                                      .map(
                                        (pair) => Row(
                                          children: pair
                                              .map(
                                                (output) => Image.asset(
                                                  'assets/img/$output.png',
                                                  height: 32,
                                                ),
                                              )
                                              .toList(),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ],
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
