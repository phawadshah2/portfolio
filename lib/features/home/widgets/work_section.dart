import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/content/models.dart';
import 'package:portfolio/core/layout/breakpoints.dart';
import 'package:portfolio/core/links.dart';
import 'package:portfolio/core/theme/theme_context.dart';
import 'package:portfolio/core/widgets/action_button.dart';
import 'package:portfolio/core/widgets/page_section.dart';
import 'package:portfolio/core/widgets/surface_card.dart';
import 'package:portfolio/core/widgets/tag.dart';

class WorkSection extends StatelessWidget {
  const WorkSection({required this.projects, super.key});

  final List<Project> projects;

  @override
  Widget build(BuildContext context) {
    return PageSection(
      label: 'Selected work',
      title: 'Case studies',
      child: Column(
        children: [
          for (final project in projects)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ProjectCard(project: project),
            ),
        ],
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
  const ProjectCard({required this.project, super.key});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final metrics = project.caseStudy.metrics;
    final mobile = context.isMobile;

    final details = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel('Case study'),
        const SizedBox(height: 12),
        Text(project.name, style: context.text.headlineMedium),
        const SizedBox(height: 8),
        Text(project.tagline, style: context.text.titleMedium),
        const SizedBox(height: 16),
        Text(
          project.summary,
          style: context.text.bodyMedium?.copyWith(
            color: palette.textSecondary,
          ),
        ),
        const SizedBox(height: 20),
        TagWrap(project.tags),
        const SizedBox(height: 28),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ActionButton(
              label: 'Read the case study',
              icon: Icons.arrow_forward_rounded,
              onPressed: () => context.go(project.path),
            ),
            if (project.demoUrl case final demo?)
              ActionButton(
                label: 'Live demo',
                icon: Icons.play_arrow_rounded,
                style: ActionButtonStyle.secondary,
                onPressed: () => openExternal(demo),
              ),
            ActionButton(
              label: 'Source code',
              icon: Icons.north_east_rounded,
              style: ActionButtonStyle.secondary,
              onPressed: () => openExternal(project.repoUrl),
            ),
          ],
        ),
      ],
    );

    final metricList = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final metric in metrics)
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                SizedBox(
                  width: 64,
                  child: Text(
                    metric.value,
                    style: context.text.headlineMedium?.copyWith(
                      color: palette.accent,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    metric.label,
                    style: context.text.bodyMedium?.copyWith(
                      color: palette.textMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );

    return SurfaceCard(
      padding: EdgeInsets.all(mobile ? 24 : 40),
      child: context.screenSize == ScreenSize.desktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: details),
                const SizedBox(width: 48),
                Container(width: 1, height: 260, color: palette.border),
                const SizedBox(width: 48),
                Expanded(flex: 2, child: metricList),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [details, const SizedBox(height: 32), metricList],
            ),
    );
  }
}
