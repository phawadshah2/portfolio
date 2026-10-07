import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/theme_context.dart';

class Tag extends StatelessWidget {
  const Tag(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.surfaceRaised,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: palette.border),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(
          label,
          style: context.text.labelMedium?.copyWith(
            color: palette.textSecondary,
          ),
        ),
      ),
    );
  }
}

class TagWrap extends StatelessWidget {
  const TagWrap(this.labels, {super.key});

  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [for (final label in labels) Tag(label)],
    );
  }
}
