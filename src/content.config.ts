import { defineCollection } from 'astro:content';
import { file, glob } from 'astro/loaders';
import { z } from 'astro/zod';

/**
 * All site copy lives in src/content. These schemas validate it at build
 * time, so a typo in a YAML or Markdown file fails the build instead of
 * shipping a broken page.
 */

/**
 * `draft: true` marks the Stitch design's sample content. While any draft is
 * present the site shows a banner and CI will not deploy (scripts/check-drafts.mjs).
 */
const draft = z.boolean().default(false);

const link = z.object({ label: z.string(), href: z.string() });

const stat = z.object({
  value: z.string(),
  label: z.string(),
});

const profile = defineCollection({
  loader: file('src/content/profile.yaml'),
  schema: ({ image }) =>
    z.object({
      name: z.string(),
      role: z.string(),
      headline: z.string(),
      intro: z.string(),
      about: z.array(z.string()).min(1),
      location: z.string(),
      availability: z.string(),
      email: z.email(),
      linkedin: z.url(),
      github: z.url(),
      cv: z.string(),
      stats: z.array(stat),
      /** App Store-style cards in the hero (3–4 look best). */
      showcase: z
        .array(
          z.object({
            image: image(),
            caption: z.string(),
            /** Project slug the card links to. */
            project: z.string(),
            alt: z.string(),
          }),
        )
        .max(4)
        .default([]),
    }),
});

const home = defineCollection({
  loader: file('src/content/home.yaml'),
  schema: z.object({
    draft: draft,
    hero: z.object({
      badge: z.string(),
      headline: z.array(z.string()).min(1),
      intro: z.string(),
      primaryCta: link,
      secondaryCta: link,
      trust: z.array(z.object({ icon: z.string(), label: z.string() })).default([]),
    }),
    metrics: z.array(
      z.object({ value: z.string(), label: z.string(), accent: z.boolean().default(false) }),
    ),
    work: z.object({ eyebrow: z.string(), title: z.string(), intro: z.string() }),
    services: z.object({
      eyebrow: z.string(),
      title: z.string(),
      intro: z.string(),
      items: z.array(
        z.object({
          icon: z.string(),
          title: z.string(),
          body: z.string(),
          wide: z.boolean().default(false),
        }),
      ),
    }),
    process: z.object({
      badge: z.string(),
      title: z.string(),
      steps: z.array(z.object({ icon: z.string(), title: z.string(), body: z.string() })),
    }),
    stack: z.object({
      eyebrow: z.string(),
      title: z.string(),
      groups: z.array(
        z.object({
          name: z.string(),
          primary: z.boolean().default(false),
          chips: z.array(z.string()),
        }),
      ),
    }),
    experience: z.object({ eyebrow: z.string(), title: z.string() }),
    testimonials: z.object({
      eyebrow: z.string(),
      title: z.string(),
      items: z.array(z.object({ quote: z.string(), name: z.string(), role: z.string() })),
    }),
    contact: z.object({
      eyebrow: z.string(),
      title: z.string(),
      body: z.string(),
      email: z.string(),
      whatsapp: z.string().optional(),
      response: z.string().optional(),
      projectTypes: z.array(z.string()),
    }),
  }),
});

const experience = defineCollection({
  loader: file('src/content/experience.yaml'),
  schema: z.object({
    draft: draft,
    role: z.string(),
    company: z.string(),
    location: z.string().optional(),
    period: z.string(),
    order: z.number(),
    /** Highlighted (emerald) marker on the timeline. */
    current: z.boolean().default(false),
    highlights: z.array(z.string()).min(1),
    stack: z.array(z.string()).default([]),
  }),
});

const projects = defineCollection({
  // One Markdown file per project; the file name is the URL slug.
  loader: glob({ pattern: '**/*.md', base: './src/content/projects' }),
  schema: ({ image }) =>
    z.object({
      draft: draft,
      /** Has its own page in src/pages/projects/ instead of the template. */
      customPage: z.boolean().default(false),
      name: z.string(),
      tagline: z.string(),
      /** Highlight pill on the project card (e.g. a key result). */
      badge: z.string().optional(),
      /** Neutral pill next to the badge (e.g. market or domain). */
      category: z.string().optional(),
      /** Hand-built HTML phone screen shown on the card. */
      preview: z.enum(['aura', 'cadence', 'breathefree']).optional(),
      summary: z.string(),
      tags: z.array(z.string()),
      platforms: z.array(
        z.enum(['android', 'ios', 'web', 'macos', 'windows', 'linux']),
      ),
      kind: z.enum(['personal', 'professional']).default('personal'),
      /** Shown on the home page. */
      featured: z.boolean().default(false),
      /** Lower comes first. */
      order: z.number().default(100),
      links: z
        .object({
          repo: z.url().optional(),
          playStore: z.url().optional(),
          appStore: z.url().optional(),
          website: z.url().optional(),
        })
        .default({}),
      /** A Flutter web build, e.g. /demos/<slug>/ — loaded only on click. */
      demo: z
        .object({
          url: z.string(),
          note: z.string().optional(),
        })
        .optional(),
      cover: image().optional(),
      screenshots: z
        .array(z.object({ src: image(), alt: z.string() }))
        .default([]),
      video: z
        .object({ src: z.string(), poster: image().optional() })
        .optional(),
      metrics: z.array(stat).default([]),
      caseStudy: z
        .object({
          constraints: z.array(z.string()).default([]),
          architecture: z
            .object({
              intro: z.string(),
              layers: z.array(
                z.object({
                  name: z.string(),
                  responsibility: z.string(),
                  parts: z.array(z.string()),
                  core: z.boolean().default(false),
                }),
              ),
            })
            .optional(),
          decisions: z
            .array(
              z.object({
                title: z.string(),
                choice: z.string(),
                why: z.string(),
                tradeoff: z.string(),
              }),
            )
            .default([]),
          quality: z.array(z.string()).default([]),
          retrospective: z.array(z.string()).default([]),
          next: z.array(z.string()).default([]),
        })
        .optional(),
    }),
});

export const collections = { profile, home, experience, projects };
