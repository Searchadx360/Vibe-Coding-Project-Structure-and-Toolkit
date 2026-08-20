# CLAUDE.md template — and when to split it

`CLAUDE.md` lives at the repo root. It is the one file that's effectively
always in context, so keep it short, concrete, and stable — things that
change every week (current sprint, active bug) belong in an issue tracker or
a scratch note, not here.

## The template

Copy the block below into a new project's `CLAUDE.md` and replace every
`<placeholder>`. Delete sections that genuinely don't apply — an empty
"Deployment" heading with nothing under it is worse than no heading.

```markdown
# <Project name>

## What this is

<One or two sentences: what the project does and who it's for. Not a mission
statement — a factual description someone could use to decide if this repo
is relevant to their task.>

## Stack

- Language/runtime: <e.g. TypeScript, Node 20>
- Framework: <e.g. Next.js 14, App Router>
- Database: <e.g. Postgres via Prisma>
- Package manager: <e.g. pnpm>
- Other load-bearing dependencies worth naming: <...>

## Key commands

- Install: `<command>`
- Dev server: `<command>`
- Run tests: `<command>`
- Lint / format: `<command>`
- Build: `<command>`

## Architecture notes

<Point at the load-bearing structure, not a full tour.>

## Testing expectations

<What "done" means for a change.>

## Style and conventions

<Only things not already enforced by a linter/formatter.>

## Things to avoid

<Concrete, project-specific gotchas.>
```

## When to split CLAUDE.md

A pattern that shows up repeatedly across real Claude Code setups: once
`CLAUDE.md` starts trying to serve two different jobs at once — "here's the
operating spec" and "here's the human story of why this project exists" —
it gets worse at both. Splitting fixes that:

- **`CONTEXT.md`** — human-authored narrative: why this project exists, who
  it's for, what tradeoffs got made and why. `CLAUDE.md` stays the
  machine-oriented operating spec (stack, commands, conventions);
  `CONTEXT.md` carries the "in the founder's/lead's own words" background
  that's genuinely useful but would make `CLAUDE.md` longer without making
  it more actionable.
- **Audience-specific variants** — if the same repo is read by both
  contributors and end-users of a generated CLAUDE.md-driven tool, keep a
  developer-facing file separate from an end-user-facing one rather than
  writing one file that hedges for both audiences.
- **Public vs. private, project-wide split** — if a repo is public but has
  internal-only operational detail (staging URLs, internal escalation
  paths, anything that shouldn't be in git history) that the *whole team*
  needs, keep that in a file excluded via `.gitignore` rather than writing
  around it in the public `CLAUDE.md`.
- **`CLAUDE.local.md`** — the personal, single-developer version of the
  split above: notes that are real and useful to *you* but aren't team
  consensus yet, or are specific to your machine (a local port override, a
  half-formed convention you haven't proposed, a reminder about something
  you're mid-way through). Gitignored, never committed. This is the
  `CLAUDE.md`-level counterpart to `.claude/settings.local.json` — same
  reasoning, different file. The bootstrap script creates this by default
  since it's cheap and has no downside once it's gitignored. See
  `assets/CLAUDE.local.md.template`. The distinction from the two patterns
  above: `CONTEXT.md` is committed and for everyone; the private split
  above is committed-elsewhere and for the whole team; `CLAUDE.local.md` is
  never committed and is just for you.

Use `assets/CONTEXT.md.template` as the starting point if you decide you
need the `CONTEXT.md` split. Don't create it speculatively — most projects
are fine with `CLAUDE.md` alone; add the split the first time you notice
yourself writing "why we're doing this" prose inside what should be a
terse operating file. `CLAUDE.local.md` is different — it's cheap enough
that there's no real reason to wait, which is why it's created by default.

## What makes a good CLAUDE.md

- **Concrete over aspirational.** "Run `npm test` before finishing a task"
  is useful. "Write good tests" is not — it tells the model nothing it
  didn't already know.
- **Stable over current.** This file should barely need to change week to
  week. If you're editing it to reflect "what we're working on this
  sprint," that content belongs somewhere else.
- **Short over exhaustive.** If a section is getting long and narrow (e.g.
  deep conventions for one subsystem), move it into `.claude/rules/` or
  `.claude/skills/` and link to it instead of inlining it. See
  [choosing-a-mechanism.md](choosing-a-mechanism.md).
