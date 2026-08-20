# js-project-starter

A complete Claude Code setup for a JavaScript/TypeScript repo, wired end to
end so you can copy it into a real project and understand it at a glance.
It's a small working app (`acme-widgets`, an Express + Zod + Postgres API),
not a folder of placeholder files — every hook, skill, and workflow here
runs against real code in this same repo.

## What's here

```
CLAUDE.md                          project memory: stack, commands, conventions
.mcp.json                          Linear + GitHub MCP servers
.claude/
├── settings.json                  permissions + all four hooks wired up
├── skills/
│   ├── testing/SKILL.md           test file layout & mocking conventions
│   └── schema-patterns/SKILL.md   Zod validation conventions
├── agents/
│   └── code-reviewer.md           PR-style review subagent
├── commands/
│   └── ticket.md                  /ticket ENG-482 — ticket to PR, end to end
└── hooks/scripts/
    ├── format.sh                  PostToolUse — prettier on every write/edit
    ├── block-main-edit.sh         PreToolUse  — deny edits on main/master/production
    ├── suggest-skill.sh           UserPromptSubmit — nudges toward the right skill
    ├── run-tests-on-change.sh     PostToolUse (async) — runs the co-located test
    └── notify-dependency-change.sh FileChanged (package.json) — reminds to reinstall
.github/workflows/
├── claude-mentions.yml            @claude in issue/PR comments
├── claude-code-review.yml         automatic review on every PR
└── claude-scheduled-maintenance.yml  weekly lint+test sweep, files an issue on failure
src/                               the actual (small) app the rest of this demonstrates against
```

## How the hooks fit together

| Event | Hook | What it does | Why exit/decision shape it uses |
| --- | --- | --- | --- |
| `PreToolUse` (Write\|Edit) | `block-main-edit.sh` | Denies the edit if the current branch is `main`/`master`/`production` | `hookSpecificOutput.permissionDecision: "deny"` |
| `PostToolUse` (Write\|Edit) | `format.sh` | Runs Prettier on the touched file | Side effect only, always exits 0 |
| `PostToolUse` (Write\|Edit), async | `run-tests-on-change.sh` | Runs the file's co-located test | Side effect only, doesn't block the turn |
| `UserPromptSubmit` | `suggest-skill.sh` | Adds context nudging Claude toward `schema-patterns` or `testing` when the prompt mentions them | `hookSpecificOutput.additionalContext` |
| `FileChanged` (`package.json`) | `notify-dependency-change.sh` | Surfaces a reminder to run `pnpm install` | `systemMessage` — `FileChanged` has no `additionalContext` support, so this reaches the user, not Claude's context |

All scripts read the hook's JSON payload from stdin with `jq` — install it
if you don't have it (`brew install jq` / `apt install jq`).

## Copy this into your own repo

1. Copy `.claude/`, `CLAUDE.md`, and `.mcp.json` into your project root.
2. Update `CLAUDE.md`'s tech stack and commands section for your actual stack.
3. `chmod +x .claude/hooks/scripts/*.sh`.
4. Swap the `linear` MCP server in `.mcp.json` for your own tracker (or
   remove it and point `.claude/commands/ticket.md` at `gh issue view` instead,
   like the toolkit-level [`ticket-to-pr`](../../commands/ticket-to-pr.md) command does).
5. Run `/install-github-app` from Claude Code to wire up the GitHub Actions
   secret, or add `ANTHROPIC_API_KEY` as a repo secret manually and copy the
   three workflow files.

## Full docs

- Hooks: https://code.claude.com/docs/en/hooks
- Skills: https://code.claude.com/docs/en/skills
- Subagents: https://code.claude.com/docs/en/sub-agents
- MCP: https://code.claude.com/docs/en/mcp
- GitHub Actions: https://code.claude.com/docs/en/github-actions
