// Fails when any content file still contains `draft: true`, i.e. the Stitch
// design's sample content (placeholder employers, stats, testimonials). CI
// runs this before deploying main so sample data is never published under
// your name. Remove the `draft: true` lines once the content is real.
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

if (hits.length) {
  console.error('Draft (sample) content is still present, so this will not be published:');
  for (const h of hits) console.error(`  - ${h}`);
  console.error('Replace it with real data and remove the draft markers to deploy.');
  process.exit(1);
}
console.log('No draft content. OK to publish.');
