import 'package:flutter/widgets.dart';

/// Tracks pointer hover over [builder]'s output. Touch devices never hover,
/// so effects built on this stay desktop-only for free.
class HoverBuilder extends StatefulWidget {
  const HoverBuilder({
    required this.builder,
    this.cursor = MouseCursor.defer,
    this.child,
    super.key,
  });

  final ValueWidgetBuilder<bool> builder;
  final MouseCursor cursor;

  /// Hover-independent subtree, built once and passed back to [builder].
  final Widget? child;

  @override
  State<HoverBuilder> createState() => _HoverBuilderState();
}

class _HoverBuilderState extends State<HoverBuilder> {
  bool _hovered = false;

  void _set(bool value) {
    if (_hovered != value) setState(() => _hovered = value);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.cursor,
      onEnter: (_) => _set(true),
      onExit: (_) => _set(false),
      child: widget.builder(context, _hovered, widget.child),
    );
  }
}
