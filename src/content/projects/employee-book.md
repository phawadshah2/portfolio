---
name: employee_book
tagline: An offline employee directory, built like a team codebase.
summary: >-
  A small CRUD app on purpose. The point is how it is built: layered
  architecture, a sealed Result type, keyset pagination over SQLite, 70 tests,
  and a CI pipeline that signs and ships every merge.
tags: [BLoC, Drift / SQLite, Clean Architecture, GitHub Actions]
platforms: [android, ios]
kind: personal
featured: true
order: 1
links:
  repo: https://github.com/phawadshah2/employee_book
metrics:
  - { value: '70', label: automated tests }
  - { value: '18', label: PRs merged through CI }
  - { value: '3', label: architecture layers }
  - { value: '0', label: analyzer warnings allowed }
caseStudy:
  constraints:
    - 'Offline-first: all data lives in on-device SQLite, no backend.'
    - Lists must stay fast and correct as rows are added or deleted.
    - >-
      Every change lands as a small PR with a Conventional Commit, enforced by
      a git hook.
    - >-
      Strict lints (very_good_analysis) and a pinned Flutter version (FVM) so
      CI and local builds agree.
  architecture:
    intro: >-
      Dependencies point inward. Presentation and data both depend on the
      domain, and the domain depends on nothing. The data layer implements the
      repository interface the domain defines.
    layers:
      - name: Presentation
        responsibility: Renders state, emits events. No business rules.
        parts: [Pages + widgets, EmployeeListBloc, AddEmployeeBloc, EditEmployeeBloc]
      - name: Domain
        core: true
        responsibility: >-
          Pure Dart. Use cases, validation and typed failures. Unit-tested
          without Flutter.
        parts:
          - Use cases (add, get, list, update, delete)
          - EmployeeValidation
          - Result<T> / Failure
          - EmployeeRepository (interface)
      - name: Data
        responsibility: >-
          Maps between SQLite rows and domain entities, and converts exceptions
          into failures.
        parts:
          - LocalEmployeeRepository
          - EmployeeLocalDataSource
          - Drift database + tables
          - EmployeeDto
  decisions:
    - title: Errors as values
      choice: A sealed Result<T> with Success / FailureResult cases
      why: >-
        Dart 3 sealed classes make the compiler check that every outcome is
        handled in a switch, with no functional-programming dependency.
        Failures are typed (ValidationFailure, StorageFailure,
        EmployeeNotFoundFailure), so the UI can react precisely.
      tradeoff: >-
        No built-in map/flatMap chaining like dartz Either. Fine at this size,
        but worth revisiting if use cases start composing.
    - title: Pagination
      choice: Keyset (cursor) pagination on the primary key
      why: >-
        The next page is "rows with id > lastId, limit 20". Unlike OFFSET, it
        never skips or repeats rows when items are inserted or deleted
        mid-scroll, and the indexed seek stays fast however deep the list goes.
      tradeoff: >-
        You cannot jump straight to page 7. That is fine for an infinite list,
        but a paged table would need a different API.
    - title: Local persistence
      choice: Drift over raw sqflite or a key-value store
      why: >-
        Type-safe, compile-time-checked queries over real SQL, plus first-class
        migrations. The relational model fits employee data better than
        documents.
      tradeoff: Adds a build_runner code-generation step to the workflow.
    - title: Where validation lives
      choice: In the domain layer, behind the use cases
      why: >-
        Rules live in one place, are enforced no matter which screen calls
        them, and are covered by plain Dart unit tests that run in
        milliseconds.
      tradeoff: >-
        Forms need a mapping from domain errors to field messages, which is a
        bit more wiring than inline validators.
  quality:
    - >-
      Use cases and validation unit-tested against a stub repository (70
      tests, all green).
    - >-
      CI on every PR: format check, analyzer with --fatal-infos, tests, plus a
      release-APK build to catch Gradle and signing breakage before merge.
    - >-
      Every merge to main produces a signed release APK and delivers it to
      Slack. Pipeline failures post an alert to the same channel.
    - >-
      Signing keys live in GitHub secrets and are restored per run and deleted
      afterwards. PR builds use a throwaway key.
    - Conventional Commits enforced locally by a commit-msg hook.
  retrospective:
    - >-
      dartz is still in pubspec.yaml although the sealed Result replaced it.
      Dependencies should leave in the same PR that makes them dead.
    - >-
      The local data source adds an artificial 1-second delay to exercise
      loading states. Injecting latency only in debug or tests would keep
      production code honest.
    - >-
      I tested the domain first, which was right, but bloc and widget tests
      should have followed each feature instead of being batched for later.
  next:
    - bloc_test coverage for the three BLoCs, plus widget and golden tests.
    - Repository tests against an in-memory Drift database.
    - Web support (Drift on Wasm) so the app runs live on this page.
---

Most portfolio CRUD apps prove you can call `setState`. I wanted one that
proves the opposite: that a simple domain can be built the way a team would
need it built, with every rule testable without Flutter, every failure typed,
and every change shipped through review and CI.
