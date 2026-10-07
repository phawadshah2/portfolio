import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/core/layout/breakpoints.dart';
import 'package:portfolio/core/motion/hover_builder.dart';
import 'package:portfolio/core/motion/motion.dart';
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
                  _NavLink(
                    label: section.label,
                    onPressed: () => onSection(section),
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

class _NavLink extends StatelessWidget {
  const _NavLink({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return HoverBuilder(
      builder: (context, hovered, _) => TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: hovered
              ? palette.textPrimary
              : palette.textSecondary,
          overlayColor: Colors.transparent,
          textStyle: context.text.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          minimumSize: const Size(0, 40),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        // The label sizes the Stack; the underline is positioned against it,
        // so it always matches the text width.
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Text(label),
            Positioned(
              left: 0,
              right: 0,
              bottom: -5,
              // Grows from the left. Scaling is paint-only: no layout runs
              // while it animates.
              child: TweenAnimationBuilder<double>(
                tween: Tween(end: hovered ? 1 : 0),
                duration: Motion.hover,
                curve: Motion.enter,
                builder: (context, scale, child) => Transform(
                  alignment: Alignment.centerLeft,
                  transform: Matrix4.diagonal3Values(scale, 1, 1),
                  child: child,
                ),
                child: Container(height: 1.5, color: palette.accent),
              ),
            ),
          ],
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
      child: HoverBuilder(
        cursor: SystemMouseCursors.click,
        builder: (context, hovered, _) => GestureDetector(
          onTap: onTap,
          child: Row(
            children: [
              AnimatedScale(
                scale: hovered ? 1.08 : 1,
                duration: Motion.hover,
                curve: Motion.enter,
                child: Container(
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
      icon: AnimatedSwitcher(
        duration: Motion.page,
        switchInCurve: Motion.enter,
        switchOutCurve: Motion.exit,
        transitionBuilder: (child, animation) => RotationTransition(
          turns: Tween<double>(begin: -0.25, end: 0).animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        ),
        child: Icon(
          isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
          key: ValueKey(isDark),
        ),
      ),
      onPressed: () => context.read<ThemeCubit>().toggle(brightness),
    );
  }
}
