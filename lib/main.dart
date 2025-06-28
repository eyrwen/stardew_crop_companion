import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'data/crop.dart';
import 'data/fish.dart';
import 'data/recipe.dart';
import 'widgets/crop_grid.dart';
import 'widgets/crop_page.dart';
import 'widgets/fish_grid.dart';
import 'widgets/fish_page.dart';

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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends HookWidget {
  const MyHomePage({super.key});

  Future<List<Crop>> _loadCrops() async {
    final cropJson = await json.decode(
      await rootBundle.loadString('assets/crops.json'),
    );
    return cropJson.entries
      .map<Crop>((entry) => Crop.fromJson(entry.key, entry.value)).toList();
  }

  Future<List<Recipe>> _loadRecipes() async {
    final recipeJson = await json.decode(
      await rootBundle.loadString('assets/recipes.json'),
    );
    return recipeJson.entries
        .map<Recipe>((entry) => Recipe.fromJson(entry.key, entry.value))
        .toList();
  }

  Future<List<Fish>> _loadFish() async {
    final fishJson = await json.decode(
      await rootBundle.loadString('assets/fish.json'),
    );
    return fishJson.entries
        .map<Fish>((entry) => Fish.fromJson(entry.key, entry.value))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(text: 'Crops', icon: Image.asset('assets/img/farming.png', semanticLabel: 'Crops')),
            Tab(text: 'Fish', icon: Image.asset('assets/img/fishing.png', semanticLabel: 'Fish')),
            Tab(text: 'Animal Products', icon: Image.asset('assets/img/large_egg.png', semanticLabel: 'Animal Products')),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/img/bg_day.png'),
              fit: BoxFit.cover,
            ),
          ),
          padding: const EdgeInsets.all(8.0),
          child: TabBarView(
            children: [
              CropsTab(allCrops: _loadCrops(), allRecipes: _loadRecipes()),
              FishTab(allFish: _loadFish(), allRecipes: _loadRecipes()),
              AnimalProductsTab(),
            ],
          ),
        ),
      ),
    );
  }
}

class CropsTab extends HookWidget {
  final Future<List<Crop>> allCrops;
  final Future<List<Recipe>> allRecipes;

  const CropsTab({super.key, required this.allCrops, required this.allRecipes});

  @override
  Widget build(BuildContext context) {
    final crops = useFuture<List<Crop>>(useMemoized(() => allCrops));
    final recipes = useFuture<List<Recipe>>(useMemoized(() => allRecipes));
    final viewingCrop = useState<Crop?>(null);

    selectCrop(Crop crop) {
      viewingCrop.value = crop;
    }

    if (viewingCrop.value != null) {
      return CropPage(
        crop: viewingCrop.value!,
        recipes: recipes.data?.where((r) => r.requires(viewingCrop.value!)).toList() ?? [],
        onBack: () => viewingCrop.value = null,
      );
    }
    if (crops.hasError) {
      return Text(crops.error?.toString() ?? 'Error loading crops');
    } else if (recipes.hasError) {
      return Text(recipes.error?.toString() ?? 'Error loading recipes');
    } else if (!crops.hasData || !recipes.hasData) {
      return LinearProgressIndicator();
    } else {
      return CropGrid(crops: crops.data!, onCropSelected: selectCrop);
    }
  }
}

class FishTab extends HookWidget {
  final Future<List<Fish>> allFish;
  final Future<List<Recipe>> allRecipes;
  
  const FishTab({super.key, required this.allFish, required this.allRecipes});

  @override
  Widget build(BuildContext context) {
    final fish = useFuture<List<Fish>>(useMemoized(() => allFish));
    final recipes = useFuture<List<Recipe>>(useMemoized(() => allRecipes));
    final viewingFish = useState<Fish?>(null);

    selectFish(Fish fish) {
      viewingFish.value = fish;
    }

    if (viewingFish.value != null) {
      return FishPage(
        fish: viewingFish.value!,
        recipes: recipes.data?.where((r) => r.requires(viewingFish.value!)).toList() ?? [],
        onBack: () => viewingFish.value = null,
      );
    }

    if (fish.hasError) {
      return Text(fish.error?.toString() ?? 'Error loading fish');
    } else if (recipes.hasError) {
      return Text(recipes.error?.toString() ?? 'Error loading recipes');
    } else if (!fish.hasData || !recipes.hasData) {
      return LinearProgressIndicator();
    } else {
      return FishGrid(fish: fish.data!, onFishSelected: selectFish);
    }
  }
}

class AnimalProductsTab extends StatelessWidget {
  const AnimalProductsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Animal Products tab is under construction!'),
    );
  }
}
