// Long copy is split across lines with adjacent strings; inside lists that
// trips no_adjacent_strings_in_list, whose parenthesised fix then trips
// unnecessary_parenthesis. Every list item here is reviewed copy.
// ignore_for_file: no_adjacent_strings_in_list

import 'package:portfolio/content/models.dart';

const portfolioContent = PortfolioContent(
  profile: _profile,
  stats: _stats,
  experience: _experience,
  projects: [_employeeBook],
  skills: _skills,
);

const _profile = Profile(
  name: 'Fawad Shah',
  role: 'Senior Flutter Engineer',
  headline: 'I build Flutter apps that hold up in production.',
  intro:
      'Senior Flutter engineer with 5+ years shipping cross-platform apps for '
      'Android and iOS, from e-commerce with real payments to real-time '
      'monitoring. I care about clean architecture, tests that earn their '
      'keep, and apps that start fast.',
  about: [
    'I lead mobile development for Star Gallery Mart, a UAE e-commerce app '
        'used by 20K+ active users. I own its architecture end to end: '
        'checkout and payments (Apple Pay, Google Pay, Stripe, Tabby, '
        'Tamara), native integrations through Platform Channels, and the '
        'performance work that cut startup time by 35%.',
    'Before that I shipped apps for e-commerce and health-tech clients at '
        'Tritech Solutions, mentored junior developers, and learned that '
        'architecture is mostly about making the next change cheap.',
    'Outside work I build small, deliberately engineered projects to sharpen '
        'the senior skills: testing strategy, CI/CD, and decisions I can '
        'defend in writing. I use AI coding tools daily, and I review their '
        'output like any other pull request.',
  ],
  location: 'Sharjah, UAE',
  availability: 'Open to remote roles',
  email: 'fawadshah2117@gmail.com',
  linkedInUrl: 'https://www.linkedin.com/in/fawad-shah-824931183',
  gitHubUrl: 'https://github.com/phawadshah2',
  cvPath: 'Fawad-Shah-CV.pdf',
);

const _stats = [
  Stat(value: '5+', label: 'years shipping Flutter'),
  Stat(value: '20K+', label: 'active users on my current app'),
  Stat(value: '35%', label: 'faster app startup'),
  Stat(value: '25%', label: 'lower memory usage'),
];

const _experience = [
  Experience(
    role: 'Senior Flutter Developer',
    company: 'Star Gallery Mart',
    location: 'Sharjah, UAE',
    period: 'May 2024 – Present',
    highlights: [
      'Own the architecture and delivery of a cross-platform e-commerce app '
          'serving 20K+ active users on the App Store and Google Play.',
      'Shipped 12+ features with product, design and backend teams, '
          'including secure checkout with Apple Pay, Google Pay, Stripe, '
          'Tabby and Tamara.',
      'Cut startup time by 35% and memory usage by 25% through DevTools '
          'profiling, image caching and lazy loading.',
    ],
    stack: ['Flutter', 'GetX', 'MVVM', 'Platform Channels', 'GitHub Actions'],
  ),
  Experience(
    role: 'Flutter Developer',
    company: 'Tritech Solutions',
    location: 'Peshawar, Pakistan',
    period: 'Jan 2022 – Mar 2024',
    highlights: [
      'Delivered 3 apps end to end for e-commerce and health-tech clients, '
          'from requirements to App Store and Play Store release.',
      'Introduced Clean Architecture and the Repository pattern, cutting '
          'new-developer onboarding time by 50%.',
      'Mentored 2 junior developers through pairing and code review.',
    ],
    stack: ['Flutter', 'Provider', 'BLoC', 'Firebase', 'Google Maps'],
  ),
  Experience(
    role: 'Junior Flutter Developer',
    company: 'AppSpot',
    location: 'Peshawar, Pakistan',
    period: 'Feb 2021 – Nov 2021',
    highlights: [
      'Contributed to 5 product releases across consumer and enterprise apps.',
      'Built a shared widget library that sped up feature development by 30%.',
    ],
    stack: ['Flutter', 'GetX', 'REST'],
  ),
];

const _employeeBook = Project(
  slug: 'employee-book',
  name: 'employee_book',
  tagline: 'An offline employee directory, built like a team codebase.',
  summary:
      'A small CRUD app on purpose. The point is how it is built: '
      'layered architecture, a sealed Result type, keyset pagination over '
      'SQLite, 70 tests, and a CI pipeline that signs and ships every merge.',
  tags: ['BLoC', 'Drift / SQLite', 'Clean Architecture', 'GitHub Actions'],
  repoUrl: 'https://github.com/phawadshah2/employee_book',
  caseStudy: CaseStudy(
    problem:
        'Most portfolio CRUD apps prove you can call setState. I wanted '
        'one that proves the opposite: that a simple domain can be built '
        'the way a team would need it built, with every rule testable '
        'without Flutter, every failure typed, and every change shipped '
        'through review and CI.',
    constraints: [
      'Offline-first: all data lives in on-device SQLite, no backend.',
      'Lists must stay fast and correct as rows are added or deleted.',
      'Every change lands as a small PR with a Conventional Commit, '
          'enforced by a git hook.',
      'Strict lints (very_good_analysis) and a pinned Flutter version '
          '(FVM) so CI and local builds agree.',
    ],
    layers: [
      ArchitectureLayer(
        name: 'Presentation',
        responsibility: 'Renders state, emits events. No business rules.',
        parts: [
          'Pages + widgets',
          'EmployeeListBloc',
          'AddEmployeeBloc',
          'EditEmployeeBloc',
        ],
      ),
      ArchitectureLayer(
        name: 'Domain',
        responsibility:
            'Pure Dart. Use cases, validation and typed failures. '
            'Unit-tested without Flutter.',
        parts: [
          'Use cases (add, get, list, update, delete)',
          'EmployeeValidation',
          'Result<T> / Failure',
          'EmployeeRepository (interface)',
        ],
      ),
      ArchitectureLayer(
        name: 'Data',
        responsibility:
            'Maps between SQLite rows and domain entities, and converts '
            'exceptions into failures.',
        parts: [
          'LocalEmployeeRepository',
          'EmployeeLocalDataSource',
          'Drift database + tables',
          'EmployeeDto',
        ],
      ),
    ],
    decisions: [
      Decision(
        title: 'Errors as values',
        choice: 'A sealed Result<T> with Success / FailureResult cases',
        why:
            'Dart 3 sealed classes make the compiler check that every '
            'outcome is handled in a switch, with no functional-programming '
            'dependency. Failures are typed (ValidationFailure, '
            'StorageFailure, EmployeeNotFoundFailure), so the UI can react '
            'precisely.',
        tradeoff:
            'No built-in map/flatMap chaining like dartz Either. Fine at '
            'this size, but worth revisiting if use cases start composing.',
      ),
      Decision(
        title: 'Pagination',
        choice: 'Keyset (cursor) pagination on the primary key',
        why:
            'The next page is "rows with id > lastId, limit 20". Unlike '
            'OFFSET, it never skips or repeats rows when items are inserted '
            'or deleted mid-scroll, and the indexed seek stays fast however '
            'deep the list goes.',
        tradeoff:
            'You cannot jump straight to page 7. That is fine for an '
            'infinite list, but a paged table would need a different API.',
      ),
      Decision(
        title: 'Local persistence',
        choice: 'Drift over raw sqflite or a key-value store',
        why:
            'Type-safe, compile-time-checked queries over real SQL, plus '
            'first-class migrations. The relational model fits '
            'employee data better than documents.',
        tradeoff: 'Adds a build_runner code-generation step to the workflow.',
      ),
      Decision(
        title: 'Where validation lives',
        choice: 'In the domain layer, behind the use cases',
        why:
            'Rules live in one place, are enforced no matter which screen '
            'calls them, and are covered by plain Dart unit tests that run '
            'in milliseconds.',
        tradeoff:
            'Forms need a mapping from domain errors to field messages, '
            'which is a bit more wiring than inline validators.',
      ),
    ],
    quality: [
      'Use cases and validation unit-tested against a stub repository '
          '(70 tests, all green).',
      'CI on every PR: format check, analyzer with --fatal-infos, tests, '
          'plus a release-APK build to catch Gradle and signing breakage '
          'before merge.',
      'Every merge to main produces a signed release APK and delivers it '
          'to Slack. Pipeline failures post an alert to the same channel.',
      'Signing keys live in GitHub secrets and are restored per run and '
          'deleted afterwards. PR builds use a throwaway key.',
      'Conventional Commits enforced locally by a commit-msg hook.',
    ],
    metrics: [
      Stat(value: '70', label: 'automated tests'),
      Stat(value: '18', label: 'PRs merged through CI'),
      Stat(value: '3', label: 'architecture layers'),
      Stat(value: '0', label: 'analyzer warnings allowed'),
    ],
    retrospective: [
      'dartz is still in pubspec.yaml although the sealed Result replaced '
          'it. Dependencies should leave in the same PR that makes them dead.',
      'The local data source adds an artificial 1-second delay to exercise '
          'loading states. Injecting latency only in debug or tests would '
          'keep production code honest.',
      'I tested the domain first, which was right, but bloc and widget '
          'tests should have followed each feature instead of being batched '
          'for later.',
    ],
    next: [
      'bloc_test coverage for the three BLoCs, plus widget and golden tests.',
      'Repository tests against an in-memory Drift database.',
      'Web support (Drift on Wasm) so the app runs live on this page.',
    ],
  ),
);

const _skills = [
  SkillGroup(
    title: 'Flutter & Dart',
    skills: [
      'Flutter (Android, iOS, Web)',
      'Dart 3: sealed classes, patterns, records',
      'Material & Cupertino',
      'Responsive & RTL layouts',
      'Animations: explicit, Rive, Lottie',
    ],
  ),
  SkillGroup(
    title: 'State & architecture',
    skills: [
      'BLoC / Cubit',
      'Riverpod',
      'Provider',
      'GetX',
      'Clean Architecture',
      'MVVM',
      'Repository pattern',
      'Dependency injection',
    ],
  ),
  SkillGroup(
    title: 'Data & integrations',
    skills: [
      'REST, Dio, JSON',
      'Drift / SQLite',
      'Firebase: Firestore, Auth, FCM, Crashlytics',
      'Stripe, Apple Pay, Google Pay',
      'Tabby, Tamara',
      'Google Maps SDK',
      'Google, Apple & Facebook sign-in',
    ],
  ),
  SkillGroup(
    title: 'Native & security',
    skills: [
      'Platform Channels',
      'Deep links & push notifications',
      'Flavors & environments',
      'JWT & secure sessions',
      'Keychain / Keystore',
    ],
  ),
  SkillGroup(
    title: 'Quality & delivery',
    skills: [
      'Unit, widget & integration tests',
      'GitHub Actions CI/CD',
      'Release signing',
      'App Store & Play releases',
      'DevTools profiling',
    ],
  ),
  SkillGroup(
    title: 'Ways of working',
    skills: [
      'Agile / Scrum',
      'Code review & mentoring',
      'Conventional Commits',
      'AI-assisted development',
    ],
  ),
];
