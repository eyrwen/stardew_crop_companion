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
    final legendaryFilter = useState<bool>(false);

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
                  onChanged: legendaryFilter.value == true
                      ? null
                      : (value) => rainFilter.value = value,
                ),
                Switch(
                  thumbIcon: WidgetStateProperty.fromMap(
                    <WidgetStatesConstraint, Icon>{
                      WidgetState.selected: Icon(Icons.star),
                      WidgetState.any: Icon(Icons.star_border),
                    },
                  ),
                  value: legendaryFilter.value,
                  onChanged: (value) {
                    legendaryFilter.value = value;
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
          ],
        ),
        Expanded(
          child: ItemGrid(
            items: sortedFish.where((fish) {
              final matchesSearch =
                  search.text.isEmpty ||
                  fish.name.toLowerCase().contains(search.text.toLowerCase());
              final matchesWeather =
                  (!rainFilter.value || fish.exclusiveToRain) || fish.legendary;
              final matchesSeason =
                  seasonFilter.value == null ||
                  fish.locations.any(
                    (location) =>
                        location.seasons.contains(seasonFilter.value!),
                  );
              final matchesLegendary = legendaryFilter.value
                  ? fish.legendary
                  : !fish.legendary;

              return matchesSearch &&
                  matchesWeather &&
                  matchesSeason &&
                  matchesLegendary;
            }).toList(),
            getItemDecoration: (item) {
              final fish = item as Fish;
              final decorations = <Widget>[];

              if (fish.exclusiveToRain) {
                decorations.add(
                  Row(
                    spacing: 8.0,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ItemImage.small(Weather.rainy.img),
                      CapitalizedText(
                        Weather.rainy.name,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                );
              }
              if (fish.exclusiveToWeather(Weather.sunny)) {
                decorations.add(
                  Row(
                    spacing: 8.0,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ItemImage.small(Weather.sunny.img),
                      CapitalizedText(
                        Weather.sunny.name,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                );
              }
              for (var season in Season.values) {
                if (fish.exclusiveToSeason(season)) {
                  decorations.add(
                    Row(
                      spacing: 8.0,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ItemImage.small(season.img),
                        CapitalizedText(
                          season.name,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  );
                }
              }
              return decorations.isEmpty
                  ? null
                  : Column(spacing: 8.0, children: decorations);
            },
            onItemSelected: (Item item) => onFishSelected(item as Fish),
          ),
        ),
      ],
    );
  }
}
