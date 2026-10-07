import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/content/portfolio_content.dart';
import 'package:portfolio/core/motion/motion.dart';
import 'package:portfolio/core/widgets/site_nav.dart';
import 'package:portfolio/features/home/home_page.dart';
import 'package:portfolio/features/not_found/not_found_page.dart';
import 'package:portfolio/features/projects/case_study_page.dart';

GoRouter createRouter({String initialLocation = '/'}) {
  return GoRouter(
    initialLocation: initialLocation,
    errorBuilder: (context, state) => const NotFoundPage(),
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) {
          final name = state.uri.queryParameters['section'];
          final section = HomeSection.values
              .where((s) => s.name == name)
              .firstOrNull;
          return _fadePage(state, HomePage(initialSection: section));
        },
      ),
      GoRoute(
        path: '/projects/:slug',
        pageBuilder: (context, state) {
          final project = portfolioContent.projectBySlug(
            state.pathParameters['slug']!,
          );
          return _fadePage(
            state,
            project == null
                ? const NotFoundPage()
                : CaseStudyPage(project: project),
          );
        },
      ),
    ],
  );
}

/// Short cross-fade between pages. Platform defaults (zoom or slide) feel
/// app-like and heavy on a website.
CustomTransitionPage<void> _fadePage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    transitionDuration: Motion.page,
    reverseTransitionDuration: Motion.page,
    child: child,
    transitionsBuilder: (context, animation, _, child) => context.reduceMotion
        ? child
        : FadeTransition(
            opacity: animation.drive(CurveTween(curve: Motion.enter)),
            child: child,
          ),
  );
}
