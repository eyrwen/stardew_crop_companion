import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../data/fish.dart';

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
    final rainFilter = useState<bool>(false);
    final seasonFilter = useState<Season?>(null);
    final locationFilter = useState<FishableLocation?>(null);

    return Column(
      children: [
        Column(
          spacing: 8.0,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.5),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextField(
                controller: search,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
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
                SegmentedButton<Season?>(
                  emptySelectionAllowed: true,
                  showSelectedIcon: false,
                  segments: Season.values
                      .map(
                        (s) => ButtonSegment(
                          value: s,
                          label: Row(
                            children: [
                              Image.asset(
                                'assets/img/${s.img}',
                                height: 24,
                                semanticLabel: s.name,
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                s.name.replaceFirst(
                                  s.name[0],
                                  s.name[0].toUpperCase(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  selected: {seasonFilter.value},
                  onSelectionChanged: (seasons) {
                    seasonFilter.value = seasons.firstOrNull;
                  },
                ),
              ],
            ),
            SegmentedButton<FishableLocation?>(
              emptySelectionAllowed: true,
              showSelectedIcon: false,
              segments: FishableLocation.onlySpecial
                  .map(
                    (location) => ButtonSegment(
                      value: location,
                      label: Text(location.name),
                    ),
                  )
                  .toList(),
              selected: {locationFilter.value},
              onSelectionChanged: (locations) {
                locationFilter.value = locations.firstOrNull;
              },
            ),
          ],
        ),
        Expanded(
          child: GridView.extent(
            maxCrossAxisExtent: 200,
            children: sortedFish
                .where((fish) {
                  final matchesSearch =
                      search.text.isEmpty ||
                      fish.name.toLowerCase().contains(
                        search.text.toLowerCase(),
                      );
                  final matchesWeather = rainFilter.value
                      ? fish.exclusiveToRain
                      : !fish.exclusiveToRain;
                  final matchesSeason =
                      seasonFilter.value == null ||
                      fish.exclusiveToSeason(seasonFilter.value!);
                  final matchesLocation = locationFilter.value == null ||
                      fish.locations.any(
                        (location) =>
                            location.place == locationFilter.value!,
                      );

                  return matchesSearch && matchesWeather && matchesSeason && matchesLocation;
                })
                .map<Widget>((fish) {
                  return Card(
                    child: InkWell(
                      onTap: () => onFishSelected(fish),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset('assets/img/${fish.img}'),
                            Text(fish.name, overflow: TextOverflow.clip),
                          ],
                        ),
                      ),
                    ),
                  );
                })
                .toList(),
          ),
        ),
      ],
    );
  }
}
