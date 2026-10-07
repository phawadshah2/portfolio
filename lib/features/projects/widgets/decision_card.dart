import 'package:flutter/material.dart';
import 'package:portfolio/content/models.dart';
import 'package:portfolio/core/theme/theme_context.dart';
import 'package:portfolio/core/widgets/surface_card.dart';

class DecisionCard extends StatelessWidget {
  const DecisionCard({required this.decision, super.key});

  final Decision decision;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            decision.title.toUpperCase(),
            style: context.text.labelSmall?.copyWith(color: palette.textMuted),
          ),
          const SizedBox(height: 10),
          Text(decision.choice, style: context.text.titleLarge),
          const SizedBox(height: 20),
          _Labelled(label: 'Why', text: decision.why, color: palette.accent),
          const SizedBox(height: 16),
          _Labelled(
            label: 'Tradeoff',
            text: decision.tradeoff,
            color: palette.textMuted,
          ),
        ],
      ),
    );
  }
}

class _Labelled extends StatelessWidget {
  const _Labelled({
    required this.label,
    required this.text,
    required this.color,
  });

  final String label;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.text.labelMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          text,
          style: context.text.bodyMedium?.copyWith(
            color: context.palette.textSecondary,
          ),
        ),
      ],
    );
  }
}
