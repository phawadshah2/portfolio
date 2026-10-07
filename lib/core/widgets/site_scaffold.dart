import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/content/portfolio_content.dart';
import 'package:portfolio/core/widgets/site_footer.dart';
import 'package:portfolio/core/widgets/site_nav.dart';

/// Shared page frame: sticky nav, scrolling body, footer.
///
/// Pages other than home pass no [onSection]; nav links then navigate to
/// `/?section=<name>` and the home page scrolls itself into place.
class SiteScaffold extends StatelessWidget {
  const SiteScaffold({
    required this.children,
    this.onSection,
    this.scrollController,
    super.key,
  });

  final List<Widget> children;
  final ValueChanged<HomeSection>? onSection;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final name = portfolioContent.profile.name;
    return Scaffold(
      body: Column(
        children: [
          SiteNav(
            name: name,
            onHome: () => context.go('/'),
            onSection:
                onSection ??
                (section) => context.go('/?section=${section.name}'),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ...children,
                  SiteFooter(name: name),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
