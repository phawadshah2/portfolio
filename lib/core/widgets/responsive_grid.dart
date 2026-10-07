import 'package:flutter/material.dart';
import 'package:portfolio/core/layout/breakpoints.dart';

/// Lays children out in equal-width columns; the column count depends on the
/// *available* width, not the screen, so it also works inside nested layouts.
class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    required this.children,
    this.mobile = 1,
    this.tablet = 2,
    this.desktop = 3,
    this.spacing = 20,
    super.key,
  });

  final List<Widget> children;
  final int mobile;
  final int tablet;
  final int desktop;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        // Content is inset by the gutter, so compare against the screen size.
        final columns = switch (context.screenSize) {
          ScreenSize.mobile => mobile,
          ScreenSize.tablet => tablet,
          ScreenSize.desktop => desktop,
        };
        final itemWidth = (width - spacing * (columns - 1)) / columns;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final child in children)
              SizedBox(width: itemWidth, child: child),
          ],
        );
      },
    );
  }
}
