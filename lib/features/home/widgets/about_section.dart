import 'package:flutter/material.dart';
import 'package:portfolio/content/models.dart';
import 'package:portfolio/core/layout/breakpoints.dart';
import 'package:portfolio/core/motion/motion.dart';
import 'package:portfolio/core/motion/reveal.dart';
import 'package:portfolio/core/theme/theme_context.dart';
import 'package:portfolio/core/widgets/page_section.dart';
import 'package:portfolio/core/widgets/responsive_grid.dart';
import 'package:portfolio/core/widgets/stat_tile.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({required this.profile, required this.stats, super.key});

  final Profile profile;
  final List<Stat> stats;

  @override
  Widget build(BuildContext context) {
    final paragraphs = Reveal(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final paragraph in profile.about)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                paragraph,
                style: context.text.bodyLarge?.copyWith(
                  color: context.palette.textSecondary,
                ),
              ),
            ),
        ],
      ),
    );

    final statGrid = Reveal(
      delay: Motion.stagger * 2,
      child: ResponsiveGrid(
        mobile: 2,
        tablet: 2,
        desktop: 2,
        spacing: 16,
        children: [for (final stat in stats) StatTile(stat: stat)],
      ),
    );

    return PageSection(
      label: 'About',
      title: 'Production apps, real users, measurable results.',
      child: context.screenSize == ScreenSize.desktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: paragraphs),
                const SizedBox(width: 64),
                Expanded(flex: 2, child: statGrid),
              ],
            )
          : Column(
              children: [paragraphs, const SizedBox(height: 16), statGrid],
            ),
    );
  }
}
