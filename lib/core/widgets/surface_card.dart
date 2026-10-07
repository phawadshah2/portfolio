import 'package:flutter/material.dart';
import 'package:portfolio/core/motion/hover_builder.dart';
import 'package:portfolio/core/motion/motion.dart';
import 'package:portfolio/core/theme/theme_context.dart';

/// Bordered card.
///
/// On hover every card tints its border. When [onTap] is set it also lifts,
/// shows a pointer cursor, and is announced as a button to screen readers.
class SurfaceCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final palette = context.palette;
    final interactive = onTap != null;

    final card = HoverBuilder(
      cursor: interactive ? SystemMouseCursors.click : MouseCursor.defer,
      // The content gets its own layer, so hover frames repaint only the
      // border and background, never the text inside.
      child: Padding(
        padding: padding,
        child: RepaintBoundary(child: child),
      ),
      builder: (context, hovered, content) => TweenAnimationBuilder<double>(
        // A fixed 4px lift, whatever the card's height.
        tween: Tween(end: interactive && hovered ? -4 : 0),
        duration: Motion.hover,
        curve: Motion.enter,
        builder: (context, dy, child) =>
            Transform.translate(offset: Offset(0, dy), child: child),
        child: AnimatedContainer(
          duration: Motion.hover,
          curve: Motion.enter,
          decoration: BoxDecoration(
            color: palette.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: switch ((hovered, interactive)) {
                (true, true) => palette.accent,
                (true, false) => palette.textMuted.withValues(alpha: 0.5),
                _ => palette.border,
              },
            ),
          ),
          child: content,
        ),
      ),
    );

    if (!interactive) return card;

    final tappable = GestureDetector(
      onTap: onTap,
      // Without a label the tap is a mouse shortcut for a button inside the
      // card, so assistive tech should not see a second, nameless button.
      excludeFromSemantics: semanticLabel == null,
      child: card,
    );
    if (semanticLabel == null) return tappable;
    return Semantics(button: true, label: semanticLabel, child: tappable);
  }
}
