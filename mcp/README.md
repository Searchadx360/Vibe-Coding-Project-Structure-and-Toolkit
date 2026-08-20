# MCP configs

`servers.json` is an index of commonly used MCP servers — not a live config
by itself. Pick the ones you want and either:

1. Install the [`mcp-connectors`](../plugins/mcp-connectors) plugin for the
   GitHub/Postgres/filesystem trio pre-wired as a `.mcp.json`, or
2. Add a server yourself:
   ```
   claude mcp add github -- npx -y @modelcontextprotocol/server-github
   ```

Every server here reads credentials from environment variables — never
paste a token directly into `.mcp.json` if the file is going to be committed.
See [`code.claude.com/docs/en/mcp`](https://code.claude.com/docs/en/mcp) for
the full installation-scope and authentication reference.
