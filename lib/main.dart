import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stardew_crop_companion/utils/use_melting_pot_recipes.dart';

import 'data/animal_product.dart';
import 'data/crop.dart';
import 'data/fish.dart';
import 'data/interface.dart';
import 'data/recipe.dart';
import 'utils/use_json.dart';
import 'widgets/fish_grid.dart';
import 'widgets/fishing_locations.dart';
import 'widgets/item_grid.dart';
import 'widgets/item_image.dart';
import 'widgets/item_page_layout.dart';
import 'widgets/pond_outputs.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stardew Crop Companion',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends HookWidget {
  MyHomePage({super.key});

  final List<Tab> TABS = [
    const Tab(text: 'Crops', icon: ItemImage('farming')),
    const Tab(text: 'Fish', icon: ItemImage('fishing')),
  ];

  @override
  Widget build(BuildContext context) {
    final loadCrops = useJson<Crop>('assets/crops.json', Crop.fromJson);
    final loadFish = useJson<Fish>('assets/fish.json', Fish.fromJson);
    final loadRecipes = useJson<Recipe>('assets/recipes.json', Recipe.fromJson);
    final loadAnimalProducts = useJson<AnimalProduct>(
      'assets/animal_products.json',
      AnimalProduct.fromJson,
    );
    final loadMeltingPotRecipes = useMeltingPotRecipes();

    return DefaultTabController(
      length: TABS.length,
      child: Scaffold(
        bottomNavigationBar: TabBar(tabs: TABS),
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img/bg_day.png'),
                fit: BoxFit.cover,
              ),
            ),
            padding: const EdgeInsets.all(8.0),
            child: TabBarView(
              children: [
                CropsTab(
                  allCrops: loadCrops,
                  allAnimalProducts: loadAnimalProducts,
                  allRecipes: loadRecipes,
                  allMeltingPotRecipes: loadMeltingPotRecipes,
                ),
                FishTab(
                  allFish: loadFish,
                  allRecipes: loadRecipes,
                  allMeltingPotRecipes: loadMeltingPotRecipes,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CropsTab extends HookWidget {
  final AsyncSnapshot<List<Crop>> allCrops;
  final AsyncSnapshot<List<AnimalProduct>> allAnimalProducts;
  final AsyncSnapshot<List<Recipe>> allRecipes;
  final AsyncSnapshot<List<Recipe>> allMeltingPotRecipes;

  const CropsTab({
    super.key,
    required this.allCrops,
    required this.allAnimalProducts,
    required this.allRecipes,
    required this.allMeltingPotRecipes,
  });

  @override
  Widget build(BuildContext context) {
    final viewingItem = useState<Item?>(null);

    selectItem(Item item) {
      viewingItem.value = item;
    }

    if (viewingItem.value != null) {
      return ItemPageLayout(
        item: viewingItem.value!,
        recipes: [
          ...allRecipes.data!,
          ...allMeltingPotRecipes.data!,
        ].where((r) => r.requires(viewingItem.value!)).toList(),
        onBack: () => viewingItem.value = null,
      );
    }
    if (allCrops.hasError) {
      return Text(allCrops.error?.toString() ?? 'Error loading crops');
    } else if (allRecipes.hasError) {
      return Text(allRecipes.error?.toString() ?? 'Error loading recipes');
    } else if (allAnimalProducts.hasError) {
      return Text(
        allAnimalProducts.error?.toString() ?? 'Error loading products',
      );
    } else if (allMeltingPotRecipes.hasError) {
      return Text(
        allMeltingPotRecipes.error?.toString() ??
            'Error loading melting pot recipes',
      );
    } else if (!allCrops.hasData ||
        !allRecipes.hasData ||
        !allAnimalProducts.hasData ||
        !allMeltingPotRecipes.hasData) {
      return LinearProgressIndicator();
    } else {
      return ItemGrid(
        items: [...allCrops.data!, ...allAnimalProducts.data!],
        onItemSelected: selectItem,
      );
    }
  }
}

class FishTab extends HookWidget {
  final AsyncSnapshot<List<Fish>> allFish;
  final AsyncSnapshot<List<Recipe>> allRecipes;
  final AsyncSnapshot<List<Recipe>> allMeltingPotRecipes;

  const FishTab({
    super.key,
    required this.allFish,
    required this.allRecipes,
    required this.allMeltingPotRecipes,
  });

  @override
  Widget build(BuildContext context) {
    final viewingFish = useState<Fish?>(null);

    selectFish(Fish fish) {
      viewingFish.value = fish;
    }

    if (viewingFish.value != null) {
      return ItemPageLayout(
        item: viewingFish.value!,
        seasons: FishingLocations(fish: viewingFish.value!),
        recipes: [
          ...allRecipes.data!,
          ...allMeltingPotRecipes.data!,
        ].where((r) => r.requires(viewingFish.value!)).toList(),
        additionalDetails: viewingFish.value!.pondOutputs.isNotEmpty
            ? PondOutputs(pondOutputs: viewingFish.value!.pondOutputs)
            : null,
        onBack: () => viewingFish.value = null,
      );
    }

    if (allFish.hasError) {
      return Text(allFish.error?.toString() ?? 'Error loading fish');
    } else if (allRecipes.hasError) {
      return Text(allRecipes.error?.toString() ?? 'Error loading recipes');
    } else if (allMeltingPotRecipes.hasError) {
      return Text(
        allMeltingPotRecipes.error?.toString() ??
            'Error loading melting pot recipes',
      );
    } else if (!allFish.hasData ||
        !allRecipes.hasData ||
        !allMeltingPotRecipes.hasData) {
      return LinearProgressIndicator();
    } else {
      return FishGrid(fish: allFish.data!, onFishSelected: selectFish);
    }
  }
}
