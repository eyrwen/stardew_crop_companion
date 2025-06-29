import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../data/fish.dart';
import '../data/recipe.dart';
import 'capitalized_text.dart';
import 'item_general_details.dart';
import 'item_image.dart';
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
          ItemGeneralDetails(
            item: fish,
            recipes: recipes,
            seasons: Column(
              spacing: 8.0,
              children: FishingLocation.sort(fish.locations)
                  .map(
                    (location) => Column(
                      children: Season.isAll(location.seasons)
                          ? [
                              location.places.first == FishableLocation.crabpot
                                  ? Row(
                                      spacing: 8.0,
                                      children: [
                                        ItemImage.small('crabpot'),
                                        Text('Crab Pot'),
                                      ],
                                    )
                                  : Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      spacing: 8.0,
                                      children: [
                                        ItemImage.small('all_seasons'),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children:
                                              FishableLocation.sort(
                                                    location.places,
                                                  )
                                                  .map(
                                                    (loc) => Row(
                                                      spacing: 8.0,
                                                      children: [
                                                        Text(
                                                          loc.name,
                                                          style: Theme.of(
                                                            context,
                                                          ).textTheme.bodySmall,
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                  .toList(),
                                        ),
                                      ],
                                    ),
                            ]
                          : ([
                              Row(
                                spacing: 8.0,
                                children: location.seasons
                                    .map(
                                      (season) => Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        spacing: 8.0,
                                        children: [
                                          ItemImage.small(season.img),
                                          CapitalizedText(season.name),
                                        ],
                                      ),
                                    )
                                    .toList(),
                              ),
                              Column(
                                children: FishableLocation.sort(location.places)
                                    .slices(2)
                                    .map(
                                      (pair) => Row(
                                        spacing: 8.0,
                                        children: [
                                          Text(
                                            pair[0].name,
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodySmall,
                                          ),
                                          if (pair.length > 1) ...[
                                            Icon(
                                              Icons.circle,
                                              size: 4.0,
                                              color: Colors.grey,
                                            ),
                                            Text(
                                              pair[1].name,
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodySmall,
                                            ),
                                          ],
                                        ],
                                      ),
                                    )
                                    .toList(),
                              ),
                            ]),
                    ),
                  )
                  .toList(),
            ),
          ),
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
                                ItemImage.xlarge('fish_pond'),
                                SizedBox(height: 8.0),
                                Column(
                                  children: fish.pondOutputs!
                                      .slices(2)
                                      .map(
                                        (pair) => Row(
                                          spacing: 4.0,
                                          children: pair
                                              .map(
                                                (output) =>
                                                    ItemImage.large(output),
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
