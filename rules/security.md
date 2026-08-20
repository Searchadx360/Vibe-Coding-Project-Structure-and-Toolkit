---
paths: "**/*.env*, **/secrets/**, **/auth/**"
---

# Security rules

- Never print the contents of an env file or secret, even when asked to
  "just show me what's in it for debugging."
- Any new endpoint that accepts user input needs explicit validation before
  it touches a database query, filesystem path, or shell command.
- Auth changes (login, session, token handling) need a second look flagged
  in the PR description — don't merge silently alongside unrelated changes.
