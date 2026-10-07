import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/content/models.dart';
import 'package:portfolio/core/layout/breakpoints.dart';
import 'package:portfolio/core/links.dart';
import 'package:portfolio/core/theme/theme_context.dart';
import 'package:portfolio/core/widgets/action_button.dart';
import 'package:portfolio/core/widgets/page_section.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({
    required this.profile,
    required this.featured,
    required this.onContact,
    super.key,
  });

  final Profile profile;
  final Project featured;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final mobile = context.isMobile;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0.9, -1),
          radius: 1.1,
          // Fade to transparent so the hero blends into the page, no seam.
          colors: [palette.accentSoft, palette.accentSoft.withValues(alpha: 0)],
        ),
      ),
      child: ContentWidth(
        child: Padding(
          padding: EdgeInsets.only(
            top: mobile ? 56 : 120,
            bottom: mobile ? 56 : 104,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 820),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _AvailabilityBadge(
                  text: '${profile.availability} · ${profile.location}',
                ),
                const SizedBox(height: 28),
                SectionLabel('${profile.name} — ${profile.role}'),
                const SizedBox(height: 16),
                Semantics(
                  header: true,
                  child: Text(
                    profile.headline,
                    style: mobile
                        ? context.text.displayMedium
                        : context.text.displayLarge,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  profile.intro,
                  style: context.text.bodyLarge?.copyWith(
                    color: palette.textSecondary,
                  ),
                ),
                const SizedBox(height: 40),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    ActionButton(
                      label: 'Read the case study',
                      icon: Icons.arrow_forward_rounded,
                      onPressed: () => context.go(featured.path),
                    ),
                    ActionButton(
                      label: 'Download CV',
                      icon: Icons.download_rounded,
                      style: ActionButtonStyle.secondary,
                      onPressed: () => openExternal(
                        Uri.base.resolve(profile.cvPath).toString(),
                      ),
                    ),
                    ActionButton(
                      label: 'Get in touch',
                      style: ActionButtonStyle.text,
                      onPressed: onContact,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AvailabilityBadge extends StatelessWidget {
  const _AvailabilityBadge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: palette.border),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: palette.success,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                text,
                style: context.text.labelMedium?.copyWith(
                  color: palette.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
