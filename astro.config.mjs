// @ts-check
import sitemap from '@astrojs/sitemap';
import { defineConfig } from 'astro/config';

// Both come from CI (see .github/workflows/ci.yml), so the same code works at a
// domain root and on a GitHub Pages project site:
// - SITE_URL:  deployed origin, e.g. https://phawadshah2.github.io. Makes
//   link-preview and canonical URLs absolute and enables the sitemap.
// - BASE_PATH: sub-path the site is served from, e.g. /portfolio.
const site = process.env.SITE_URL || undefined;
const base = process.env.BASE_PATH || '/';

// https://astro.build/config
export default defineConfig({
  site,
  base,
  trailingSlash: 'never',
  build: {
    // /projects/employee-book.html instead of /projects/employee-book/index.html,
    // so links without a trailing slash resolve without a redirect.
    format: 'file',
  },
  integrations: site ? [sitemap()] : [],
  prefetch: {
    // Fetch internal pages on hover so navigation feels instant.
    prefetchAll: true,
    defaultStrategy: 'hover',
  },
});
