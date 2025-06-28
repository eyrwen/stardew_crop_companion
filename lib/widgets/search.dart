import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  final TextEditingController controller;

  const Search({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 0.5),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }
}

class SearchFilter<T> extends StatelessWidget {
  final List<ButtonSegment<T?>> children;
  final T? selected;
  final void Function(T?) onSelected;

  const SearchFilter({
    super.key,
    required this.children,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<T?>(
      emptySelectionAllowed: true,
      showSelectedIcon: false,
      segments: children,
      selected: {selected},
      onSelectionChanged: (Set<T?> newSelection) {
        onSelected(newSelection.firstOrNull);
      },
    );
  }
}
