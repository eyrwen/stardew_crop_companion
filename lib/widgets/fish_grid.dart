import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../data/fish.dart';
import '../data/interface.dart';
import 'capitalized_text.dart';
import 'item_grid.dart';
import 'item_image.dart';
import 'search.dart';

class FishGrid extends HookWidget {
  final List<Fish> fish;
  final Function(Fish) onFishSelected;

  const FishGrid({super.key, required this.fish, required this.onFishSelected});

  List<Fish> get sortedFish {
    return List.from(fish)..sort((a, b) => a.name.compareTo(b.name));
  }

  @override
  Widget build(BuildContext context) {
    final search = useTextEditingController();
    useListenable(search);
    final rainFilter = useState<bool>(false);
    final seasonFilter = useState<Season?>(null);
    final locationFilter = useState<FishableLocation?>(null);

    return Column(
      children: [
        Column(
          spacing: 8.0,
          children: [
            Search(controller: search),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Switch(
                  thumbIcon: WidgetStateProperty<Icon>.fromMap(
                    <WidgetStatesConstraint, Icon>{
                      WidgetState.selected: Icon(Icons.cloud),
                      WidgetState.any: Icon(Icons.sunny),
                    },
                  ),
                  value: rainFilter.value,
                  onChanged: (value) {
                    rainFilter.value = value;
                  },
                ),
                SearchFilter(
                  children: Season.values
                      .map(
                        (s) => ButtonSegment(
                          value: s,
                          label: Row(
                            spacing: 8.0,
                            children: [
                              ItemImage.medium(s.img),
                              CapitalizedText(s.name),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  selected: seasonFilter.value,
                  onSelected: (season) {
                    seasonFilter.value = season;
                  },
                ),
              ],
            ),
            SearchFilter<FishableLocation>(
              children: FishableLocation.onlySpecial
                  .map(
                    (location) => ButtonSegment(
                      value: location,
                      label: Text(location.name),
                    ),
                  )
                  .toList(),
              selected: locationFilter.value,
              onSelected: (location) {
                locationFilter.value = location;
              },
            ),
          ],
        ),
        Expanded(
          child: ItemGrid(
            items: sortedFish.where((fish) {
              final matchesSearch =
                  search.text.isEmpty ||
                  fish.name.toLowerCase().contains(search.text.toLowerCase());
              final matchesWeather = rainFilter.value
                  ? fish.exclusiveToRain
                  : !fish.exclusiveToRain;
              final matchesSeason =
                  seasonFilter.value == null ||
                  fish.exclusiveToSeason(seasonFilter.value!);
              final matchesLocation =
                  locationFilter.value == null ||
                  fish.locations.any(
                    (location) => location.place == locationFilter.value!,
                  );

              return matchesSearch &&
                  matchesWeather &&
                  matchesSeason &&
                  matchesLocation;
            }).toList(),
            onItemSelected: (Item item) => onFishSelected(item as Fish),
          ),
        ),
      ],
    );
  }
}
