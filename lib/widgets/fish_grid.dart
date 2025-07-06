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

  @override
  Widget build(BuildContext context) {
    final rainFilter = useState<bool>(false);
    final seasonFilter = useState<Season?>(null);
    final legendaryFilter = useState<bool>(false);

    final filteredFish = fish.where((fish) {
      final matchesWeather =
          (!rainFilter.value || fish.exclusiveToRain) || fish.legendary;
      final matchesSeason =
          seasonFilter.value == null ||
          fish.locations.any(
            (location) => location.seasons.contains(seasonFilter.value!),
          );
      final matchesLegendary = legendaryFilter.value
          ? fish.legendary
          : !fish.legendary;

      return matchesWeather && matchesSeason && matchesLegendary;
    }).toList();

    return ItemGrid(
      items: filteredFish,
      filterTools: FilterTools(
        rainFilter: rainFilter,
        seasonFilter: seasonFilter,
        legendaryFilter: legendaryFilter,
      ),
      onItemSelected: (Item item) {
        onFishSelected(item as Fish);
      },
      getItemDecoration: (Item item) => ItemDecoration(fish: item as Fish),
    );
  }
}

class FilterTools extends StatelessWidget {
  final ValueNotifier<bool> rainFilter;
  final ValueNotifier<Season?> seasonFilter;
  final ValueNotifier<bool> legendaryFilter;

  const FilterTools({
    super.key,
    required this.rainFilter,
    required this.seasonFilter,
    required this.legendaryFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RainFilter(rainFilter: rainFilter),
        LegendaryFilter(legendaryFilter: legendaryFilter),
        SeasonFilter(seasonFilter: seasonFilter),
      ],
    );
  }
}

class RainFilter extends StatelessWidget {
  final ValueNotifier<bool> rainFilter;

  const RainFilter({super.key, required this.rainFilter});

  @override
  Widget build(BuildContext context) {
    return Switch(
      thumbIcon: WidgetStateProperty.fromMap(<WidgetStatesConstraint, Icon>{
        WidgetState.selected: Icon(Icons.cloud),
        WidgetState.any: Icon(Icons.sunny),
      }),
      value: rainFilter.value,
      onChanged: (value) {
        rainFilter.value = value;
      },
    );
  }
}

class LegendaryFilter extends StatelessWidget {
  final ValueNotifier<bool> legendaryFilter;

  const LegendaryFilter({super.key, required this.legendaryFilter});

  @override
  Widget build(BuildContext context) {
    return Switch(
      thumbIcon: WidgetStateProperty.fromMap(<WidgetStatesConstraint, Icon>{
        WidgetState.selected: Icon(Icons.star),
        WidgetState.any: Icon(Icons.star_border),
      }),
      value: legendaryFilter.value,
      onChanged: (value) {
        legendaryFilter.value = value;
      },
    );
  }
}

class SeasonFilter extends StatelessWidget {
  final ValueNotifier<Season?> seasonFilter;

  const SeasonFilter({super.key, required this.seasonFilter});

  @override
  Widget build(BuildContext context) {
    return SearchFilter(
      children: Season.values
          .map(
            (s) => ButtonSegment(
              value: s,
              label: Row(
                spacing: 8.0,
                children: [ItemImage.medium(s.img), CapitalizedText(s.name)],
              ),
            ),
          )
          .toList(),
      selected: seasonFilter.value,
      onSelected: (season) {
        seasonFilter.value = season;
      },
    );
  }
}

class ItemDecoration extends StatelessWidget {
  final Fish fish;

  const ItemDecoration({super.key, required this.fish});

  @override
  Widget build(BuildContext context) {
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
        ? SizedBox.shrink()
        : Column(spacing: 8.0, children: decorations);
  }
}
