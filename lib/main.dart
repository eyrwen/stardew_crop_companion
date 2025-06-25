import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'data/crop.dart';
import 'data/recipe.dart';
import 'widgets/crop_grid.dart';
import 'widgets/crop_page.dart';

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
        .map<Crop>(
          (entry) => Crop(
            key: entry.key,
            name: entry.value['name'],
            img: entry.value['img'],
            type: CropType.from(entry.value['type']),
            price: entry.value['price'],
            energy: entry.value['energy'],
            health: entry.value['health'],
            url: entry.value['url'],
            specialProduce: entry.value['specialProduce'],
            hasQuality: entry.value['hasQuality'] ?? true,
            favorites: entry.value['favorite']?.cast<String>() ?? [],
          ),
        )
        .toList();
  }

  Future<List<Recipe>> _loadRecipes() async {
    final recipeJson = await json.decode(
      await rootBundle.loadString('assets/recipes.json'),
    );
    return recipeJson.entries
        .map<Recipe>((entry) => Recipe.fromJson(entry.value))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(text: 'Crops', icon: Image.asset('assets/img/farming.png')),
            Tab(text: 'Fish', icon: Image.asset('assets/img/fishing.png')),
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
              FishTab(),
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
      crop.recipes =
          recipes.data?.where((recipe) => recipe.requires(crop)).toList() ?? [];
      viewingCrop.value = crop;
    }

    if (viewingCrop.value != null) {
      return CropPage(
        crop: viewingCrop.value!,
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

class FishTab extends StatelessWidget {
  const FishTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink();
  }
}
