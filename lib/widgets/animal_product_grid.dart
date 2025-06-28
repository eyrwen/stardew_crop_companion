import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../data/animal_product.dart';
import 'item_grid.dart';
import 'search.dart';

class AnimalProductGrid extends HookWidget {
  final List<AnimalProduct> animalProducts;
  final Function(AnimalProduct) onAnimalProductSelected;

  const AnimalProductGrid({
    super.key,
    required this.animalProducts,
    required this.onAnimalProductSelected,
  });

  List<AnimalProduct> get sortedAnimalProducts {
    return List.from(animalProducts)..sort((a, b) => a.name.compareTo(b.name));
  }

  @override
  Widget build(BuildContext context) {
    final search = useTextEditingController();
    useListenable(search);

    return Column(
      children: [
        Search(controller: search),
        Expanded(
          child: ItemGrid(
            items: sortedAnimalProducts
                .where(
                  (ap) =>
                      search.text.isEmpty ||
                      ap.name.toLowerCase().contains(search.text.toLowerCase()),
                )
                .toList(),
            onItemSelected: (item) =>
                onAnimalProductSelected(item as AnimalProduct),
          ),
        ),
      ],
    );
  }
}
