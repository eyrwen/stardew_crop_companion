import 'package:flutter/material.dart';

import '../data/crop.dart';
import 'crop_general_details.dart';
import 'crop_produce_values.dart';
import 'crop_raw_values.dart';

class CropPage extends StatelessWidget {
  final Crop crop;
  final VoidCallback onBack;

  const CropPage({super.key, required this.crop, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        spacing: 16.0,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(icon: Icon(Icons.arrow_back), onPressed: () => onBack()),
          CropGeneralDetails(crop: crop),
          Column(
            spacing: 16.0,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CropRawValues(crop: crop),
              crop.type == CropType.other
                  ? SizedBox.shrink()
                  : CropProduceValues(crop: crop),
            ],
          ),
        ],
      ),
    );
  }
}
