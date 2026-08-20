# Agents

Copy-paste-friendly subagent definitions. Drop a file into your project's
`.claude/agents/` (project-only) or `~/.claude/agents/` (all your projects).

| Agent | Invoke for |
| --- | --- |
| [`code-reviewer`](code-reviewer.md) | PR-style review of a diff or recent changes |
| [`debugger`](debugger.md) | Root-causing a failing test or bug report |
| [`data-scientist`](data-scientist.md) | Ad-hoc SQL/analytics questions against your database |

Frontmatter fields (`name`, `description`, `model`, `effort`, `maxTurns`,
`tools`, `disallowedTools`, `skills`, `memory`) are documented at
[`code.claude.com/docs/en/sub-agents`](https://code.claude.com/docs/en/sub-agents).
