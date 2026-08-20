# Vibe Coding Project Structure

A Claude Code [skill](https://docs.claude.com/en/docs/claude-code/skills) that
gives you a repeatable, opinionated project layout for "vibe coding" — fast,
AI-driven development sessions where the model does most of the typing.

Core idea: **the repo is part of the prompt.** Structure the repository once
and every session after benefits from it, instead of re-explaining context
every time.

This is the flagship entry in this repo's [`skills/`](../) catalog — the
one piece here designed to be copied whole into *another* project's
`.claude/skills/`, rather than browsed as a reference. Everything else in
[`Vibe Coding Project Structure and Toolkit`](../../README.md) (the
plugins, the other catalog entries, `examples/js-project-starter/`, the
`docs/` index site) either builds on top of this skill's ideas or is a
separate, standalone piece of the same toolkit.

## What this includes

Built by auditing four real Claude Code repos/guides down to their actual
mechanisms (see
[`../../research/ecosystem-tools-analysis.md`](../../research/ecosystem-tools-analysis.md)
for the full source-by-source audit) and keeping what's proven, not just
plausible:

- **A deterministic skill-triggering hook** (`skill-eval.js` +
  `skill-rules.json`) — scores prompts against explicit trigger rules
  instead of hoping the model notices a skill exists.
- **`.claude/settings.local.json` and `CLAUDE.local.md`** — gitignored
  personal overrides, so individual tweaks don't force a choice between
  "commit it for everyone" and "don't have it."
- **GitHub Actions templates** — PR review, monthly docs-sync, weekly
  quality sweep, biweekly dependency audit — opt-in via `--with-actions`,
  cost ranges documented.
- **A documented CLAUDE.md split** — an optional `CONTEXT.md` for
  human-authored narrative, kept separate from the terse operating spec.
- **LSP wiring and worktree-isolation guidance** for parallel-agent setups
  and IDE-grade diagnostics, documented as advanced/optional patterns.

The other two flagship deliverables the research doc called for — a
curated marketplace/toolkit repo, and a fully working JS showcase example
— are the rest of this repo:
[`examples/js-project-starter/`](../../examples/js-project-starter) for the
JS showcase, and everything at the repo root (`plugins/`, `agents/`,
`commands/`, `hooks/`, `rules/`, `templates/`, `mcp/`) for the toolkit.
This folder doesn't duplicate that work — it's the enhanced core skill
those deliverables build on top of.

## What's here

- [SKILL.md](SKILL.md) — the skill itself
- `references/` — deep-dive docs: CLAUDE.md template + split guidance, the
  mechanism-choice decision guide, MCP/settings/LSP config, the skill-eval
  hook, GitHub Actions templates, and advanced/optional patterns
- `scripts/bootstrap.sh` / `scripts/bootstrap.ps1` — idempotent scaffolder
  with `--with-actions` / `--with-context` flags
- `assets/` — every template and script the bootstrap script installs

## Using it

**As a Claude Code skill:** drop this folder into a project's
`.claude/skills/` directory. Claude pulls it in automatically when a
conversation looks like it's about setting up or structuring a project for
AI-assisted development.

**Standalone:**

```bash
bash scripts/bootstrap.sh /path/to/project --with-context
```

```powershell
pwsh scripts/bootstrap.ps1 -Path C:\path\to\project -WithContext
```

Add `--with-actions` / `-WithActions` once you're ready to enable the
scheduled GitHub Actions (read `references/github-actions.md` first — they
cost real API money on a schedule). Both scripts are safe to re-run.

## Sources

This structure synthesizes conventions documented across:

- [rajaashok's Claude Code project structure guide](https://rajaashok.github.io/claude-code-project-structure)
- [ChrisWiles/claude-code-showcase](https://github.com/ChrisWiles/claude-code-showcase)
- [danielrosehill/Claude-Code-Projects-Index](https://github.com/danielrosehill/Claude-Code-Projects-Index)
- [rohitg00/awesome-claude-code-toolkit](https://github.com/rohitg00/awesome-claude-code-toolkit)

Full audit, including two build briefs cross-checked against what those
repos actually shipped, in
[`../../research/ecosystem-tools-analysis.md`](../../research/ecosystem-tools-analysis.md).

## License

MIT — use, adapt, and redistribute freely.
