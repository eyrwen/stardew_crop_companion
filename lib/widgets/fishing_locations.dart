import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../data/fish.dart';
import 'capitalized_text.dart';
import 'item_image.dart';

class FishingLocations extends StatelessWidget {
  final Fish fish;

  const FishingLocations({super.key, required this.fish});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8.0,
      children: [
        if (fish.exclusiveToRain)
          Row(
            spacing: 8.0,
            children: [
              ItemImage.small(Weather.rainy.img),
              CapitalizedText(Weather.rainy.name),
            ],
          ),
        if (fish.exclusiveToWeather(Weather.sunny))
          Row(
            spacing: 8.0,
            children: [
              ItemImage.small(Weather.sunny.img),
              CapitalizedText(Weather.sunny.name),
            ],
          ),
        ...FishingLocation.sort(fish.locations).map(
          (location) => Column(
            children: Season.isAll(location.seasons)
                ? [AllSeasonsLocation(places: location.places)]
                : [
                    SeasonsList(seasons: location.seasons),
                    Column(
                      children: FishableLocation.sort(location.places)
                          .slices(2)
                          .map(
                            (pair) => Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 8.0,
                              children: [
                                PlaceName(place: pair.first),
                                if (pair.length > 1) ...[
                                  Icon(
                                    Icons.circle,
                                    size: 4.0,
                                    color: Colors.grey,
                                  ),
                                  PlaceName(place: pair.last),
                                ],
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ],
          ),
        ),
      ],
    );
  }
}

class AllSeasonsLocation extends StatelessWidget {
  final List<FishableLocation> places;

  const AllSeasonsLocation({super.key, required this.places});

  @override
  Widget build(BuildContext context) {
    if (places.first == FishableLocation.crabpot) {
      return Row(
        spacing: 8.0,
        children: [
          ItemImage.small('crabpot'),
          Text(FishableLocation.crabpot.name),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8.0,
      children: [
        ItemImage.small('all_seasons'),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: FishableLocation.sort(
            places,
          ).map((place) => PlaceName(place: place)).toList(),
        ),
      ],
    );
  }
}

class PlaceName extends StatelessWidget {
  final FishableLocation place;

  const PlaceName({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8.0,
      children: [
        Text(place.name, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class SeasonsList extends StatelessWidget {
  final List<Season> seasons;

  const SeasonsList({super.key, required this.seasons});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8.0,
      children: seasons
          .map(
            (season) => Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 8.0,
              children: [
                ItemImage.small(season.img),
                CapitalizedText(season.name),
              ],
            ),
          )
          .toList(),
    );
  }
}
