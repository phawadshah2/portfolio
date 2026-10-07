import 'package:flutter/material.dart';
import 'package:portfolio/core/motion/motion.dart';
import 'package:portfolio/core/theme/theme_context.dart';

enum ActionButtonStyle { primary, secondary, text }

class ActionButton extends StatefulWidget {
  const ActionButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.leadingIcon = false,
    this.style = ActionButtonStyle.primary,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  /// Puts [icon] before the label (e.g. a back arrow).
  final bool leadingIcon;
  final ActionButtonStyle style;

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  bool _hovered = false;

  /// On hover the icon nudges the way it points, hinting where the click
  /// goes. Icons without a direction stay put.
  static Offset _nudgeFor(IconData? icon) => switch (icon) {
    Icons.arrow_forward_rounded ||
    Icons.play_arrow_rounded => const Offset(3, 0),
    Icons.arrow_back_rounded => const Offset(-3, 0),
    Icons.north_east_rounded => const Offset(2, -2),
    Icons.download_rounded => const Offset(0, 2),
    Icons.mail_outline_rounded => const Offset(0, -2),
    _ => Offset.zero,
  };

  void _onHover(bool hovered) {
    if (_hovered != hovered) setState(() => _hovered = hovered);
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    );
    const padding = EdgeInsets.symmetric(horizontal: 20, vertical: 16);
    final textStyle = context.text.labelLarge;

    final label = Flexible(
      child: Text(widget.label, overflow: TextOverflow.ellipsis),
    );
    final icon = widget.icon == null
        ? null
        : TweenAnimationBuilder<Offset>(
            tween: Tween(end: _hovered ? _nudgeFor(widget.icon) : Offset.zero),
            duration: Motion.hover,
            curve: Motion.enter,
            builder: (context, offset, child) =>
                Transform.translate(offset: offset, child: child),
            child: Icon(widget.icon, size: 18),
          );

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null && widget.leadingIcon) ...[
          icon,
          const SizedBox(width: 8),
        ],
        label,
        if (icon != null && !widget.leadingIcon) ...[
          const SizedBox(width: 8),
          icon,
        ],
      ],
    );

    return switch (widget.style) {
      ActionButtonStyle.primary => FilledButton(
        onPressed: widget.onPressed,
        onHover: _onHover,
        style: FilledButton.styleFrom(
          backgroundColor: palette.accent,
          foregroundColor: palette.background,
          padding: padding,
          shape: shape,
          textStyle: textStyle,
        ),
        child: content,
      ),
      ActionButtonStyle.secondary => OutlinedButton(
        onPressed: widget.onPressed,
        onHover: _onHover,
        style: OutlinedButton.styleFrom(
          foregroundColor: palette.textPrimary,
          side: BorderSide(
            color: _hovered ? palette.textMuted : palette.border,
          ),
          padding: padding,
          shape: shape,
          textStyle: textStyle,
        ),
        child: content,
      ),
      ActionButtonStyle.text => TextButton(
        onPressed: widget.onPressed,
        onHover: _onHover,
        style: TextButton.styleFrom(
          foregroundColor: _hovered
              ? palette.textPrimary
              : palette.textSecondary,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          shape: shape,
          textStyle: textStyle,
        ),
        child: content,
      ),
    };
  }
}
