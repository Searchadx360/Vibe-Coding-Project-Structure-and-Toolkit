# `.mcp.json` and `.claude/settings.json`

## `.mcp.json` — external tool integrations

Lives at the repo root, next to `CLAUDE.md`. Declares MCP (Model Context
Protocol) servers the project wants available — databases, ticket trackers,
design tools, internal APIs. Supports local (stdio) processes and remote
(HTTP) endpoints.

```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "DATABASE_URL": "${DATABASE_URL}"
      }
    },
    "project-tracker": {
      "url": "https://mcp.example.com/",
      "headers": {
        "Authorization": "Bearer ${TRACKER_TOKEN}"
      }
    }
  }
}
```

Commit this file — it's configuration, not a secret. Reference credentials
with `${ENV_VAR}` expansion rather than hardcoding tokens, so the file stays
safe to check in and the actual secret lives in each developer's environment
or CI's secret store.

## `.claude/settings.json` — shared config, hooks, and permissions

Controls tool permissions and wires up hooks for this repo. Commit this
file — it's the team's shared configuration.

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": { "tool": "Bash" },
        "command": "scripts/hooks/block-dangerous-commands.sh"
      }
    ],
    "PostToolUse": [
      {
        "matcher": { "tool": "Edit" },
        "command": "scripts/hooks/format-changed-file.sh"
      }
    ],
    "UserPromptSubmit": [
      {
        "command": "node .claude/hooks/skill-eval.js"
      }
    ],
    "Stop": [
      {
        "command": "scripts/hooks/require-tests-pass.sh"
      }
    ]
  },
  "enableAllProjectMcpServers": true
}
```

A hook script reads event details on stdin (JSON) and responds on stdout.
The common response shape:

```json
{
  "block": true,
  "message": "Refused: this command matches a destructive pattern (rm -rf).",
  "feedback": "Optional non-blocking note shown to the model."
}
```

`block: true` stops the action (or the model stopping, for `Stop`) and
surfaces `message` as the reason. Omit `block` (or set it `false`) for a
hook that only observes, logs, or nudges via `feedback` without stopping
anything — this is the shape the skill-suggestion hook uses (see
[skill-eval-hook.md](skill-eval-hook.md) for the full worked example).

### What each event is for, concretely

| Event | Runs | Typical use |
|---|---|---|
| `PreToolUse` | before a tool call executes | refuse a destructive command, refuse edits to a generated/vendored path, block edits on `main` |
| `PostToolUse` | after a tool call completes | auto-format a file that was just edited, auto-run the relevant test file, re-lint |
| `UserPromptSubmit` | when the user submits a prompt, before the model sees it | inject repo-specific context, score the prompt against `skill-rules.json` and suggest skills, log prompts, veto a request that matches a disallowed pattern |
| `Stop` | when the model is about to stop responding | require the test suite to pass first, require a summary of changes before finishing |

## `.claude/settings.local.json` — personal overrides

Same shape as `settings.json`, but **gitignored**. This is where a
developer keeps tweaks that are real but shouldn't be forced on everyone
else working in the repo: a looser tool-permission set for their own
workflow, an extra MCP server pointed at their personal sandbox, a hook
temporarily disabled while they debug something.

Add this line to `.gitignore` (see `assets/gitignore.append.txt`):

```
.claude/settings.local.json
```

Without this split, teams tend to end up either (a) nobody customizes
anything because it would mean committing a personal tweak for everyone, or
(b) someone commits a personal tweak and it silently becomes everyone's
default. `settings.local.json` removes that tradeoff — start it as an empty
`{}` (see `assets/settings.local.json.template`) and let people add to it
freely.

## LSP integration

If the Claude Code build you're on supports plugin-based language servers,
wiring one in gives the model real diagnostics instead of having to
simulate type-checking by reading code:

```json
{
  "enabledPlugins": {
    "typescript-lsp@claude-plugins-official": true,
    "pyright-lsp@claude-plugins-official": true
  }
}
```

**Problem it solves:** without this, "does this type-check" is something
the model has to infer from reading the code. With a real language server
wired in, it gets actual hover info, go-to-definition, and error
diagnostics — ground truth instead of a best guess. Worth adding the moment
type errors or "undefined is not a function"-style mistakes show up more
than once in a session.

### Keeping this safe to publish

- Commit `.claude/settings.json` and `.mcp.json` — they're project
  configuration. Never commit `.claude/settings.local.json`.
- Never hardcode API keys, tokens, or passwords in any of these files — use
  `${ENV_VAR}` expansion.
- Hook scripts should fail closed on ambiguity for anything destructive —
  if the hook script itself errors, treat that as "don't allow the risky
  action" rather than silently letting it through.
