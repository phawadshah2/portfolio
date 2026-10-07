import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/theme_context.dart';

enum ActionButtonStyle { primary, secondary, text }

class ActionButton extends StatelessWidget {
  const ActionButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.style = ActionButtonStyle.primary,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final ActionButtonStyle style;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    );
    const padding = EdgeInsets.symmetric(horizontal: 20, vertical: 16);
    final textStyle = context.text.labelLarge;

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
        if (icon != null) ...[const SizedBox(width: 8), Icon(icon, size: 18)],
      ],
    );

    return switch (style) {
      ActionButtonStyle.primary => FilledButton(
        onPressed: onPressed,
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
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: palette.textPrimary,
          side: BorderSide(color: palette.border),
          padding: padding,
          shape: shape,
          textStyle: textStyle,
        ),
        child: content,
      ),
      ActionButtonStyle.text => TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: palette.textSecondary,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          shape: shape,
          textStyle: textStyle,
        ),
        child: content,
      ),
    };
  }
}
