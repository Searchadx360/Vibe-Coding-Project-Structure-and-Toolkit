# Commands

Flat `.md` skill files for `.claude/commands/`. These work identically to a
`skills/<name>/SKILL.md` folder — use a folder instead when you want
supporting files (scripts, templates) alongside the instructions.

| Command | What it does |
| --- | --- |
| [`ticket-to-pr`](ticket-to-pr.md) | Pulls a ticket, implements it, opens a PR (`/ticket-to-pr ENG-482`) |
| [`release-notes`](release-notes.md) | Drafts release notes from commits since the last tag |

Both are `disable-model-invocation`-safe candidates once you tune them to your
tracker of choice — see [`examples/js-project-starter`](../examples/js-project-starter)
for a fully wired version of `ticket-to-pr` connected to a real MCP config.
