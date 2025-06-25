import 'package:flutter/material.dart';

class Favorites extends StatelessWidget {
  final List favorites;

  const Favorites({super.key, required this.favorites});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            SizedBox(height: 3),
            Image.asset('assets/img/heart.png', height: 16),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: favorites
              .map(
                (fav) => Row(
                  spacing: 4,
                  children: [
                    Image.asset(
                      'assets/img/${fav.toString().toLowerCase()}.png',
                      height: 16,
                    ),
                    Text(
                      fav.replaceFirst(fav[0], fav[0].toUpperCase()),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
