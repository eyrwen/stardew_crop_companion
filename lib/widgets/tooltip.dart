import 'package:el_tooltip/el_tooltip.dart';
import 'package:flutter/material.dart' hide Tooltip;
import 'package:flutter_hooks/flutter_hooks.dart';

export 'package:el_tooltip/el_tooltip.dart' show ElTooltipPosition, ElTooltipController;

class Tooltip extends HookWidget {
  final Widget child;
  final Widget content;
  final ElTooltipPosition position;
  final ElTooltipController? controller;

  const Tooltip({
    super.key,
    required this.child,
    required this.content,
    this.position = ElTooltipPosition.topCenter,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final tooltipController = useMemoized(() => controller ?? ElTooltipController());
    final tooltipStatus = useValueListenable(tooltipController);

    return ElTooltip(
      color: const Color(0xFFFFDE91),
      position: position,
      controller: tooltipController,
      showModal: false,
      showChildAboveOverlay: false,
      content: content,
      child: MouseRegion(
        onEnter: (_) {
          if (tooltipStatus != ElTooltipStatus.showing) {
            tooltipController.show();
          }
        },
        onExit: (_) {
          tooltipController.hide();
        },
        child: child,
      ),
    );
  }
}
