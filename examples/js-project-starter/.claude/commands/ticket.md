---
description: Pull a ticket from Linear, implement it, and open a PR. Use with a ticket ID, e.g. "/ticket ENG-482".
argument-hint: "[ticket-id]"
disable-model-invocation: true
allowed-tools: mcp__linear__get_issue, Bash(git checkout *), Bash(git push *), Bash(gh pr create *)
---

Work ticket $ARGUMENTS end to end:

1. Fetch the ticket with the `linear` MCP server (`mcp__linear__get_issue`) —
   see `.mcp.json` at the repo root for the connection config.
2. Restate the acceptance criteria back before writing any code.
3. Create a branch named `ticket/$ARGUMENTS-<short-slug>` (the `safe-ops`-style
   hook in `.claude/hooks/hooks.json` blocks edits on `main`, so this step is
   required, not optional).
4. Implement the change per `CLAUDE.md` and the `schema-patterns` /
   `testing` skills.
5. Run `pnpm test` and `pnpm lint` — fix anything they surface before
   moving on.
6. Open a PR with `gh pr create`, linking the ticket in the description and
   listing what was and wasn't covered.

Stop and ask before step 3 if the ticket's acceptance criteria are ambiguous
enough that two reasonable implementations would satisfy them differently.
