import 'package:flutter/material.dart';
import 'package:portfolio/core/layout/breakpoints.dart';
import 'package:portfolio/core/motion/reveal.dart';
import 'package:portfolio/core/theme/theme_context.dart';

/// Centers content in the readable column and applies the page gutter.
class ContentWidth extends StatelessWidget {
  const ContentWidth({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: Breakpoints.contentMaxWidth,
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: context.gutter),
          child: child,
        ),
      ),
    );
  }
}

/// A titled block of the page: mono eyebrow label, heading, then [child].
class PageSection extends StatelessWidget {
  const PageSection({
    required this.label,
    required this.title,
    required this.child,
    super.key,
  });

  final String label;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final vertical = context.isMobile ? 64.0 : 104.0;
    return ContentWidth(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: vertical),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Reveal(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionLabel(label),
                  const SizedBox(height: 12),
                  Semantics(
                    header: true,
                    child: Text(
                      title,
                      style: context.isMobile
                          ? context.text.headlineMedium
                          : context.text.displayMedium,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: context.isMobile ? 32 : 48),
            child,
          ],
        ),
      ),
    );
  }
}

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: context.text.labelSmall?.copyWith(color: context.palette.accent),
    );
  }
}
