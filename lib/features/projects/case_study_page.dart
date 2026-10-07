import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/content/models.dart';
import 'package:portfolio/core/layout/breakpoints.dart';
import 'package:portfolio/core/links.dart';
import 'package:portfolio/core/theme/theme_context.dart';
import 'package:portfolio/core/widgets/action_button.dart';
import 'package:portfolio/core/widgets/page_section.dart';
import 'package:portfolio/core/widgets/responsive_grid.dart';
import 'package:portfolio/core/widgets/site_scaffold.dart';
import 'package:portfolio/core/widgets/stat_tile.dart';
import 'package:portfolio/core/widgets/tag.dart';
import 'package:portfolio/features/projects/widgets/architecture_diagram.dart';
import 'package:portfolio/features/projects/widgets/decision_card.dart';

class CaseStudyPage extends StatelessWidget {
  const CaseStudyPage({required this.project, super.key});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final study = project.caseStudy;
    final mobile = context.isMobile;
    final gap = SizedBox(height: mobile ? 56 : 88);

    return SiteScaffold(
      children: [
        _Header(project: project),
        ContentWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ResponsiveGrid(
                mobile: 2,
                tablet: 4,
                desktop: 4,
                spacing: 16,
                children: [for (final m in study.metrics) StatTile(stat: m)],
              ),
              gap,
              _Chapter(
                number: '01',
                title: 'The problem',
                child: _Prose(study.problem),
              ),
              gap,
              _Chapter(
                number: '02',
                title: 'Constraints',
                child: _Bullets(study.constraints),
              ),
              gap,
              _Chapter(
                number: '03',
                title: 'Architecture',
                intro:
                    'Dependencies point inward. Presentation and data both '
                    'depend on the domain, and the domain depends on nothing. '
                    'The data layer implements the repository interface the '
                    'domain defines.',
                wide: true,
                child: ArchitectureDiagram(layers: study.layers),
              ),
              gap,
              _Chapter(
                number: '04',
                title: 'Key decisions',
                intro:
                    'Each one written as a lightweight ADR: the choice, '
                    'why I made it, and what it costs.',
                wide: true,
                child: ResponsiveGrid(
                  desktop: 2,
                  children: [
                    for (final d in study.decisions) DecisionCard(decision: d),
                  ],
                ),
              ),
              gap,
              _Chapter(
                number: '05',
                title: 'Quality & delivery',
                child: _Bullets(study.quality, icon: Icons.check_rounded),
              ),
              gap,
              _Chapter(
                number: '06',
                title: 'What I would do differently',
                child: _Bullets(study.retrospective),
              ),
              gap,
              _Chapter(
                number: '07',
                title: 'What is next',
                child: _Bullets(study.next, icon: Icons.east_rounded),
              ),
              SizedBox(height: mobile ? 64 : 104),
            ],
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final mobile = context.isMobile;
    return ContentWidth(
      child: Padding(
        padding: EdgeInsets.only(top: mobile ? 32 : 56, bottom: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ActionButton(
              label: '← All work',
              style: ActionButtonStyle.text,
              onPressed: () => context.go('/?section=work'),
            ),
            SizedBox(height: mobile ? 24 : 40),
            const SectionLabel('Case study'),
            const SizedBox(height: 12),
            Semantics(
              header: true,
              child: Text(
                project.name,
                style: mobile
                    ? context.text.displayMedium
                    : context.text.displayLarge,
              ),
            ),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(project.tagline, style: context.text.titleLarge),
                  const SizedBox(height: 16),
                  Text(
                    project.summary,
                    style: context.text.bodyLarge?.copyWith(
                      color: palette.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TagWrap(project.tags),
            const SizedBox(height: 32),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                if (project.demoUrl case final demo?)
                  ActionButton(
                    label: 'Live demo',
                    icon: Icons.play_arrow_rounded,
                    onPressed: () => openExternal(demo),
                  ),
                ActionButton(
                  label: 'Source on GitHub',
                  icon: Icons.north_east_rounded,
                  style: project.demoUrl == null
                      ? ActionButtonStyle.primary
                      : ActionButtonStyle.secondary,
                  onPressed: () => openExternal(project.repoUrl),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Chapter extends StatelessWidget {
  const _Chapter({
    required this.number,
    required this.title,
    required this.child,
    this.intro,
    this.wide = false,
  });

  final String number;
  final String title;
  final String? intro;
  final Widget child;

  /// Wide chapters use the full content width; prose stays at reading width.
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          number,
          style: context.text.labelSmall?.copyWith(color: palette.accent),
        ),
        const SizedBox(height: 8),
        Semantics(
          header: true,
          child: Text(title, style: context.text.headlineMedium),
        ),
        if (intro case final intro?) ...[
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Text(
              intro,
              style: context.text.bodyLarge?.copyWith(
                color: palette.textSecondary,
              ),
            ),
          ),
        ],
        const SizedBox(height: 28),
        if (wide)
          child
        else
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: child,
          ),
      ],
    );
  }
}

class _Prose extends StatelessWidget {
  const _Prose(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: context.text.bodyLarge?.copyWith(
        color: context.palette.textSecondary,
      ),
    );
  }
}

class _Bullets extends StatelessWidget {
  const _Bullets(this.items, {this.icon});

  final List<String> items;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 28,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: icon == null
                        ? Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: 8,
                                height: 1.5,
                                color: palette.textMuted,
                              ),
                            ),
                          )
                        : Icon(icon, size: 18, color: palette.accent),
                  ),
                ),
                Expanded(
                  child: Text(
                    item,
                    style: context.text.bodyLarge?.copyWith(
                      color: palette.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
