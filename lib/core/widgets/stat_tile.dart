import 'package:flutter/material.dart';
import 'package:portfolio/content/models.dart';
import 'package:portfolio/core/theme/theme_context.dart';
import 'package:portfolio/core/widgets/surface_card.dart';

class StatTile extends StatelessWidget {
  const StatTile({required this.stat, super.key});

  final Stat stat;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stat.value,
            style: context.text.headlineMedium?.copyWith(
              color: context.palette.accent,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            stat.label,
            maxLines: 2,
            style: context.text.bodySmall?.copyWith(
              color: context.palette.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
