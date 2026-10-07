/**
 * The site can be served from a sub-path (GitHub Pages project sites live at
 * /<repo>/). Every internal link goes through `url()` so it works both there
 * and at a domain root.
 */
const base = import.meta.env.BASE_URL.replace(/\/$/, '');

/** Prefixes a site-root path ('/projects/x', '/#work') with the deploy base.
 *  External URLs, mailto: links and in-page anchors pass through untouched. */
export function url(path: string): string {
  if (!path.startsWith('/') || path.startsWith('//')) return path;
  return `${base}${path}`;
}
