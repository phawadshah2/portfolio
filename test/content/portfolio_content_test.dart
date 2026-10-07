import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/content/portfolio_content.dart';

void main() {
  const content = portfolioContent;

  group('PortfolioContent', () {
    test('project slugs are unique and URL-safe', () {
      final slugs = content.projects.map((p) => p.slug).toList();
      expect(slugs.toSet(), hasLength(slugs.length));
      for (final slug in slugs) {
        expect(slug, matches(RegExp(r'^[a-z0-9]+(-[a-z0-9]+)*$')));
      }
    });

    test('projectBySlug finds known projects and rejects unknown ones', () {
      final first = content.projects.first;
      expect(content.projectBySlug(first.slug), first);
      expect(content.projectBySlug('does-not-exist'), isNull);
    });

    test('external links use https', () {
      final profile = content.profile;
      final urls = [
        profile.linkedInUrl,
        profile.gitHubUrl,
        for (final p in content.projects) ...[p.repoUrl, ?p.demoUrl],
      ];
      for (final url in urls) {
        expect(Uri.parse(url).scheme, 'https', reason: url);
      }
    });

    test('the site never publishes a phone number', () {
      // Phone stays in the CV only; public pages get scraped for spam.
      final phone = RegExp(r'\+?\d[\d\s-]{8,}\d');
      final profile = content.profile;
      final copy = [
        profile.intro,
        ...profile.about,
        profile.location,
        profile.availability,
        for (final e in content.experience) ...e.highlights,
      ];
      for (final text in copy) {
        expect(phone.hasMatch(text), isFalse, reason: text);
      }
    });

    test('every case study is complete enough to publish', () {
      for (final project in content.projects) {
        final study = project.caseStudy;
        expect(study.problem, isNotEmpty, reason: project.slug);
        expect(study.layers, hasLength(3), reason: project.slug);
        expect(study.decisions, isNotEmpty, reason: project.slug);
        expect(study.metrics, isNotEmpty, reason: project.slug);
        expect(study.retrospective, isNotEmpty, reason: project.slug);
      }
    });
  });
}
