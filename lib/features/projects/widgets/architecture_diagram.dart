import 'package:flutter/material.dart';
import 'package:portfolio/content/models.dart';
import 'package:portfolio/core/layout/breakpoints.dart';
import 'package:portfolio/core/motion/motion.dart';
import 'package:portfolio/core/motion/reveal.dart';
import 'package:portfolio/core/theme/theme_context.dart';

/// Layered architecture with the dependency direction drawn explicitly.
///
/// Expects layers ordered presentation, domain, data. Arrows point from the
/// depending layer to the layer it depends on, so both outer layers point at
/// the domain in the middle.
class ArchitectureDiagram extends StatelessWidget {
  const ArchitectureDiagram({required this.layers, super.key});

  final List<ArchitectureLayer> layers;

  @override
  Widget build(BuildContext context) {
    assert(layers.length == 3, 'Diagram is drawn for exactly three layers');
    final horizontal = context.screenSize == ScreenSize.desktop;

    final boxes = [
      for (final (i, layer) in layers.indexed)
        Reveal(
          // Domain last: the eye lands on the layer everything points at.
          delay: Motion.staggerAt(const [0, 2, 1][i] * 2),
          child: _LayerBox(layer: layer, emphasised: i == 1),
        ),
    ];

    if (horizontal) {
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: boxes[0]),
            const _Arrow(direction: AxisDirection.right),
            Expanded(child: boxes[1]),
            const _Arrow(direction: AxisDirection.left),
            Expanded(child: boxes[2]),
          ],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        boxes[0],
        const _Arrow(direction: AxisDirection.down),
        boxes[1],
        const _Arrow(direction: AxisDirection.up),
        boxes[2],
      ],
    );
  }
}

class _LayerBox extends StatelessWidget {
  const _LayerBox({required this.layer, required this.emphasised});

  final ArchitectureLayer layer;
  final bool emphasised;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: emphasised ? palette.accentSoft : palette.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: emphasised ? palette.accent : palette.border,
          width: emphasised ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(layer.name, style: context.text.titleLarge),
          const SizedBox(height: 8),
          Text(
            layer.responsibility,
            style: context.text.bodySmall?.copyWith(
              color: palette.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          for (final part in layer.parts)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                part,
                style: context.text.labelSmall?.copyWith(
                  color: palette.textMuted,
                  letterSpacing: 0,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Arrow extends StatelessWidget {
  const _Arrow({required this.direction});

  final AxisDirection direction;

  @override
  Widget build(BuildContext context) {
    final icon = switch (direction) {
      AxisDirection.right => Icons.arrow_forward_rounded,
      AxisDirection.left => Icons.arrow_back_rounded,
      AxisDirection.down => Icons.arrow_downward_rounded,
      AxisDirection.up => Icons.arrow_upward_rounded,
    };
    return Semantics(
      label: 'depends on',
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Center(
          child: Icon(icon, color: context.palette.accent, size: 22),
        ),
      ),
    );
  }
}
