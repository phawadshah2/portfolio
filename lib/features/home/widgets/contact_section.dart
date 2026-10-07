import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portfolio/content/models.dart';
import 'package:portfolio/core/layout/breakpoints.dart';
import 'package:portfolio/core/links.dart';
import 'package:portfolio/core/motion/reveal.dart';
import 'package:portfolio/core/theme/theme_context.dart';
import 'package:portfolio/core/widgets/action_button.dart';
import 'package:portfolio/core/widgets/page_section.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({required this.profile, super.key});

  final Profile profile;

  Future<void> _copyEmail(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: profile.email));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Email copied to clipboard'),
        behavior: SnackBarBehavior.floating,
        width: 320,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final mobile = context.isMobile;
    return ContentWidth(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: mobile ? 64 : 104),
        child: Reveal(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(mobile ? 28 : 64),
            decoration: BoxDecoration(
              color: palette.accentSoft,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: palette.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionLabel('Contact'),
                const SizedBox(height: 12),
                Semantics(
                  header: true,
                  child: Text(
                    'Hiring for a Flutter role? Let’s talk.',
                    style: mobile
                        ? context.text.headlineMedium
                        : context.text.displayMedium,
                  ),
                ),
                const SizedBox(height: 16),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: Text(
                    '${profile.availability}. Based in ${profile.location}. '
                    'Email is the fastest way to reach me.',
                    style: context.text.bodyLarge?.copyWith(
                      color: palette.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ActionButton(
                      label: profile.email,
                      icon: Icons.mail_outline_rounded,
                      onPressed: () => openEmail(profile.email),
                    ),
                    IconButton(
                      tooltip: 'Copy email',
                      color: palette.textSecondary,
                      icon: const Icon(Icons.copy_rounded, size: 20),
                      onPressed: () => _copyEmail(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    ActionButton(
                      label: 'LinkedIn',
                      icon: Icons.north_east_rounded,
                      style: ActionButtonStyle.text,
                      onPressed: () => openExternal(profile.linkedInUrl),
                    ),
                    ActionButton(
                      label: 'GitHub',
                      icon: Icons.north_east_rounded,
                      style: ActionButtonStyle.text,
                      onPressed: () => openExternal(profile.gitHubUrl),
                    ),
                    ActionButton(
                      label: 'Download CV',
                      icon: Icons.download_rounded,
                      style: ActionButtonStyle.text,
                      onPressed: () => openExternal(
                        Uri.base.resolve(profile.cvPath).toString(),
                      ),
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
