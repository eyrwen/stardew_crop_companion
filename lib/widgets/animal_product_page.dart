import 'package:flutter/material.dart';

import '../data/animal_product.dart';
import '../data/recipe.dart';
import 'item_general_details.dart';
import 'item_produce_values.dart';
import 'item_raw_values.dart';

class AnimalProductPage extends StatelessWidget {
  final AnimalProduct animalProduct;
  final List<Recipe> recipes;
  final VoidCallback onBack;

  const AnimalProductPage({
    super.key,
    required this.animalProduct,
    required this.recipes,
    required this.onBack,
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
            item: animalProduct,
            recipes: recipes,
            includeRecipeFavorites: false,
            favoritesSplit: true,
          ),
          Row(
            children: [
              Column(
                spacing: 16.0,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ItemRawValues(item: animalProduct),
                  if (animalProduct.specialProduce != null)
                    ItemProduceValues(item: animalProduct),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
