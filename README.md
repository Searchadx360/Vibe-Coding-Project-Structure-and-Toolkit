# Vibe Coding Project Structure and Toolkit

A curated, browsable marketplace of Claude Code agents, skills, commands,
hooks, rules, templates, MCP configs, plugins, and example workflows —
built like an awesome list, but every piece is also a working
[Claude Code plugin](https://code.claude.com/docs/en/plugins) you can
install with one command.

If you've ever gone hunting across ten different GitHub repos for a decent
`code-reviewer` subagent or a hook that blocks edits on `main`, this repo is
meant to save you that hunt.

## Start here: the flagship skill

[`skills/vibe-coding-project-structure/`](skills/vibe-coding-project-structure)
is the one piece in this repo built to be copied whole into a *different*
project. Drop it into that project's `.claude/skills/`, or just run its
bootstrap script, and it scaffolds `CLAUDE.md`, a full `.claude/` layout
(rules/commands/skills/agents/hooks), a deterministic skill-triggering
hook, MCP config, and — opt-in — scheduled GitHub Actions for ongoing
review and maintenance:

```bash
bash skills/vibe-coding-project-structure/scripts/bootstrap.sh /path/to/your/project --with-context
```

Everything else below is the surrounding toolkit: standalone catalog
pieces you copy individually, plugin bundles you install as a unit, a full
worked JS/TS example, and a browsable index site.

## Quick install

**Option A — install everything as plugins** (recommended: gets updates automatically):

```
/plugin marketplace add Searchadx360/Vibe-Coding-Project-Structure-and-Toolkit
/plugin install review-suite@vibe-coding-toolkit
/plugin install safe-ops@vibe-coding-toolkit
/plugin install growth-ops@vibe-coding-toolkit
/plugin install mcp-connectors@vibe-coding-toolkit
```

Or run the interactive installer from your terminal:

```bash
curl -fsSL https://raw.githubusercontent.com/Searchadx360/Vibe-Coding-Project-Structure-and-Toolkit/main/scripts/install.sh | bash
```

**Option B — copy what you need into your own project** (no plugin system,
full control): browse a category below, copy the file(s) you want into
your project's `.claude/` directory, or run:

```bash
/path/to/vibe-coding-toolkit/scripts/setup.sh   # from your project root
```

This scaffolds a starter `.claude/` directory by copying a few catalog items
in — see [`scripts/setup.sh`](scripts/setup.sh) for exactly what it copies.

## What's in here

| Folder | What it is | Copy into |
| --- | --- | --- |
| [`plugins/`](plugins) | Bundled plugins — install directly, no copying | `/plugin install` |
| [`agents/`](agents) | Standalone subagent definitions | `.claude/agents/` |
| [`skills/`](skills) | Standalone `SKILL.md` files | `.claude/skills/` |
| [`commands/`](commands) | Flat `.md` slash commands | `.claude/commands/` |
| [`hooks/`](hooks) | Hook configs + the scripts they call | `.claude/settings.json` + `.claude/hooks/scripts/` |
| [`rules/`](rules) | Path-scoped `.claude/rules/` files | `.claude/rules/` |
| [`templates/`](templates) | `CLAUDE.md` and `settings.json` starting points | project root / `.claude/` |
| [`mcp/`](mcp) | An index of commonly used MCP server configs | `.mcp.json` |
| [`examples/`](examples) | A full worked project template + combined-tooling workflows | copy the whole folder |
| [`apps/`](apps) | Which Claude Code surface (CLI, Desktop, IDE, web, Actions) fits which task | reference only |
| [`docs/`](docs) | A browsable, searchable index site cataloging everything above | deploy via GitHub Pages, or open `docs/index.html` locally |
| [`research/`](research) | The source audit this repo was built from — four Claude Code repos/guides, mechanism by mechanism | reference only |

## Plugin bundles

| Plugin | What it bundles | Install |
| --- | --- | --- |
| [`review-suite`](plugins/review-suite) | `code-reviewer` + `security-auditor` agents, `quality-review` skill, format-on-save hook | `/plugin install review-suite@vibe-coding-toolkit` |
| [`growth-ops`](plugins/growth-ops) | `growth-analyst` agent, `campaign-brief` + `ad-copy-compliance` skills — a domain-expert example for marketing/growth work | `/plugin install growth-ops@vibe-coding-toolkit` |
| [`safe-ops`](plugins/safe-ops) | Hooks that block edits on protected branches/paths, plus an audit-log hook | `/plugin install safe-ops@vibe-coding-toolkit` |
| [`mcp-connectors`](plugins/mcp-connectors) | A starter `.mcp.json`: GitHub, Postgres, filesystem | `/plugin install mcp-connectors@vibe-coding-toolkit` |

## Agents

| Agent | Invoke for | Link |
| --- | --- | --- |
| `code-reviewer` | PR-style review of a diff | [`agents/code-reviewer.md`](agents/code-reviewer.md) |
| `debugger` | Root-causing a failing test or bug report | [`agents/debugger.md`](agents/debugger.md) |
| `data-scientist` | Ad-hoc SQL/analytics questions | [`agents/data-scientist.md`](agents/data-scientist.md) |
| `security-auditor` | Focused security pass on sensitive changes | [`plugins/review-suite/agents/security-auditor.md`](plugins/review-suite/agents/security-auditor.md) |
| `growth-analyst` | Campaign/funnel/channel analysis | [`plugins/growth-ops/agents/growth-analyst.md`](plugins/growth-ops/agents/growth-analyst.md) |

## Skills

| Skill | Does | Link |
| --- | --- | --- |
| `vibe-coding-project-structure` | **Flagship** — scaffolds a whole project's `.claude/` setup, see above | [`skills/vibe-coding-project-structure`](skills/vibe-coding-project-structure/SKILL.md) |
| `testing-patterns` | House testing conventions, applied automatically | [`skills/testing-patterns`](skills/testing-patterns/SKILL.md) |
| `schema-review` | Reviews schema/API changes for compatibility | [`skills/schema-review`](skills/schema-review/SKILL.md) |
| `commit-message-writer` | Conventional Commits message from staged changes | [`skills/commit-message-writer`](skills/commit-message-writer/SKILL.md) |
| `quality-review` | Quick pass over the current diff | [`plugins/review-suite/skills/quality-review`](plugins/review-suite/skills/quality-review/SKILL.md) |
| `campaign-brief` | Idea → structured creative/media brief | [`plugins/growth-ops/skills/campaign-brief`](plugins/growth-ops/skills/campaign-brief/SKILL.md) |
| `ad-copy-compliance` | Screens ad copy for policy risk | [`plugins/growth-ops/skills/ad-copy-compliance`](plugins/growth-ops/skills/ad-copy-compliance/SKILL.md) |

## Commands

| Command | Does | Link |
| --- | --- | --- |
| `ticket-to-pr` | Pulls a ticket, implements it, opens a PR | [`commands/ticket-to-pr.md`](commands/ticket-to-pr.md) |
| `release-notes` | Drafts release notes since the last tag | [`commands/release-notes.md`](commands/release-notes.md) |

## Hooks

| Hook | Event | Does | Link |
| --- | --- | --- | --- |
| `auto-format` | `PostToolUse` | Runs prettier/black/gofmt/rustfmt on the touched file | [`hooks/auto-format.hooks.json`](hooks/auto-format.hooks.json) |
| `block-protected-branch` | `PreToolUse` | Blocks edits on `main`/`master`/`production` | [`hooks/block-protected-branch.hooks.json`](hooks/block-protected-branch.hooks.json) |
| `run-tests-on-change` | `PostToolUse` (async) | Runs the matching test file after a source file changes | [`hooks/run-tests-on-change.hooks.json`](hooks/run-tests-on-change.hooks.json) |

## Rules, templates, and MCP configs

| Type | Link |
| --- | --- |
| Security + frontend style rules | [`rules/`](rules) |
| `CLAUDE.md` and `settings.json` templates | [`templates/`](templates) |
| Curated MCP server index | [`mcp/servers.json`](mcp/servers.json) |

## Example workflows

- [`examples/js-project-starter`](examples/js-project-starter) — a full
  Claude Code setup for a JS/TS repo: memory, hooks, skills, a subagent, a
  ticket-tracker command, MCP, and GitHub Actions, wired to a real (small)
  working app.
- [`examples/workflows/feature-to-pr.md`](examples/workflows/feature-to-pr.md) —
  how agents, commands, hooks, and rules combine on a normal feature ticket.
- [`examples/workflows/incident-triage.md`](examples/workflows/incident-triage.md) —
  the same, for a production bug report.

## Companion apps

Everything here works from the CLI, but also carries over to Claude
Desktop, the VS Code/JetBrains extensions, Claude Code on the web, and
GitHub Actions. See [`apps/README.md`](apps/README.md) for which surface
fits which kind of task.

## Catalog site

[`docs/`](docs) is a static, zero-build site that renders everything in
this catalog as searchable cards — sourced from
[`docs/data/projects.js`](docs/data/projects.js). Open `docs/index.html`
directly, or enable GitHub Pages on this repo with source folder `/docs`
to publish it. See [`docs/README.md`](docs/README.md) for details.

## Research behind this repo

[`research/ecosystem-tools-analysis.md`](research/ecosystem-tools-analysis.md)
is the source audit this whole toolkit was built from — four real Claude
Code repos/guides, broken down tool by tool: what each mechanism actually
does and what problem it solves, cross-checked against two build briefs to
confirm the patterns here are proven rather than speculative.

## Contributing

See [`CONTRIBUTING.md`](CONTRIBUTING.md). Short version: pick the right
folder, add a table row, keep instructions concrete, and run
`claude plugin validate .` before opening a PR.

## Keeping this current

This repo tracks the current Claude Code plugin/marketplace/hooks schema.
If something here looks out of date, the source of truth is:
https://code.claude.com/docs/en/overview

## If you fork this

This repo is wired up for `Searchadx360/Vibe-Coding-Project-Structure-and-Toolkit`
— install commands, `marketplace.json`, each `plugins/*/plugin.json`, and
the `docs/` site's `REPO_BASE` all point there. If you fork or rename it:

1. **Replace `Searchadx360/Vibe-Coding-Project-Structure-and-Toolkit`**
   with your own `<owner>/<repo>` everywhere it appears — a repo-wide
   search for `Searchadx360` finds every spot (this README, the
   `install.sh` script, `.claude-plugin/marketplace.json`, each
   `plugins/*/.claude-plugin/plugin.json`, and `docs/data/projects.js`'s
   `REPO_BASE`).
2. **Enable GitHub Pages** (Settings → Pages → source `/docs` on your
   default branch) if you want the catalog site live at your own URL.
3. **Run `claude plugin validate .`** from the repo root to catch any
   marketplace/plugin schema errors before your first PR.
4. **Decide what stays default-on.** The flagship skill's bootstrap script
   creates `settings.local.json` and `CLAUDE.local.md` by default (cheap,
   gitignored) but only installs the GitHub Actions templates behind
   `--with-actions` (they cost real API money on a schedule) — adjust in
   [`skills/vibe-coding-project-structure/scripts/`](skills/vibe-coding-project-structure/scripts)
   if you want different defaults.
5. **Update the copyright line in [`LICENSE`](LICENSE)** if you want your
   own name/org instead of "contributors."

## License

[MIT](LICENSE)
