import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../data/crop.dart';

class CropGrid extends HookWidget {
  final List<Crop> crops;
  final Function(Crop) onCropSelected;

  const CropGrid({
    super.key,
    required this.crops,
    required this.onCropSelected,
  });

  List<Crop> get _sortedCrops =>
      crops..sort((a, b) => a.name.compareTo(b.name));

  @override
  Widget build(BuildContext context) {
    final search = useTextEditingController();
    final filteredCrops = useState<List<Crop>>(_sortedCrops);

    return Column(
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
            onChanged: (value) {
              final query = value.toLowerCase();
              filteredCrops.value = _sortedCrops
                  .where((crop) => crop.name.toLowerCase().contains(query))
                  .toList();
            },
          ),
        ),
        Expanded(
          child: GridView.extent(
            maxCrossAxisExtent: 200,
            children: filteredCrops.value.map<Widget>((crop) {
              return Card(
                child: InkWell(
                  onTap: () => onCropSelected(crop),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset('assets/img/${crop.img}'),
                        Text(crop.name, overflow: TextOverflow.clip),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
