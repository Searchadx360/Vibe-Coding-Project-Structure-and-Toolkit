---
description: Pull a ticket from the issue tracker, implement it, and open a PR. Use with a ticket ID, e.g. "/ticket-to-pr ENG-482".
argument-hint: "[ticket-id]"
disable-model-invocation: true
allowed-tools: Bash(gh issue view *), Bash(gh pr create *), Bash(git checkout *), Bash(git push *)
---

Work ticket $ARGUMENTS end to end:

1. Fetch the ticket: `gh issue view $ARGUMENTS` (or your tracker's CLI/MCP
   equivalent — see `mcp/README.md` for a Linear/Jira MCP config).
2. Restate the acceptance criteria back before writing any code, so a
   misread ticket gets caught early.
3. Create a branch named `ticket/$ARGUMENTS-<short-slug>`.
4. Implement the change, following this repo's CLAUDE.md conventions.
5. Write or update tests covering the acceptance criteria.
6. Open a PR with `gh pr create`, with a description that links back to the
   ticket and lists what was and wasn't covered.

Stop and ask before step 3 if the ticket's acceptance criteria are ambiguous
enough that two reasonable implementations would satisfy them differently.
