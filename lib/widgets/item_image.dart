import 'package:flutter/material.dart';

class ItemImage extends StatelessWidget {
  final String? imageName;
  final double? height;
  final String? overlay;
  final double? overlayScale;
  final double? imgScale;

  const ItemImage(
    this.imageName, {
    super.key,
    this.height,
    this.overlay,
    this.overlayScale = 1.25,
    this.imgScale,
  });

  const ItemImage.small(
    this.imageName, {
    super.key,
    this.overlay,
    this.overlayScale,
    this.imgScale,
  }) : height = 16;

  const ItemImage.medium(
    this.imageName, {
    super.key,
    this.overlay,
    this.overlayScale,
    this.imgScale,
  }) : height = 24;

  const ItemImage.large(
    this.imageName, {
    super.key,
    this.overlay,
    this.overlayScale,
    this.imgScale,
  }) : height = 32;

  const ItemImage.xlarge(
    this.imageName, {
    super.key,
    this.overlay,
    this.overlayScale,
    this.imgScale,
  }) : height = 96;

  get fullImageName =>
      imageName!.contains('.png') ? imageName! : '$imageName.png';

  get fullOverlayImageName =>
      overlay != null && overlay!.contains('.png') ? overlay! : '$overlay.png';

  get semanticLabel => imageName!.replaceAll('.png', '').replaceAll('_', ' ');

  @override
  Widget build(BuildContext context) {
    if (imageName == null || imageName!.isEmpty) {
      return SizedBox(height: height);
    }

    if (overlay != null) {
      return Stack(
        alignment: Alignment.centerLeft,
        children: [
          Image.asset(
            'assets/img/$fullImageName',
            height: height,
            semanticLabel: semanticLabel,
          ),
          Image.asset('assets/img/${overlay!}', scale: overlayScale),
        ],
      );
    }

    return Image.asset(
      'assets/img/$fullImageName',
      height: height,
      semanticLabel: semanticLabel,
      filterQuality: FilterQuality.none,
      scale: imgScale ?? 1.0,
    );
  }
}
