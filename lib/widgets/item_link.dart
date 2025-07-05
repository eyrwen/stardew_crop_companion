import 'package:flutter/material.dart';
import 'package:stardew_crop_companion/data/interface.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ItemLink extends StatelessWidget {
  final Item item;

  const ItemLink({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => launchUrlString(item.url),
      child: Text(item.name, style: Theme.of(context).textTheme.headlineSmall),
    );
  }
}
