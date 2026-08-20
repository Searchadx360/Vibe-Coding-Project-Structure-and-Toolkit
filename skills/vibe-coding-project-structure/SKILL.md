---
name: Vibe Coding Project Structure
description: Scaffold and organize a repository for "vibe coding" with Claude Code — fast, AI-driven, low-friction sessions where the model does most of the typing. Use this skill whenever the user is starting a new project with Claude Code, asks how to structure a repo for AI-assisted development, wants a CLAUDE.md file, wants to set up a `.claude/` folder (agents, commands, skills, hooks, rules), asks about MCP config (`.mcp.json`), wants deterministic skill-triggering, or wants scheduled GitHub Actions for ongoing review/maintenance — even if they don't say "vibe coding" explicitly.
---

# Vibe Coding Project Structure (v3)

## Why this exists

"Vibe coding" means moving fast with an AI pair programmer and trusting it
with large chunks of implementation. That only works well if the
*repository itself* carries enough structure and context that the model
doesn't have to guess.

The core idea: **the repo is part of the prompt.** Every file Claude can
discover — CLAUDE.md, rules, commands, skills, hooks — is effectively
prepended to every conversation that happens in that repo. Bad AI output is
usually a symptom of a thin repo, not a weak model. Structure once, benefit
on every session after.

v3 adds four things v1 didn't have, all pulled from auditing real,
proven-out Claude Code repos (see
[../../research/ecosystem-tools-analysis.md](../../research/ecosystem-tools-analysis.md)
for the source audit): a **deterministic skill-triggering hook** instead of
hoping the model notices a skill exists, a **personal-override config**
pattern, **scheduled GitHub Actions** that make the repo self-maintaining,
and a documented **CLAUDE.md split** for when one file gets crowded.

## The structure

```
repo/
├── CLAUDE.md               # Project memory — mission, stack, architecture, style, testing
├── CLAUDE.local.md          # Personal notes — gitignored, never committed
├── CONTEXT.md               # (optional) human-authored narrative — why this project exists
├── .mcp.json                 # (optional) MCP server integrations for this repo
├── .gitignore                # includes CLAUDE.local.md, .claude/settings.local.json
└── .claude/
    ├── settings.json         # Hooks + tool permissions, shared/committed
    ├── settings.local.json   # Personal overrides — gitignored, never committed
    ├── rules/                # Durable coding standards
    ├── commands/             # Custom /slash-commands
    ├── skills/               # Auto-loaded domain knowledge, one folder per skill
    ├── agents/                # Specialized subagents
    └── hooks/
        ├── skill-eval.js      # Deterministic skill-suggestion hook (UserPromptSubmit)
        └── skill-rules.json   # Trigger rules the hook scores prompts against
```

Plus, optionally, `.github/workflows/` populated from
`assets/github-actions/` if the project wants the repo to review and
maintain itself on a schedule.

Not every project needs every piece on day one. Start with `CLAUDE.md` and
add the rest as friction shows up (see "When to reach for each piece"
below) — but the skill-eval hook, `settings.local.json`, and
`CLAUDE.local.md` are cheap enough that the bootstrap script sets them up
by default.

## Quick start

1. Run the bootstrap script:

   - macOS/Linux: `bash scripts/bootstrap.sh /path/to/project`
   - Windows: `pwsh scripts/bootstrap.ps1 -Path C:\path\to\project`

   Both are idempotent — safe to re-run, never overwrite existing files.
   Pass `--with-actions` to also drop the GitHub Actions templates into
   `.github/workflows/` (these cost real API dollars on a schedule — see
   [references/github-actions.md](references/github-actions.md) before
   turning them on). Pass `--with-context` to also create `CONTEXT.md`.

2. Fill in `CLAUDE.md` using
   [references/claude-md-template.md](references/claude-md-template.md).
   If the project has a distinct "why we're building this" narrative worth
   keeping separate from operating instructions, use `CONTEXT.md` too — see
   the same reference for when a split beats one file.

3. Fill in `.claude/hooks/skill-rules.json` with real trigger rules for
   whatever skills/rules you actually add — see
   [references/skill-eval-hook.md](references/skill-eval-hook.md) for the
   scoring mechanism and schema. This is what makes skill triggering
   deterministic instead of a coin-flip on whether the model reads the
   description carefully enough.

4. Decide which of `.claude/agents/`, `.claude/commands/`, `.claude/skills/`
   you actually need — read
   [references/choosing-a-mechanism.md](references/choosing-a-mechanism.md).

5. Wire up `.mcp.json` for external tools and, if useful,
   `enabledPlugins` for language-server integration — see
   [references/mcp-and-settings.md](references/mcp-and-settings.md).

6. If the project should maintain itself over time — auto-review PRs,
   catch doc drift, sweep for quality, audit dependencies — turn on the
   GitHub Actions templates. See
   [references/github-actions.md](references/github-actions.md) for what
   each one does and roughly what it costs.

## When to reach for each piece

| Symptom | Reach for | Why |
|---|---|---|
| You keep re-explaining the same background every session | `CLAUDE.md` | It's the one file always in context |
| CLAUDE.md is getting long with narrative/motivation mixed into operating instructions | `CONTEXT.md` split | Keeps "why this exists" separate from "how to operate here" — see [references/claude-md-template.md](references/claude-md-template.md) |
| You keep pasting the same multi-step instruction | `.claude/commands/` | Turns a paragraph into `/your-command` |
| A whole class of task needs specialized, narrow focus | `.claude/agents/` | Runs as a subagent, doesn't bloat the main conversation |
| Knowledge only matters for *some* tasks | `.claude/skills/` | Loaded conditionally, keeps everyday prompts lean |
| You've added skills/rules but the model doesn't reliably notice them | `.claude/hooks/skill-eval.js` | Deterministic scoring beats hoping the model reads every description carefully — see [references/skill-eval-hook.md](references/skill-eval-hook.md) |
| You want to *prevent* something automatically, not just ask nicely | `.claude/hooks/` | A hook can't be talked out of blocking a bad command the way prose can |
| Two people work on this repo and want their own tool permissions/env tweaks | `.claude/settings.local.json` | Personal overrides, gitignored, never fights with the shared config |
| You have a personal note, override, or half-formed idea that isn't team consensus yet | `CLAUDE.local.md` | The `CLAUDE.md`-level counterpart to `settings.local.json` — gitignored, yours alone |
| Nobody's watching PRs/docs/dependencies between sessions | `.github/workflows/` templates | Turns the repo from reactive to self-maintaining — see [references/github-actions.md](references/github-actions.md) |
| More than one agent/task needs to touch this repo at once | Git worktree per task | Isolation prevents collisions — see [references/advanced-patterns.md](references/advanced-patterns.md) |
| A standing style/process rule that should never be skipped | `.claude/rules/` | Durable, narrow, survives CLAUDE.md rewrites |

## Principles worth keeping in mind

- **The repo is part of the prompt.** Before blaming a bad AI response,
  check what context, rules, and guardrails were actually available.
- **Deterministic beats hopeful.** A hook that scores and suggests is more
  reliable than an instruction that relies on the model happening to read
  it at the right moment.
- **Modular over monolithic.** A short CLAUDE.md plus narrowly-scoped
  rules/skills/agents ages better than one file trying to cover everything.
- **Secrets stay out of version control.** `.mcp.json` and
  `.claude/settings.json` are meant to be committed; use `${ENV_VAR}`
  expansion for anything sensitive. Personal tweaks go in
  `.claude/settings.local.json` and `CLAUDE.local.md`, both gitignored.
- **Automation that costs money should be opt-in and documented.** The
  GitHub Actions templates are genuinely useful but aren't free — see the
  cost ranges before enabling them on a schedule.
- **Add structure when friction shows up, not speculatively.**

## Reference files

- [references/claude-md-template.md](references/claude-md-template.md) — annotated `CLAUDE.md` template, plus when/how to split off `CONTEXT.md`
- [references/choosing-a-mechanism.md](references/choosing-a-mechanism.md) — rules vs commands vs skills vs agents vs hooks, with examples
- [references/mcp-and-settings.md](references/mcp-and-settings.md) — `.mcp.json`, `.claude/settings.json` / `settings.local.json`, hook lifecycle events, LSP wiring
- [references/skill-eval-hook.md](references/skill-eval-hook.md) — the deterministic skill-triggering hook: scoring mechanism, `skill-rules.json` schema, how to wire it in
- [references/github-actions.md](references/github-actions.md) — the four scheduled/triggered workflow templates, what each solves, rough cost per run
- [references/advanced-patterns.md](references/advanced-patterns.md) — worktree isolation for parallel agents, context-budget awareness, and other advanced/optional patterns worth knowing about but out of scope for the base scaffold

## Bundled files

- `scripts/bootstrap.sh` / `scripts/bootstrap.ps1` — idempotent scaffolder with `--with-actions` and `--with-context` flags
- `assets/CLAUDE.md.template`, `assets/CLAUDE.local.md.template`, `assets/CONTEXT.md.template` — starter project memory files, shared/personal/narrative
- `assets/settings.json.template`, `assets/settings.local.json.template` — starter Claude Code config, shared and personal
- `assets/mcp.json.template` — starter MCP server config
- `assets/gitignore.append.txt` — the lines to add to `.gitignore` for `settings.local.json` and `CLAUDE.local.md`
- `assets/hooks/skill-eval.js`, `assets/hooks/skill-rules.json.template` — the deterministic skill-suggestion hook and its rule schema
- `assets/github-actions/*.yml` — the four review/maintenance workflow templates
