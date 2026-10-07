import 'package:go_router/go_router.dart';
import 'package:portfolio/content/portfolio_content.dart';
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
        builder: (context, state) {
          final name = state.uri.queryParameters['section'];
          final section = HomeSection.values
              .where((s) => s.name == name)
              .firstOrNull;
          return HomePage(initialSection: section);
        },
      ),
      GoRoute(
        path: '/projects/:slug',
        builder: (context, state) {
          final project = portfolioContent.projectBySlug(
            state.pathParameters['slug']!,
          );
          if (project == null) return const NotFoundPage();
          return CaseStudyPage(project: project);
        },
      ),
    ],
  );
}
