import 'package:flutter/material.dart';
import 'package:portfolio/content/portfolio_content.dart';
import 'package:portfolio/core/widgets/site_nav.dart';
import 'package:portfolio/core/widgets/site_scaffold.dart';
import 'package:portfolio/features/home/widgets/about_section.dart';
import 'package:portfolio/features/home/widgets/contact_section.dart';
import 'package:portfolio/features/home/widgets/experience_section.dart';
import 'package:portfolio/features/home/widgets/hero_section.dart';
import 'package:portfolio/features/home/widgets/skills_section.dart';
import 'package:portfolio/features/home/widgets/work_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({this.initialSection, super.key});

  /// Section to scroll to on arrival, from `/?section=<name>`.
  final HomeSection? initialSection;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Map<HomeSection, GlobalKey<State<StatefulWidget>>> _keys = {
    for (final s in HomeSection.values) s: GlobalKey(),
  };

  @override
  void initState() {
    super.initState();
    _scheduleScroll(widget.initialSection);
  }

  @override
  void didUpdateWidget(HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialSection != oldWidget.initialSection) {
      _scheduleScroll(widget.initialSection);
    }
  }

  void _scheduleScroll(HomeSection? section) {
    if (section == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollTo(section));
  }

  Future<void> _scrollTo(HomeSection section) async {
    final target = _keys[section]!.currentContext;
    if (target == null) return;
    await Scrollable.ensureVisible(
      target,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    const content = portfolioContent;
    return SiteScaffold(
      onSection: _scrollTo,
      children: [
        HeroSection(
          profile: content.profile,
          featured: content.projects.first,
          onContact: () => _scrollTo(HomeSection.contact),
        ),
        AboutSection(profile: content.profile, stats: content.stats),
        KeyedSubtree(
          key: _keys[HomeSection.work],
          child: WorkSection(projects: content.projects),
        ),
        KeyedSubtree(
          key: _keys[HomeSection.experience],
          child: ExperienceSection(experience: content.experience),
        ),
        KeyedSubtree(
          key: _keys[HomeSection.skills],
          child: SkillsSection(groups: content.skills),
        ),
        KeyedSubtree(
          key: _keys[HomeSection.contact],
          child: ContactSection(profile: content.profile),
        ),
      ],
    );
  }
}
