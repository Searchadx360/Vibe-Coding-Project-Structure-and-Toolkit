# docs/ — the catalog index site

A static, zero-build index site for browsing this repo's Claude Code
project workspaces by category — plugins, agents, skills, hooks, templates,
and full example setups. This folder is part of the main
[Vibe Coding Project Structure and Toolkit](../README.md) repo (kept under
`docs/` specifically so GitHub Pages can serve it with zero configuration).

## Structure

```
index.html          hero + live-searchable catalog of all 7 categories
workspaces.html      "what's a Claude Code project workspace?" explainer
marketplace.html     plugins marketplace explainer + bundle table
docs.html             curated jump-off points into the official docs
notes.html            devlog — replace with your own entries as you go
assets/style.css     design system (dark terminal/directory theme)
assets/main.js       renders category sections + drives the search filter
data/projects.js     the catalog itself — edit this to add/change entries
```

## Why plain HTML instead of Astro

This site is almost entirely static content (cards linking out to files in
this same repo), so a build step buys little here. Every page opens
directly from disk or any static host with no `npm install` required. If
you outgrow this — adding MDX content pages, per-project detail pages,
RSS, etc. — Astro is a reasonable next step; see
https://docs.astro.build for current setup and deployment guides.

## Editing the catalog

Everything the catalog renders lives in `data/projects.js`. Add an entry to
the `PROJECTS` array (or a new category to `CATEGORIES`) and it appears on
`index.html` automatically — no other file needs to change.

## Deploying

Since this lives at `docs/` in the repo root, GitHub Pages can serve it
with no extra folder or branch juggling:

1. Repo Settings → Pages → Source → "Deploy from a branch".
2. Branch: `main` (or your default), folder: `/docs`.
3. The site publishes at `https://<org>.github.io/<repo>/`.

Other static hosts work too, with publish directory set to `docs`:
Netlify, Vercel, or just `python3 -m http.server` from inside this folder
for local preview — no build command needed either way.

Update `REPO_BASE` at the top of `data/projects.js` once you've forked or
renamed this repo, so every card link points at the right place.
