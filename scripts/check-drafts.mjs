// Lists content files that still contain `draft: true`, i.e. the Stitch
// design's sample content (placeholder employers, stats, testimonials).
//
//   node scripts/check-drafts.mjs          fail if any draft remains
//   node scripts/check-drafts.mjs --warn   report only (CI uses this)
//
// Drafts may be deployed because the site labels them itself: while any
// draft remains, every page shows a "Draft preview" banner and carries
// `noindex` (see hasDraftContent() in src/lib/content.ts).
import { readdirSync, readFileSync, statSync } from 'node:fs';
import { join } from 'node:path';

const roots = ['src/content', 'src/pages'];
const hits = [];
const walk = (dir) => {
  for (const name of readdirSync(dir)) {
    const path = join(dir, name);
    if (statSync(path).isDirectory()) walk(path);
    else if (/\.(ya?ml|md|astro)$/.test(name) && !name.includes('.real.')) {
      const text = readFileSync(path, 'utf8');
      if (/^\s*(-\s*)?draft:\s*true\b/m.test(text) || /^\s*\*\s*DRAFT:/m.test(text)) hits.push(path);
    }
  }
};
roots.forEach(walk);

const warnOnly = process.argv.includes('--warn');
if (hits.length) {
  const list = hits.map((h) => `  - ${h}`).join('\n');
  if (warnOnly) {
    // GitHub Actions annotation: shows on the run summary.
    console.log(`::warning title=Draft content is live::${hits.length} file(s) still hold sample content; pages show a Draft banner and are noindexed.`);
    console.log(`Draft (sample) content still present:\n${list}`);
    process.exit(0);
  }
  console.error(`Draft (sample) content is still present:\n${list}`);
  console.error('Replace it with real data and remove the draft markers.');
  process.exit(1);
}
console.log('No draft content. OK to publish.');
