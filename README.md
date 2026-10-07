# portfolio

Personal site of **Fawad Shah, Senior Flutter Engineer**. Built with
[Astro](https://astro.build): static HTML, about 2.5 KB of JavaScript, and
Flutter web builds of my apps embedded as live demos.

> The first version was a Flutter Web app (tag `flutter-v1`). It moved to Astro
> for instant first paint, SEO, and cheap animation, so Flutter now powers the
> demos instead of the page shell.

## Editing content (no code needed)

All copy lives in `src/content/` and is validated at build time. A typo or a
missing field fails the build with a message pointing at the file.

| File | What it holds |
|---|---|
| `profile.yaml` | Name, headline, intro, about, contact links, CV path, stats |
| `experience.yaml` | Jobs, newest first (`order`) |
| `skills.yaml` | Skill groups |
| `projects/<slug>.md` | One file per project. The file name is the URL: `/projects/<slug>` |

### Adding a project

Copy `src/content/projects/employee-book.md` to `projects/<new-slug>.md` and
edit it. Required fields: `name`, `tagline`, `summary`, `tags`, `platforms`.
Everything else is optional and only shows up when filled in:

- `featured: true` puts it on the home page; `order` sorts it.
- `links` (repo, Play Store, App Store, website)
- `cover` and `screenshots`: images stored next to the Markdown file, e.g.
  `src/content/projects/my-app/home.png`, referenced as `./my-app/home.png`.
  Astro resizes and compresses them at build time.
- `video`: a path under `public/`, e.g. `/videos/my-app.mp4`
- `demo`: a live Flutter web build (see below)
- `metrics` and `caseStudy` (constraints, architecture, decisions, quality,
  retrospective, next)

The Markdown body is "The problem" section of the case study.

### Adding a live demo

1. In the app's repo:

   ```bash
   fvm flutter build web --wasm --release --base-href /demos/<slug>/
   ```

2. Copy everything in `build/web/` to `public/demos/<slug>/`.
3. In the project's Markdown: `demo: { url: /demos/<slug>/ }`

The project page shows a phone frame with a **Run the live app** button. The
build is only downloaded when a visitor clicks it.

## Develop

Requires Node 24 (`.nvmrc`).

```bash
npm install
npm run dev        # http://localhost:4321
npm run check      # types + content schemas (CI runs this)
npm run build      # static site in dist/
npm run preview    # serve dist/ locally
```

## How it is built

- **Pages:** `src/pages` (home, `/projects`, `/projects/<slug>`, 404).
- **Motion:** CSS opacity/transform transitions only (no layout work per
  frame). One `IntersectionObserver` reveals content on scroll
  (`src/scripts/motion.ts`); stat numbers count up; pages cross-fade with the
  browser's View Transitions. `prefers-reduced-motion` turns all of it off.
- **Theme:** light/dark follows the OS until the visitor toggles it; the choice
  is applied before first paint, so there is no flash.
- **Fonts:** Inter, Space Grotesk and JetBrains Mono, self-hosted as Latin
  subset WOFF2 (~128 KB total, no third-party requests).
- **SEO:** per-page title and description, Open Graph image, JSON-LD `Person`
  schema; canonical URLs and a sitemap once `SITE_URL` is set.

## Deploy

Hosted on **GitHub Pages** at https://phawadshah2.github.io/portfolio.

CI (`.github/workflows/ci.yml`) runs `npm run check` and `npm run build` on
every PR. On `main` it also builds for Pages and deploys. The workflow reads
the Pages URL, so the sub-path (`/portfolio`) is applied automatically, and
moving to a custom domain later needs no code change.

One-time setup: repo **Settings → Pages → Build and deployment → Source:
GitHub Actions**.

Internal links must go through `url()` from `src/lib/paths.ts` (the `Button`
component already does) so they keep working under the sub-path.

**Live demos on Pages:** GitHub Pages cannot send the cross-origin isolation
headers that Flutter's multithreaded Wasm renderer uses, so demos run on the
single-threaded renderer. They work; they are just slightly slower to start.
