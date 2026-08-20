# Hooks

Copy the `.hooks.json` file(s) you want into your project's
`.claude/settings.json` under the top-level `"hooks"` key (or drop them
straight into a plugin's `hooks/hooks.json` — the shape is identical), and
copy the matching script(s) into `.claude/hooks/scripts/`, then `chmod +x` them.

| Hook config | Event | What it does |
| --- | --- | --- |
| [`auto-format.hooks.json`](auto-format.hooks.json) | `PostToolUse` (Write/Edit) | Runs prettier/black/gofmt/rustfmt on the touched file |
| [`block-protected-branch.hooks.json`](block-protected-branch.hooks.json) | `PreToolUse` (Write/Edit) | Blocks edits while checked out on `main`/`master`/`production` |
| [`run-tests-on-change.hooks.json`](run-tests-on-change.hooks.json) | `PostToolUse` (Write/Edit), async | Runs the matching test file after a source file changes |

All scripts read the hook JSON payload from stdin and exit `0` to allow,
`2` to block (with the reason on stderr). See the full hook lifecycle,
event list, and JSON I/O schema at
[`code.claude.com/docs/en/hooks`](https://code.claude.com/docs/en/hooks).
