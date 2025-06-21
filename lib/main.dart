import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:url_launcher/url_launcher_string.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends HookWidget {
  const MyHomePage({super.key});

  _loadCrops() async {
    return json.decode(await rootBundle.loadString('assets/crops.json'));
  }

  _loadSeasons() async {
    return json.decode(await rootBundle.loadString('assets/seasons.json'));
  }

  @override
  Widget build(BuildContext context) {
    final seasons = useFuture(_loadSeasons());
    final crops = useFuture(_loadCrops());
    final cropList = crops.data != null
        ? (crops.data as Map).values.toList()
        : [];
    cropList.sort((crop1, crop2) {
      return crop1['name'].compareTo(crop2['name']);
    });
    final viewingCrop = useState<Map?>(null);

    return Scaffold(
      body: Container(
        color: Colors.lightBlue,
        padding: const EdgeInsets.all(8.0),
        child: viewingCrop.value == null
            ? GridView.extent(
                maxCrossAxisExtent: 200,
                children: crops.data != null
                    ? cropList.map((crop) {
                        return Card(
                          child: InkWell(
                            onTap: () => viewingCrop.value = crop,
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset('assets/img/${crop['img']}'),
                                  Text(
                                    crop['name'],
                                    overflow: TextOverflow.clip,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList()
                    : [
                        crops.hasError
                            ? Text((crops.error as FlutterError).message)
                            : const Center(child: CircularProgressIndicator()),
                      ],
              )
            : Row(
                spacing: 16.0,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            "assets/img/${viewingCrop.value!['img']}",
                          ),

                          InkWell(
                            onTap: () =>
                                launchUrlString(viewingCrop.value!['url']),
                            child: Text(
                              viewingCrop.value!['name'],
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ),
                          ...viewingCrop.value!['seasons'].map<Widget>((
                            season,
                          ) {
                            final seasonData = seasons.data![season];
                            return Row(
                              spacing: 8.0,
                              children: [
                                Image.asset(
                                  'assets/img/${seasonData['img']}',
                                  height: 24.0,
                                ),
                                Text(
                                  season.replaceFirst(
                                    season[0],
                                    season[0].toUpperCase(),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                      l,
                    ),
                  ),
                  Card(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
