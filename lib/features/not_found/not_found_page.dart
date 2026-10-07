import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/theme/theme_context.dart';
import 'package:portfolio/core/widgets/action_button.dart';
import 'package:portfolio/core/widgets/page_section.dart';
import 'package:portfolio/core/widgets/site_scaffold.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SiteScaffold(
      children: [
        ContentWidth(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionLabel('404'),
                const SizedBox(height: 12),
                Text(
                  'This page does not exist.',
                  style: context.text.displayMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  'The link may be old, or the URL has a typo.',
                  style: context.text.bodyLarge?.copyWith(
                    color: context.palette.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),
                ActionButton(
                  label: 'Back to home',
                  icon: Icons.arrow_forward_rounded,
                  onPressed: () => context.go('/'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
