import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DetailsCard extends HookWidget {
  final bool scrollable;
  final Widget child;

  const DetailsCard({super.key, this.scrollable = false, required this.child});

  const DetailsCard.scrollable({super.key, required this.child})
    : scrollable = true;

  @override
  Widget build(BuildContext context) {
    final scroller = useScrollController();

    return Card(
      child: scrollable
          ? Scrollbar(
              controller: scroller,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: scroller,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: child,
                ),
              ),
            )
          : Padding(padding: const EdgeInsets.all(16.0), child: child),
    );
  }
}
