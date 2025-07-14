import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stardew_crop_companion/utils/load_json_asset.dart';

import '../data/interface.dart';

AsyncSnapshot<List<T>> useJson<T extends Item>(
  String path,
  T Function(String, Map<String, dynamic>) fromJson,
) {
  return useFuture(
    useMemoized(() async {
      final jsonData = await loadJsonAsset(path);
      return jsonData.entries
          .map<T>((entry) => fromJson(entry.key, entry.value))
          .toList();
    }),
  );
}
