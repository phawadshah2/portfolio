import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/theme_context.dart';

/// Bordered card. When [onTap] is set it gets a hover lift and a pointer
/// cursor, and is announced as a button to screen readers.
class SurfaceCard extends StatefulWidget {
  const SurfaceCard({
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(28),
    this.semanticLabel,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final String? semanticLabel;

  @override
  State<SurfaceCard> createState() => _SurfaceCardState();
}

class _SurfaceCardState extends State<SurfaceCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final interactive = widget.onTap != null;
    final highlighted = interactive && _hovered;

    final card = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      transform: Matrix4.translationValues(0, highlighted ? -3 : 0, 0),
      padding: widget.padding,
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: highlighted ? palette.accent : palette.border,
        ),
      ),
      child: widget.child,
    );

    if (!interactive) return card;

    return Semantics(
      button: true,
      label: widget.semanticLabel,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(onTap: widget.onTap, child: card),
      ),
    );
  }
}
