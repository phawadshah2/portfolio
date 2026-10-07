/**
 * Scroll reveals and count-ups.
 *
 * Cost model: one IntersectionObserver for the whole page (the browser does
 * the visibility math off the main thread), each element is unobserved after
 * revealing, and the bottom-of-page fallback listener detaches once nothing
 * is pending. Animations themselves are CSS opacity/transform only.
 */

const reduceMotion = window.matchMedia('(prefers-reduced-motion: reduce)');

function countUp(el: HTMLElement) {
  const final = el.dataset.count ?? el.textContent ?? '';
  const match = /^(\D*)(\d+)(.*)$/.exec(final);
  if (!match || reduceMotion.matches) return;

  const [, prefix, digits, suffix] = match;
  const target = Number(digits);
  const duration = 900;
  const start = performance.now();
  // Screen readers keep the final value; the ticking digits are visual only.
  el.setAttribute('aria-label', final);

  const tick = (now: number) => {
    const t = Math.min((now - start) / duration, 1);
    const eased = 1 - Math.pow(1 - t, 3);
    el.textContent = `${prefix}${Math.round(target * eased)}${suffix}`;
    if (t < 1) requestAnimationFrame(tick);
    else el.textContent = final;
  };
  requestAnimationFrame(tick);
}

function reveal(el: Element) {
  el.classList.add('is-visible');
  el.querySelectorAll<HTMLElement>('[data-count]').forEach(countUp);
  if (el instanceof HTMLElement && el.dataset.count !== undefined) countUp(el);
}

export function initMotion() {
  const pending = new Set(document.querySelectorAll('[data-reveal]'));
  if (pending.size === 0) return;

  const observer = new IntersectionObserver(
    (entries) => {
      for (const entry of entries) {
        // Also reveal anything already above the viewport (deep links,
        // restored scroll position) so scrolling back up never finds gaps.
        if (entry.isIntersecting || entry.boundingClientRect.top < 0) {
          observer.unobserve(entry.target);
          pending.delete(entry.target);
          reveal(entry.target);
        }
      }
      if (pending.size === 0) detachBottomCheck();
    },
    // Trigger a little before the element is fully in view.
    { rootMargin: '0px 0px -8% 0px' },
  );
  pending.forEach((el) => observer.observe(el));

  // Content in the last few percent of a page can never scroll past the
  // trigger line. Once the visitor hits the bottom, show what is on screen.
  let frame = 0;
  const onScroll = () => {
    if (frame) return;
    frame = requestAnimationFrame(() => {
      frame = 0;
      const atBottom =
        window.innerHeight + window.scrollY >=
        document.documentElement.scrollHeight - 2;
      if (!atBottom) return;
      for (const el of pending) {
        if (el.getBoundingClientRect().top < window.innerHeight) {
          observer.unobserve(el);
          pending.delete(el);
          reveal(el);
        }
      }
      if (pending.size === 0) detachBottomCheck();
    });
  };
  const detachBottomCheck = () => window.removeEventListener('scroll', onScroll);
  window.addEventListener('scroll', onScroll, { passive: true });
}
