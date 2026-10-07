import 'package:flutter/material.dart';
import 'package:portfolio/content/models.dart';
import 'package:portfolio/core/layout/breakpoints.dart';
import 'package:portfolio/core/motion/reveal.dart';
import 'package:portfolio/core/theme/theme_context.dart';
import 'package:portfolio/core/widgets/page_section.dart';
import 'package:portfolio/core/widgets/tag.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({required this.experience, super.key});

  final List<Experience> experience;

  @override
  Widget build(BuildContext context) {
    return PageSection(
      label: 'Experience',
      title: 'Where I have shipped',
      child: Column(
        children: [
          for (final (index, item) in experience.indexed)
            Reveal(
              child: _ExperienceEntry(
                item: item,
                isLast: index == experience.length - 1,
              ),
            ),
        ],
      ),
    );
  }
}

class _ExperienceEntry extends StatelessWidget {
  const _ExperienceEntry({required this.item, required this.isLast});

  final Experience item;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final wide = !context.isMobile;

    final period = Text(
      item.period.toUpperCase(),
      style: context.text.labelSmall?.copyWith(color: palette.textMuted),
    );

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!wide) ...[period, const SizedBox(height: 8)],
        Text(item.role, style: context.text.titleLarge),
        const SizedBox(height: 4),
        Text(
          '${item.company} · ${item.location}',
          style: context.text.bodyMedium?.copyWith(color: palette.accent),
        ),
        const SizedBox(height: 16),
        for (final highlight in item.highlights)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 11, right: 12),
                  child: Container(
                    width: 6,
                    height: 1.5,
                    color: palette.textMuted,
                  ),
                ),
                Expanded(
                  child: Text(
                    highlight,
                    style: context.text.bodyMedium?.copyWith(
                      color: palette.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 8),
        TagWrap(item.stack),
      ],
    );

    return Container(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 40),
      margin: EdgeInsets.only(bottom: isLast ? 0 : 40),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: palette.border)),
      ),
      child: wide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 220,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: period,
                  ),
                ),
                Expanded(child: body),
              ],
            )
          : body,
    );
  }
}
