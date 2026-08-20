# Advanced / optional patterns

These are real, proven patterns from large Claude Code ecosystems (see
[../../../research/ecosystem-tools-analysis.md](../../../research/ecosystem-tools-analysis.md)
for the source audit), but they're a step beyond what a base project
scaffold needs. Documented here so you know the option exists — none of
this is bundled as a script or template in this skill, because the right
implementation is genuinely project-specific.

## Worktree isolation for parallel agents

**The problem:** running more than one Claude Code agent/task against the
same repo at the same time causes collisions — two agents editing
overlapping files on the same branch step on each other.

**The pattern, seen independently across multiple large plugin
ecosystems** (vibe-kanban, ccpm, pro-workflow): give each agent/task its
own `git worktree`, so each one has an isolated working directory and
branch. Merge back through a normal review gate (a human, or a review
agent) rather than letting agents merge directly into each other.

```bash
git worktree add ../repo-task-123 -b task/123-fix-auth
```

Point one agent's session at `../repo-task-123`, another at the main
worktree, and they can work simultaneously without either seeing the
other's uncommitted changes. Clean up with `git worktree remove` once the
branch is merged or abandoned.

**When to reach for this:** the moment you want two agents (or two
parallel Claude Code sessions) making unrelated changes to the same repo
at the same time. Below that, it's unnecessary ceremony.

## Persistent memory that doesn't cost context

**The problem:** every new session starts cold. `CLAUDE.md` and skills
solve "what should always/conditionally be in context," but they don't
solve "what happened in past sessions that's worth remembering without
re-reading the whole history."

**The pattern** (seen in claude-mem and the knowledge-graph-style plugins):
capture session actions/decisions outside the prompt entirely — SQLite
with full-text search, or a vector store (pgvector) for semantic recall —
and query it on demand rather than holding it in context by default. The
model asks for what it needs instead of always carrying it.

**When to reach for this:** long-lived projects where the same kind of
decision keeps needing to be re-explained or re-discovered session after
session. For a short-lived or single-session project, this is overkill —
`CLAUDE.md` and good commit messages cover it.

## MCP catalog / installer pattern

**The problem:** finding and correctly configuring the right MCP server
for a task (which one handles Jira vs. Linear, what the env vars are
called, whether it's stdio or http) is its own research project every
time.

**The pattern:** a curated, categorized list of known-good MCP server
configs, paired with an installer command (a `/install-mcp`-style slash
command, or a setup script) that writes the right entry into `.mcp.json`
given a short answer about what the project needs to connect to.

**When to reach for this:** if you (or your team) set up MCP servers
often enough that re-deriving the right config each time is real friction.
For a single project reaching for one or two MCP servers, just follow
[mcp-and-settings.md](mcp-and-settings.md) directly — a catalog only pays
for itself at repeated-use scale.

## Context-budget awareness

**The problem:** "keep `.claude/` lean" is good advice with no way to
check whether you're actually following it. A `CLAUDE.md` plus several
rules plus several skills can quietly grow into a meaningful chunk of the
context window before anyone notices.

**The pattern:** periodically measure how much of the context budget your
always-loaded files (`CLAUDE.md`, anything not conditionally loaded)
actually consume — even a rough token count of those files gives you a
number to watch instead of a vibe. If it's growing every month and nobody
intended that, that's the signal to split content into conditionally-loaded
skills instead of always-loaded files.

**When to reach for this:** once `CLAUDE.md` plus rules starts feeling
long enough that you're not sure anymore whether it's still lean. Don't
build tooling for this speculatively — a manual word-count check every
few months is enough for most projects.
