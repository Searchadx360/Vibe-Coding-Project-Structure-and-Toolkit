# Claude Code Ecosystem: Tools, Workflows, and What They Actually Solve

Research pass across four sources, done to find concrete mechanisms worth
pulling into [Vibe Coding Project Structure](../skills/vibe-coding-project-structure/SKILL.md) rather than leaving
it as a generic "here's five folders" scaffold. Each section below covers one
source: the specific tool/workflow, how it mechanically works, and the real
problem it solves. A recommendations section at the end turns this into a
build list.

Section 0 folds in `project info.txt` — two explicit build briefs already on
file for two of these sources, which turns "here's what those repos do" into
"here's what we already decided to build, cross-checked against what those
repos actually shipped."

---

## 0. The build briefs already on file (`project info.txt`)

`project info.txt` (kept alongside this file) contains two fully-specified
briefs, each written against one of the reference repos, plus a bare "read
also" pointer to the third. These aren't just inspiration notes — they're
existing scope decisions. Auditing them against what the reference repos
actually shipped (sections 2 and 4 below) tells us whether the brief is
realistic and where the real repo fell short of its own ambition.

### Brief A — a companion marketplace/toolkit repo (modeled on source 4)

> Build me a public Claude Code toolkit repo that works like a big curated
> marketplace for power users. I want someone to be able to install it
> quickly, then browse useful agents, skills, slash commands, hooks, rules,
> templates, MCP configs, plugins, examples, and companion apps without
> hunting all over GitHub.
>
> Make it feel like an awesome list, but also usable as an actual Claude
> Code plugin. Include a clear README with quick install options, category
> tables, short descriptions, links, and contribution guidance. Organize
> everything into sensible folders so people can copy pieces into their own
> Claude setup. Add setup scripts where needed, sample configs, and a few
> example workflows that show how someone would combine agents, commands,
> hooks, and rules in real projects.
>
> Keep the tone practical and friendly. This should help developers discover
> better Claude Code workflows, improve safety, automate reviews, add domain
> experts, and connect external tools through MCP.

**Audit against what source 4 actually shipped:** almost every requested
piece is present in the real repo — agents/, skills/, commands/, hooks/,
rules/, templates/, mcp-configs/, plugins/, examples/ all exist as real
folders, and the install story (plugin-marketplace add / manual clone /
one-line curl installer) matches "install it quickly." The one category the
brief names that the real repo doesn't cleanly deliver is **"companion
apps"** — the closest thing is a generic `contexts/` folder, not a distinct,
browsable category. That gap is worth closing in our own version rather than
copying it forward. The brief's "example workflows that combine agents,
commands, hooks, and rules" is also *named* as a goal in the real repo's
README language but isn't enumerated with the same specificity as the
category directories — another place we can outdo the source rather than
just match it.

### Brief B — a working JS showcase example (modeled on source 2)

> Build me a Claude Code project setup example for a JavaScript repo,
> something I can drop into a real codebase and use as a template.
>
> I want the project to show how to set up Claude Code memory, hooks,
> skills, custom agents, slash commands, MCP integration, and GitHub Actions
> workflows for ongoing code review and maintenance. Include a clear
> Claude.md file with project guidance, a few example skills like testing
> and schema patterns, a code review agent, and a ticket workflow command
> that connects to an issue tracker. Also add hook logic that can auto
> format, run checks when files change, suggest the right skill from the
> prompt, and block risky edits on main.
>
> Make it feel like a complete working showcase, not just placeholder
> files... I'd like the result to be easy to copy into another repo and
> understand at a glance.

**Audit against what source 2 actually shipped:** this brief is fully
realized in the real repo, mechanism for mechanism — `CLAUDE.md` (memory),
the skill-eval hook (*"suggest the right skill from the prompt"*), the
`PreToolUse` branch-guard hook (*"block risky edits on main"*), the
`PostToolUse` formatter/test hook (*"auto format, run checks when files
change"*), `testing-patterns`/`graphql-schema` skills, the `code-reviewer`
agent, the `ticket` command wired to Jira/Linear, `.mcp.json`, and four
scheduled/triggered GitHub Actions. Nothing in the brief was left
unaddressed. That's a strong signal: this isn't one plausible design among
many, it's a proven, complete pattern — which is exactly why section 2's
findings carry the most weight in the recommendations below.

### Brief C — read-also, no build brief (source 1)

`project info.txt` only points at rajaashok's guide as background reading,
with no construction ask attached. Nothing to audit here beyond what
section 1 already covers — it's the philosophy layer underneath both
briefs, not a third deliverable.

**What this changes:** the recommendations at the end of this file are no
longer just "worth considering." Sections 5 and 6 below split them into two
flagship deliverables that are *already scoped and validated* (the
marketplace repo and the JS showcase) plus the smaller enhancements that
feed the core skill itself.

---

## 1. rajaashok — Claude Code Project Structure guide

High-level philosophy source. Fewer mechanisms, but the framing is the
backbone of this whole skill.

| Tool / Practice | Mechanism | Problem it solves |
|---|---|---|
| `CLAUDE.md` | Root file, always loaded, documents mission/stack/architecture/testing/style | Stops every session from re-explaining the same baseline context |
| `.claude/` as "hidden behavior workspace" | Folder of modular instruction pieces instead of one giant file | One monolithic prompt file rots and becomes unreadable; modular pieces can be edited independently |
| `rules/` | Durable standards files | Gives the model something it can actually check itself against, not vague prose like "write good code" |
| `commands/` | Named, repeatable slash sequences | Converts a fuzzy multi-step request into a known, consistent sequence — "inspect → edit → test → summarize" |
| `skills/` | Conditionally-loaded context | Keeps every prompt lean — DB context only loads for DB work, design context only for design work |
| `agents/` | Narrow-focus workers (reviewer, tester, migration planner, docs, security, perf) | A generalist model spreads attention; a narrow-focus agent doesn't |
| `hooks/` | Event-triggered scripts | Turns "trust the model to behave" into "verify it can't misbehave" |
| **Repo-as-prompt principle** | Treating file placement/structure itself as instruction | Reframes bad AI output as an environment problem first, a model-capability problem second — before blaming the model, check what context/rules/guardrails actually existed |
| **Diff-review discipline** | Apply human PR-review rigor to AI output | Replaces "I trust the output" with "I inspected the diff and confirmed what it changed" |

**Takeaway for this repo:** the five-folder structure and the "repo is part
of the prompt" framing this skill already has are correct and match the
canonical source. What's missing is the diff-review discipline as an
explicit practice, and treating `rules/` as separate from and more durable
than `CLAUDE.md` guidance (a rule should survive rewrites of CLAUDE.md).

---

## 2. ChrisWiles/claude-code-showcase — the most implementation-dense source

This is where the actual file shapes, JSON schemas, and working examples
live. Everything here is directly liftable.

### Config files

| File | Mechanism | Problem it solves |
|---|---|---|
| `.claude/settings.json` | JSON: `hooks`, env, `enableAllProjectMcpServers`, `enabledPlugins` | Central control point for automation + permissions, not scattered across scripts |
| `.claude/settings.local.json` | Same shape, gitignored | Personal overrides (a dev's own API keys, a looser permission set) without polluting the shared config |
| `.claude/settings.md` | Human-readable prose mirror of settings.json | Settings.json is not self-documenting; someone has to be able to read *why* a hook exists without parsing JSON |
| `.mcp.json` | `mcpServers` map, stdio or http type, `${ENV_VAR}` expansion | Lets Claude read/write Jira, Linear, GitHub, Slack, Postgres, Sentry, etc. without hardcoding credentials |

### Hooks (the concrete, working version of the concept)

| Event | Trigger | Real example given |
|---|---|---|
| `PreToolUse` | Before a tool runs | Block `Edit`/`Write` if `git branch --show-current` != a feature branch — exit code `2` = hard block |
| `PostToolUse` | After a tool completes | Auto-run formatter/linter/tests on the changed file |
| `UserPromptSubmit` | On prompt submission | Skill-eval hook (see below) |
| `Stop` | Model about to stop | Gate on "tests must pass first" |

Hook response shape: `{ "block": true, "message": "...", "feedback": "..." }`.
This is more precise than a vague "hooks can block things" — it's an actual
contract a script can implement.

**Skill-evaluation hook** (`skill-eval.sh` / `.js` + `skill-rules.json`) —
this is the single most valuable mechanism in this source and isn't in the
current skill at all:

- Runs on `UserPromptSubmit`.
- Scores the prompt against each skill's trigger rules: keyword match (2
  pts), keyword regex (3 pts), file-path pattern (4 pts), directory mapping
  (5 pts), intent-phrase regex (4 pts).
- Outputs a ranked list of skills the prompt probably needs, with an
  `excludePatterns` field to suppress false positives (e.g. don't suggest
  the unit-test skill for an e2e-test prompt).
- **Problem it solves:** skill triggering today depends entirely on the
  model reading a description and deciding to consult it. That's a
  probabilistic step. A deterministic scoring hook removes the guesswork —
  it's the difference between "hoping the model notices" and "the repo
  telling it."

### LSP integration

- `enabledPlugins` in settings.json turns on `typescript-lsp`, `pyright-lsp`,
  etc.
- **Problem it solves:** without this, "does this type-check" is something
  the model has to simulate from reading code. With a real language server
  wired in, it gets actual diagnostics, hover info, and go-to-definition —
  IDE-grade ground truth instead of guesswork.

### Skills, agents, commands (concrete instances, not just the concept)

- Skills seen: `testing-patterns`, `systematic-debugging`, `react-ui-patterns`,
  `graphql-schema`, `core-components`, `formik-patterns` — each a
  `SKILL.md` with `name`, `description`, `allowed-tools`, `model` in
  frontmatter.
- Agents seen: `code-reviewer` (checklist: no `any`, error handling, tests,
  loading states, mutation patterns — runs after every write) and
  `github-workflow` (branch/commit/PR standardization).
- Commands seen: `onboard` (context-gathering), `ticket` (read → implement →
  update ticket status against Jira/Linear), `pr-review`, `pr-summary`,
  `code-quality`, `docs-sync`.
- **Problem each solves**, in one line each: consistent review quality
  without a human always available; standardized git hygiene; ticket status
  that doesn't silently drift from actual work; PR descriptions that don't
  have to be hand-written every time; docs that don't quietly rot.

### GitHub Actions — turning the repo into an autonomous operator, not just a scaffold

| Workflow | Trigger | Problem it solves | Rough cost |
|---|---|---|---|
| `pr-claude-code-review.yml` | PR opened/synced/reopened, or `@claude` comment | Removes the wait for a human reviewer to be free | $0.05–0.50/PR |
| `scheduled-claude-code-docs-sync.yml` | Monthly | Docs silently drifting from code | $0.50–2/mo |
| `scheduled-claude-code-quality.yml` | Weekly | Nobody proactively reviews code that never got a PR-triggered look | $1–5/wk |
| `scheduled-claude-code-dependency-audit.yml` | Biweekly | Dependency bumps that break things, caught by running the test suite as part of the bump instead of after |  $0.20–1/cycle |

**Takeaway for this repo:** the skill currently stops at "here's the
folders, fill them in as needed." This source shows the next tier: a
deterministic skill-triggering hook, LSP wiring, and scheduled GitHub
Actions that make the repo self-maintaining instead of only reactive. All
four are concrete enough to ship as templates, not just advice.

---

## 3. danielrosehill/Claude-Code-Projects-Index — breadth, not depth

This is a personal catalog of 75+ small Claude Code plugins/templates across
wildly different domains (sysadmin, legal, media, home automation, regional
localization). Most entries are outside the scope of a general project
scaffold, but a handful of patterns recur across many entries and are worth
extracting on their own:

| Pattern (seen across multiple entries) | Mechanism | Problem it solves |
|---|---|---|
| **Split CLAUDE.md** (`Split Claude MD Pattern`, `ClaudeMD Turnstile`) | One directive file plus separate on-demand context files; a distinct dev-facing vs. end-user-facing CLAUDE.md | A single CLAUDE.md trying to serve every audience/task gets long and generic; splitting by audience or by "always load" vs "load on demand" keeps each part sharp |
| **CONTEXT.md** | Separate file for human-authored narrative context vs. AI-structured instructions | Keeps "why this project exists, in the founder's own words" distinct from "here's the machine-readable operating spec" — both matter, but conflating them makes CLAUDE.md worse at both jobs |
| **Private and Public CLAUDE.md** | Git-aware split so sensitive operational detail isn't committed | Repos published publicly still want rich CLAUDE.md content; secrets/internal-only detail needs a path that isn't in the commit history |
| **Repo-type CLAUDE.md templates** (`Claude Code Repo Managers ClaudeMD`, `Batch ClaudeMD Repo Creator`) | Pre-built CLAUDE.md templates per repo archetype (library, service, CLI tool, etc.), applied in batch | Writing a good CLAUDE.md from scratch every time is friction; a per-archetype starting template removes the blank-page problem |
| **Context budget analysis** (`Claude Context Analysis`) | Tooling that measures how much of the context window fixed instructions actually consume | You can't tell if your `.claude/` setup is bloated without measuring it — this turns "keep it lean" from a vibe into a number |
| **MCP catalog / installer pattern** (`Claude Code MCP List`, `Smithery MCP Jumpstarter`, `Meta MCP Slash`) | A curated, categorized list of MCP servers plus a `/install-mcp`-style command that installs the right one interactively | Discovering and correctly configuring the right MCP server for a task is its own research project; a curated installer collapses that to a menu choice |
| **Agent Workspace Generator** | Standardized template + validation for creating a new agent definition | New agents drift in format/quality without a generator enforcing the shape |
| **Parallel agent orchestration via LAN/relay** (`Agent Junction`, `Claude Agent Relay Plugin`) | Direct machine-to-machine agent communication | For multi-machine setups, agents need a way to hand off work without a human relaying messages |

**Takeaway for this repo:** most of this index is domain-specific plugins
outside scope. The generalizable pattern worth adopting is **CLAUDE.md
should be allowed to split** — a small root file plus optional
`CONTEXT.md` / audience-specific variants / per-repo-type templates — rather
than insisting on one file that grows to cover everything. This directly
extends the current `assets/CLAUDE.md.template`.

---

## 4. rohitg00/awesome-claude-code-toolkit — the systems that treat Claude Code as an org, not a tool

This is a meta-directory of large, popular plugin ecosystems. The value here
isn't the raw category counts — it's the specific mechanisms these
high-star projects converged on independently, which is a signal about what
actually matters at scale.

| Project | Mechanism | Problem it solves |
|---|---|---|
| **pro-workflow** | Self-correcting memory + parallel git worktrees + 8 hook types + 5 agents | Long sessions lose the plot; parallel worktrees let independent work happen without one branch blocking another |
| **gstack** (68k★) | 6 tools modeling org roles: CEO / Eng Manager / Release Manager / QA | Single-perspective review misses things a second role would catch — this forces multiple review lenses without needing multiple humans |
| **great_cto** | 7 role agents + 12-angle code review + 13 compliance frameworks (SOC2, HIPAA, PCI-DSS, GDPR, ...) | Regulated codebases need compliance checks that a generic reviewer won't know to run |
| **claude-mem** (36k★) | Auto-captures session actions, compresses with AI, stores in SQLite with full-text search, re-injects on demand | Context resets between sessions lose everything; this gives Claude Code persistent memory without keeping the whole history in the prompt |
| **claude-ops** | Morning briefings, unified inbox, autonomous PR merge, infra monitoring | Turns Claude Code from "a tool you open" into "a standing process watching things for you" |
| **vibe-kanban** (23k★) | Kanban board orchestrating 10+ coding agents, each in an isolated git worktree, with inline diff review | Running multiple agents on the same repo at once causes collisions; isolated worktrees plus a review gate before merge solves that directly |
| **wshobson/agents** (31k★) | 112 specialized agents + 16 workflow orchestrators + 146 skills | At a large enough project, one general agent can't hold every domain's conventions — this is what "agents/" scales into |
| **oh-my-claudecode** (10k★) | 19 agents + 28 skills + Socratic questioning between agents | Multi-agent setups can just parallelize the same mistake; making agents interrogate each other's reasoning catches that |
| **ccpm** (7.6k★) | GitHub Issues + git worktrees for parallel epic execution | Large features decomposed into issues, each executed in its own worktree, so "epic" work doesn't block on a single linear branch |
| **knowledge-graph plugin** | Semantic retrieval with PostgreSQL + pgvector, no fixed token overhead | Vector-searchable long-term memory that doesn't cost context budget just by existing |
| **codebase-graph MCP** | Tree-sitter AST parsing across 42 languages via FalkorDB | Structural, queryable understanding of a codebase instead of re-reading files every time |

**Takeaway for this repo:** the pattern that shows up in every high-star
project here is **isolation + a review gate** for parallel work (worktrees
per agent/task, diff review before merge) and **persistent memory that
doesn't cost context** (claude-mem's SQLite approach, the knowledge-graph
plugin's pgvector approach). Neither of those exists yet in this skill —
today's structure assumes one agent, one worktree, one session at a time.

---

## 5. Flagship deliverables — already scoped, now cross-validated

These two are called for explicitly in `project info.txt`, and the audit in
section 0 confirms both briefs are realistic — the reference repos actually
shipped everything asked for (with one gap each, noted below as the chance
to go further than the source did).

### A. A companion marketplace/toolkit repo, sitting alongside this skill

A separate repo (or a `toolkit/` top-level folder if kept in one repo) that
does for the whole Claude Code ecosystem what this skill does for project
structure: curated, browsable, installable. Scope, directly from the brief
plus the audit:

- Folders matching the brief's categories: `agents/`, `skills/`,
  `commands/`, `hooks/`, `rules/`, `templates/`, `mcp-configs/`, `plugins/`,
  `examples/` — each with a short README and a category table (name,
  one-line description, link).
- A real **"companion apps" category**, called for in the brief but not
  cleanly delivered by source 4 (it only has a generic `contexts/` folder).
  This is a concrete way to differentiate rather than clone.
- A handful of **named, worked example workflows** showing an agent + a
  command + a hook + a rule composed together on one realistic task (e.g.
  "PR lands → hook checks branch → agent reviews → command posts summary →
  rule enforces the checklist"). Source 4 names this as a goal but doesn't
  enumerate specific combined examples with the same rigor as its category
  folders — enumerating 3–5 concretely is an easy win.
- Root README with quick-install options (manual copy, a one-liner script,
  and — if this ships as an actual Claude Code plugin — a plugin-marketplace
  entry), category tables, and a contribution guide.
- Tone: practical and friendly, per the brief — short descriptions over
  marketing copy, working links over aspirational placeholders.

### B. A working JavaScript showcase repo, using this skill's own scaffold

A real, runnable example project (not a doc) that drops the
`Vibe Coding Project Structure` output into an actual JS codebase and shows
every mechanism working together. Scope, directly from the brief:

- `CLAUDE.md` with real project guidance (not `<placeholder>` text).
- Two or three example skills (a testing-patterns skill and a schema/data
  skill are the ones the brief names and source 2 proves out).
- A `code-reviewer` agent with a concrete checklist.
- A `ticket` command wired to a real or mocked issue tracker (read →
  implement → update status).
- Hooks covering all four events with working scripts: `PostToolUse`
  auto-format/test-on-save, `PreToolUse` block-edits-on-main, a
  `UserPromptSubmit` skill-suggestion hook, and a `Stop` gate.
- `.mcp.json` wired to at least one real MCP server.
- One working GitHub Actions workflow (PR review is the highest-leverage
  single one to include).
- Written so it's "easy to copy into another repo and understand at a
  glance" — per the brief, this means favoring a small number of fully
  working examples over a large number of stubs.

Building B is also the fastest way to pressure-test this skill's own
`scripts/bootstrap.sh` and templates — if the showcase is awkward to build
from them, the scaffold needs fixing before either deliverable ships.

---

## 6. Core skill enhancements — ranked

Smaller, targeted upgrades to `Vibe Coding Project Structure` itself, not
full companion repos. Ranked by leverage — how much problem-solving power
per unit of added complexity:

1. **Ship a skill-eval hook template** (from source 2, validated by brief
   B). The biggest single upgrade available: it turns skill/rule triggering
   from "the model might notice" into "the repo scores and tells it."
   Concrete, small, directly copyable.
2. **Add `settings.local.json` to the bootstrap output** (gitignored,
   documented in the README) so personal overrides don't force a choice
   between "commit your own tweaks" and "don't have any."
3. **Add GitHub Actions templates** for PR review, scheduled docs-sync,
   scheduled quality sweep, and dependency audit (from source 2, validated
   by brief B) as an optional `github-actions/` folder in `assets/` — with
   the cost ranges documented so people know what they're opting into.
4. **Let CLAUDE.md split** (from source 3): document the option of a root
   `CLAUDE.md` plus an optional `CONTEXT.md` (human narrative) and
   audience-specific variants, instead of implying one file must cover
   everything.
5. **Document the worktree-isolation pattern** (from source 4) as the
   answer to "what do I do when I want more than one agent working on this
   repo at once" — isolated worktree per task/agent, diff review before
   merge, rather than everyone on one branch.
6. **Add an LSP wiring note** (from source 2) to `mcp-and-settings.md` —
   `enabledPlugins` for `typescript-lsp`/`pyright-lsp` is a one-line addition
   with an outsized accuracy payoff and currently isn't mentioned at all.
7. **Note the context-budget-measurement idea** (from source 3) as a
   "how do I know if my `.claude/` setup is bloated" tip — even without
   building tooling for it, naming the concept is useful.
8. Treat **claude-mem-style persistent memory** and **MCP catalog/installer
   patterns** as "advanced, optional" call-outs rather than core structure —
   high value for power users, but out of scope for the base scaffold this
   skill provides.

Items 1–4 are small enough to build directly into this skill's `assets/`
and `references/` right now. Items 5–8 are documentation additions —
naming the pattern and pointing at it, without necessarily bundling a full
implementation.

## Suggested build order

Given both flagship deliverables are now validated rather than speculative:

1. Core enhancements 1–4 (section 6) — they're small and make the base
   skill itself stronger regardless of what else gets built.
2. Flagship B (JS showcase) — proves the scaffold works end-to-end on a
   real example, and doubles as the "example workflow" content flagship A
   needs anyway.
3. Flagship A (marketplace/toolkit repo) — broadest scope, best done last
   since it can pull proven pieces from 1 and 2 instead of inventing
   examples from scratch.
