import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/content/portfolio_content.dart';
import 'package:portfolio/features/home/home_page.dart';
import 'package:portfolio/features/not_found/not_found_page.dart';
import 'package:portfolio/features/projects/case_study_page.dart';

import '../helpers/pump_app.dart';

void main() {
  final project = portfolioContent.projects.first;

  group('routing', () {
    testWidgets('/ shows the home page', (tester) async {
      await tester.pumpApp();
      expect(find.byType(HomePage), findsOneWidget);
      expect(find.text(portfolioContent.profile.headline), findsOneWidget);
    });

    testWidgets('/projects/<slug> shows that case study', (tester) async {
      await tester.pumpApp(location: project.path);
      expect(find.byType(CaseStudyPage), findsOneWidget);
      expect(find.text(project.caseStudy.problem), findsOneWidget);
    });

    testWidgets('an unknown slug shows the 404 page', (tester) async {
      await tester.pumpApp(location: '/projects/nope');
      expect(find.byType(NotFoundPage), findsOneWidget);
    });

    testWidgets('an unknown path shows the 404 page', (tester) async {
      await tester.pumpApp(location: '/definitely/not/here');
      expect(find.byType(NotFoundPage), findsOneWidget);
    });

    testWidgets('the project card opens the case study', (tester) async {
      await tester.pumpApp();
      final button = find.text('Read the case study').last;
      await tester.ensureVisible(button);
      await tester.pumpAndSettle();
      await tester.tap(button);
      await tester.pumpAndSettle();
      expect(find.byType(CaseStudyPage), findsOneWidget);
    });

    testWidgets('the 404 page links back home', (tester) async {
      await tester.pumpApp(location: '/missing');
      await tester.tap(find.text('Back to home'));
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);
    });
  });

  group('layout', () {
    for (final (name, size) in [
      ('desktop', desktopSize),
      ('mobile', mobileSize),
    ]) {
      testWidgets('home renders without overflow on $name', (tester) async {
        await tester.pumpApp(size: size);
        expect(tester.takeException(), isNull);
      });

      testWidgets('case study renders without overflow on $name', (
        tester,
      ) async {
        await tester.pumpApp(location: project.path, size: size);
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('mobile collapses nav links into a menu', (tester) async {
      await tester.pumpApp(size: mobileSize);
      expect(find.byTooltip('Menu'), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'Experience'), findsNothing);
    });

    testWidgets('theme toggle switches brightness', (tester) async {
      await tester.pumpApp();
      Brightness current() =>
          Theme.of(tester.element(find.byType(HomePage))).brightness;
      final before = current();
      await tester.tap(
        find.byIcon(
          before == Brightness.dark
              ? Icons.light_mode_outlined
              : Icons.dark_mode_outlined,
        ),
      );
      await tester.pumpAndSettle();
      expect(current(), isNot(before));
    });
  });
}
