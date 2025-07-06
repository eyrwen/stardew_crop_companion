import 'package:flutter/material.dart';

class CapitalizedText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const CapitalizedText(this.text, {super.key, this.style});

  @override
  Widget build(BuildContext context) {
    return Text(
      text
          .split(" ")
          .map((word) => word.replaceFirst(word[0], word[0].toUpperCase()))
          .join(" "),
      style: style,
    );
  }
}
