/**
 * Page motion: scroll reveals, count-ups, the hero "settle" step, the career
 * timeline and project-card tilt.
 *
 * Cost model:
 * - One IntersectionObserver for every reveal (visibility math runs off the
 *   main thread); each element is unobserved once revealed, so a fully
 *   revealed page does no work while scrolling.
 * - Everything animates opacity/transform/clip-path via CSS transitions;
 *   JS only toggles classes or sets a couple of custom properties.
 * - Reveals run once per visit and never replay on scroll-back.
 * - prefers-reduced-motion: CSS shows everything instantly; counters jump
 *   straight to their final value.
 */

const reduceMotion = matchMedia('(prefers-reduced-motion: reduce)');

/* ----------------------------------------------------------------- count-up */

const NUMBER = /^(\D*?)(\d[\d,]*(?:\.\d+)?)(.*)$/;

function countUp(el: HTMLElement) {
  if (el.dataset.counted) return;
  el.dataset.counted = '1';
  const final = el.dataset.count ?? el.textContent ?? '';
  const match = NUMBER.exec(final.trim());
  if (!match || reduceMotion.matches) return;

  const [, prefix, digits, suffix] = match;
  const target = Number(digits.replace(/,/g, ''));
  const decimals = digits.includes('.') ? digits.split('.')[1].length : 0;
  const grouped = digits.includes(',');
  // A sensible starting point: 0 for small numbers, or an explicit value
  // (e.g. a balance counting up from a recent figure, not from zero).
  const start = Number(el.dataset.countStart ?? 0);
  const duration = Number(el.dataset.countDuration ?? 1000);
  const format = (n: number) =>
    grouped || decimals
      ? n.toLocaleString('en-US', {
          minimumFractionDigits: decimals,
          maximumFractionDigits: decimals,
          useGrouping: grouped,
        })
      : String(Math.round(n));

  // Screen readers keep the final value; ticking digits are visual only.
  el.setAttribute('aria-label', final);
  const t0 = performance.now();
  const tick = (now: number) => {
    const t = Math.min((now - t0) / duration, 1);
    const eased = 1 - Math.pow(1 - t, 3);
    el.textContent = `${prefix}${format(start + (target - start) * eased)}${suffix}`;
    if (t < 1) requestAnimationFrame(tick);
    else el.textContent = final;
  };
  requestAnimationFrame(tick);
}

/**
 * A counter starts with the element that "owns" it: its nearest settle step
 * if it has one (e.g. the hero phone), otherwise its nearest reveal. This
 * keeps numbers from ticking before they are visible.
 */
function ownedCounters(owner: Element) {
  return [...owner.querySelectorAll<HTMLElement>('[data-count]'), ...(owner.matches('[data-count]') ? [owner as HTMLElement] : [])].filter(
    (c) => (c.closest('[data-settle]') ?? c.closest('[data-reveal]')) === owner,
  );
}

/* ------------------------------------------------------------------- reveal */

function revealDuration(el: HTMLElement) {
  const style = getComputedStyle(el);
  const toMs = (v: string) => (v.endsWith('ms') ? parseFloat(v) : parseFloat(v) * 1000);
  const durations = style.transitionDuration.split(',').map(toMs);
  const delays = style.transitionDelay.split(',').map(toMs);
  return Math.max(...durations.map((d, i) => d + (delays[i] ?? 0)), 0);
}

function reveal(el: Element) {
  el.classList.add('is-visible');
  if (!(el instanceof HTMLElement)) return;

  if (el.matches('[data-settle]')) {
    // Let the entrance finish, then let the content inside build in.
    const wait = reduceMotion.matches ? 0 : revealDuration(el) * 0.85;
    window.setTimeout(() => {
      el.classList.add('settled');
      ownedCounters(el).forEach(countUp);
    }, wait);
    return;
  }
  if (el.matches('[data-timeline]')) el.classList.add('is-drawn');
  ownedCounters(el).forEach(countUp);
}

/* ------------------------------------------------------------- card tilting */

/** Subtle 3D tilt (max ~2.5deg) towards the pointer on desktop. */
function initTilt() {
  if (!matchMedia('(hover: hover) and (pointer: fine)').matches || reduceMotion.matches) return;
  document.querySelectorAll<HTMLElement>('[data-tilt]').forEach((card) => {
    let frame = 0;
    let x = 0;
    let y = 0;
    const apply = () => {
      frame = 0;
      card.style.setProperty('--tilt-x', x.toFixed(3));
      card.style.setProperty('--tilt-y', y.toFixed(3));
    };
    card.addEventListener('pointermove', (event) => {
      const rect = card.getBoundingClientRect();
      x = ((event.clientX - rect.left) / rect.width) * 2 - 1;
      y = ((event.clientY - rect.top) / rect.height) * 2 - 1;
      if (!frame) frame = requestAnimationFrame(apply);
    });
    card.addEventListener('pointerleave', () => {
      x = 0;
      y = 0;
      if (!frame) frame = requestAnimationFrame(apply);
    });
  });
}

/* --------------------------------------------------------------------- init */

export function initMotion() {
  initTilt();

  const pending = new Set(document.querySelectorAll('[data-reveal], [data-timeline]'));
  if (pending.size === 0) return;

  const observer = new IntersectionObserver(
    (entries) => {
      for (const entry of entries) {
        // Also reveal anything already above the viewport (deep links,
        // restored scroll) so scrolling back up never finds gaps.
        if (entry.isIntersecting || entry.boundingClientRect.top < 0) {
          observer.unobserve(entry.target);
          pending.delete(entry.target);
          reveal(entry.target);
        }
      }
      if (pending.size === 0) detach();
    },
    { rootMargin: '0px 0px -8% 0px' },
  );
  pending.forEach((el) => observer.observe(el));

  // Content in the last few percent of a page can never pass the trigger
  // line; once the visitor reaches the bottom, show what is on screen.
  let frame = 0;
  const onScroll = () => {
    if (frame) return;
    frame = requestAnimationFrame(() => {
      frame = 0;
      const atBottom =
        window.innerHeight + window.scrollY >= document.documentElement.scrollHeight - 2;
      if (!atBottom) return;
      for (const el of pending) {
        if (el.getBoundingClientRect().top < window.innerHeight) {
          observer.unobserve(el);
          pending.delete(el);
          reveal(el);
        }
      }
      if (pending.size === 0) detach();
    });
  };
  const detach = () => window.removeEventListener('scroll', onScroll);
  window.addEventListener('scroll', onScroll, { passive: true });
}
