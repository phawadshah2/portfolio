import 'package:flutter/material.dart';
import 'package:portfolio/core/layout/breakpoints.dart';

/// Lays children out in rows of equal-width columns. The column count
/// follows the screen size.
///
/// Deliberately built from Rows instead of a LayoutBuilder: any rebuild
/// inside a LayoutBuilder (a hover or reveal animation tick) forces the
/// builder to lay out again, and with no relayout boundary above it that
/// means the whole page, every frame.
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
    final columns = switch (context.screenSize) {
      ScreenSize.mobile => mobile,
      ScreenSize.tablet => tablet,
      ScreenSize.desktop => desktop,
    };

    final rows = <Widget>[];
    for (var start = 0; start < children.length; start += columns) {
      if (rows.isNotEmpty) rows.add(SizedBox(height: spacing));
      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var column = 0; column < columns; column++) ...[
              if (column > 0) SizedBox(width: spacing),
              Expanded(
                // Empty cells keep a short last row aligned to the grid.
                child: start + column < children.length
                    ? children[start + column]
                    : const SizedBox.shrink(),
              ),
            ],
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: rows,
    );
  }
}
