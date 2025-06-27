import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../data/fish.dart';

class FishGrid extends StatelessWidget {
  final List<Fish> fish;
  final Function(Fish) onFishSelected;

  const FishGrid({
    super.key,
    required this.fish,
    required this.onFishSelected,
  });

  List<Fish> get sortedFish {
    return List.from(fish)..sort((a, b) => a.name.compareTo(b.name));
  }
  
  @override
  Widget build(BuildContext context) {
    final search = useTextEditingController();
    final filteredFish = useState<List<Fish>>(sortedFish);

    return Column(children: [
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
          onChanged: (value) {
            final query = value.toLowerCase();
            filteredFish.value = sortedFish
                .where((fish) => fish.name.toLowerCase().contains(query))
                .toList();
          },
        ),
      ),
      Expanded(
        child: GridView.extent(
          maxCrossAxisExtent: 200,
          children: filteredFish.value.map<Widget>((fish) {
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
          }).toList()
        ),
      ),
    ]);
  }
}