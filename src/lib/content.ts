import { getCollection, getEntry, type CollectionEntry } from 'astro:content';

export type Project = CollectionEntry<'projects'>;

export async function getProfile() {
  const entry = await getEntry('profile', 'me');
  if (!entry) throw new Error('src/content/profile.yaml needs an entry with id "me"');
  return entry.data;
}

export async function getExperience() {
  const items = await getCollection('experience');
  return items.map((e) => e.data).sort((a, b) => a.order - b.order);
}

export async function getSkills() {
  const items = await getCollection('skills');
  return items.map((e) => e.data).sort((a, b) => a.order - b.order);
}

export async function getProjects() {
  const items = await getCollection('projects');
  return items.sort(
    (a, b) => a.data.order - b.data.order || a.data.name.localeCompare(b.data.name),
  );
}

/** Site-root path; pass it through `url()` (Button does this itself). */
export const projectPath = (project: Project) => `/projects/${project.id}`;

export const platformLabel: Record<string, string> = {
  android: 'Android',
  ios: 'iOS',
  web: 'Web',
  macos: 'macOS',
  windows: 'Windows',
  linux: 'Linux',
};
