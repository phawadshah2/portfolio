# portfolio

Personal site of **Fawad Shah, Senior Flutter Engineer**. Built with
[Astro](https://astro.build): static HTML, about 2.5 KB of JavaScript, and
Flutter web builds of my apps embedded as live demos.

> The first version was a Flutter Web app (tag `flutter-v1`). It moved to Astro
> for instant first paint, SEO, and cheap animation, so Flutter now powers the
> demos instead of the page shell.

## ⚠️ Draft content (Stitch redesign)

The current design came from a Stitch mock-up, and so did its copy: the
employers, numbers, testimonials, the Aura Market / Cadence / BreatheFree
projects and the contact details are **sample content**, marked `draft: true`.

While any draft remains:
- every page shows a **"Draft preview" banner** and carries `noindex`;
- CI still deploys, but posts a **warning** listing the draft files
  (`npm run check:drafts` locally fails while any remain).

To go live, replace the sample content with real data:
- `src/content/home.yaml`: hero, metrics, services, process, stack, testimonials, contact
- `src/content/experience.yaml`: your real history is in `experience.real.yaml`
- `src/content/projects/*.md`: real projects (`employee-book.md` is real)
- `src/pages/projects/aura-market.astro`: sample case study; delete it or rewrite it

then delete the `draft: true` lines (and the `DRAFT:` header comment in
`aura-market.astro`). `skills.real.yaml` keeps your real skill groups for the
stack section.

## Editing content (no code needed)

All copy lives in `src/content/` and is validated at build time. A typo or a
missing field fails the build with a message pointing at the file.

| File | What it holds |
|---|---|
| `profile.yaml` | Name, role, links, CV path |
| `home.yaml` | Every home-page section (hero, metrics, services, process, stack, testimonials, contact) |
| `experience.yaml` | Jobs, newest first (`order`); `current: true` highlights the marker |
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
- **Design system:** "Engineering Craft" (Stitch `DESIGN.md`): emerald on
  light neutrals, Inter, hairline borders; tokens in `src/styles/global.css`.
- **Motion** (`src/scripts/motion.ts`, all opacity/transform/clip-path, each
  runs once per visit):
  - Hero: headline lines, intro, badge + CTAs, then the phone (rise + scale),
    background panels staggered, then the phone's UI builds in (`data-settle`).
    Desktop pointer tilt (≤5°, interpolated) with depth parallax; 4px resting float.
  - Scroll reveals (`data-reveal`, `data-reveal="mask"` for large panels).
  - Count-ups (`data-count`, optional `data-count-start`) once in view.
  - Timeline: line draws, markers pop as it reaches them, entries follow.
  - Project cards: ≈2.5° 3D tilt, image scale, arrow nudge (desktop only).
  - Aura Market preview: accessible tabs switch the phone screen (crossfade + slide).
  - `prefers-reduced-motion` shows everything instantly.
- **Fonts:** Inter and JetBrains Mono, self-hosted Latin-subset WOFF2.
- **Icons:** inline SVG (`src/components/Icon.astro`), no icon font.
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
