# portfolio

Personal site of **Fawad Shah, Senior Flutter Engineer**: a Flutter Web app compiled to WebAssembly.

The site doubles as a work sample, so it is built like the apps it describes: typed content separated from UI, tests, strict lints, and CI that deploys on merge.

## Stack

| Concern | Choice |
|---|---|
| Rendering | Flutter Web, `--wasm` (skwasm, multithreaded via cross-origin isolation) |
| Routing | `go_router` with path URLs (`/projects/employee-book`), 404 page |
| State | `flutter_bloc`. One `ThemeCubit`; content is `const` data, so nothing else needs state |
| Theming | Material 3 + an `AppPalette` `ThemeExtension` for tokens Material has no slot for |
| Fonts | Inter, Space Grotesk, JetBrains Mono: bundled, Latin-subset static TTFs (~330 KB total) |
| Hosting | Firebase Hosting (SPA rewrite + COOP/COEP headers) |

## Structure

```
lib/
  app/            app widget + router
  content/        typed models + all site copy (portfolio_content.dart)
  core/           theme, breakpoints, shared widgets, link helpers
  features/
    home/         hero, about, work, experience, skills, contact
    projects/     case study page, architecture diagram, decision cards
    not_found/
web/              index.html (SEO/OG tags, splash, noscript), icons, CV, og-image
tool/serve.py     serves build/web like production (SPA fallback + headers)
```

To change any text on the site, edit `lib/content/portfolio_content.dart`. No widget changes needed.

## Develop

```bash
fvm flutter pub get
fvm flutter run -d chrome
```

Preview the production build locally:

```bash
fvm flutter build web --wasm --release && python3 tool/serve.py
```

Checks (the same ones CI runs):

```bash
fvm dart format --set-exit-if-changed . && fvm flutter analyze --fatal-infos && fvm flutter test
```

## Deploy

CI (`.github/workflows/ci.yml`) runs format, analyze, test and a Wasm build on every PR. The `deploy` job publishes `main` to Firebase Hosting once these are set in the GitHub repo:

1. Create a Firebase project and enable Hosting.
2. Repo **variable** `FIREBASE_PROJECT_ID`: the project id.
3. Repo **secret** `FIREBASE_SERVICE_ACCOUNT`: JSON key of a service account with the *Firebase Hosting Admin* role.

Until the variable exists, the deploy job is skipped.

After the first deploy, make `og:image` absolute and add `og:url` in `web/index.html` so link previews work everywhere.
