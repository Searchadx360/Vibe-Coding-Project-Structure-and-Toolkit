# MCP Connectors Starter

A starter `.mcp.json` bundling three commonly used MCP servers. Each server
reads its credentials from environment variables — nothing is hardcoded.

| Server | What it gives Claude | Required env var |
| --- | --- | --- |
| `github` | Read/write issues, PRs, and repo content via the GitHub API | `GITHUB_TOKEN` |
| `postgres` | Read-only schema and query access to a Postgres database | `DATABASE_URL` |
| `filesystem` | Scoped filesystem access outside the project root | none (uses `${CLAUDE_PROJECT_DIR}`) |

## Use as a plugin

```
/plugin marketplace add ./vibe-coding-toolkit
/plugin install mcp-connectors@vibe-coding-toolkit
```

## Use standalone

Copy `.mcp.json` into your project root, delete the servers you don't need,
and set the referenced environment variables. See the official docs for the
full list of source types and installation scopes:
https://code.claude.com/docs/en/mcp
