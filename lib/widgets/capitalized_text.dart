import 'package:flutter/material.dart';

class CapitalizedText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const CapitalizedText(this.text, {super.key, this.style});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.replaceFirst(text[0], text[0].toUpperCase()),
      style: style,
    );
  }
}
