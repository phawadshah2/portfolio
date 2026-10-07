import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/core/layout/breakpoints.dart';
import 'package:portfolio/core/theme/theme_context.dart';
import 'package:portfolio/core/theme/theme_cubit.dart';
import 'package:portfolio/core/widgets/page_section.dart';

/// Sections of the home page reachable from the nav.
enum HomeSection {
  work('Work'),
  experience('Experience'),
  skills('Skills'),
  contact('Contact');

  HomeSection(this.label);

  final String label;
}

class SiteNav extends StatelessWidget {
  const SiteNav({
    required this.name,
    required this.onHome,
    required this.onSection,
    super.key,
  });

  final String name;
  final VoidCallback onHome;
  final ValueChanged<HomeSection> onSection;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.background.withValues(alpha: 0.92),
        border: Border(bottom: BorderSide(color: palette.border)),
      ),
      child: ContentWidth(
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              _Logo(name: name, onTap: onHome),
              const Spacer(),
              if (context.isMobile)
                _MobileMenu(onSection: onSection)
              else
                for (final section in HomeSection.values)
                  TextButton(
                    onPressed: () => onSection(section),
                    style: TextButton.styleFrom(
                      foregroundColor: palette.textSecondary,
                      textStyle: context.text.labelLarge,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                    ),
                    child: Text(section.label),
                  ),
              const SizedBox(width: 4),
              const ThemeToggle(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({required this.name, required this.onTap});

  final String name;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Semantics(
      link: true,
      label: '$name, home',
      excludeSemantics: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: palette.accent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'FS',
                  style: context.text.labelLarge?.copyWith(
                    color: palette.background,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(name, style: context.text.titleMedium),
            ],
          ),
        ),
      ),
    );
  }
}

class _MobileMenu extends StatelessWidget {
  const _MobileMenu({required this.onSection});

  final ValueChanged<HomeSection> onSection;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<HomeSection>(
      tooltip: 'Menu',
      icon: const Icon(Icons.menu_rounded),
      color: context.palette.surface,
      onSelected: onSection,
      itemBuilder: (context) => [
        for (final section in HomeSection.values)
          PopupMenuItem(value: section, child: Text(section.label)),
      ],
    );
  }
}

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    return IconButton(
      tooltip: isDark ? 'Switch to light theme' : 'Switch to dark theme',
      color: context.palette.textSecondary,
      icon: Icon(isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
      onPressed: () => context.read<ThemeCubit>().toggle(brightness),
    );
  }
}
