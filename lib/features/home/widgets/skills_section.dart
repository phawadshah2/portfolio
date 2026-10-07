import 'package:flutter/material.dart';
import 'package:portfolio/content/models.dart';
import 'package:portfolio/core/theme/theme_context.dart';
import 'package:portfolio/core/widgets/page_section.dart';
import 'package:portfolio/core/widgets/responsive_grid.dart';
import 'package:portfolio/core/widgets/surface_card.dart';
import 'package:portfolio/core/widgets/tag.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({required this.groups, super.key});

  final List<SkillGroup> groups;

  @override
  Widget build(BuildContext context) {
    return PageSection(
      label: 'Skills',
      title: 'The toolbox',
      child: ResponsiveGrid(
        children: [
          for (final group in groups)
            SurfaceCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group.title,
                    style: context.text.titleMedium?.copyWith(
                      color: context.palette.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TagWrap(group.skills),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
