// @ts-check
import sitemap from '@astrojs/sitemap';
import { defineConfig } from 'astro/config';

// The deployed origin, e.g. https://fawadshah.dev. Set it in CI (SITE_URL)
// once the domain is live: it makes link-preview and canonical URLs absolute
// and enables the sitemap.
const site = process.env.SITE_URL || undefined;

// https://astro.build/config
export default defineConfig({
  site,
  trailingSlash: 'never',
  integrations: site ? [sitemap()] : [],
  prefetch: {
    // Fetch internal pages on hover so navigation feels instant.
    prefetchAll: true,
    defaultStrategy: 'hover',
  },
});
