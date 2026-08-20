# Protected paths

These paths need extra care. This file is meant to be copied to
`.claude/rules/protected-paths.md` in a target project (see the `rules/`
folder at the repo root for more on how path-scoped rules work).

- `**/*.env*`, `**/secrets/**` — never print contents; never suggest committing them.
- `infra/**/*.tf` — call out blast radius (which environment) before proposing a change.
- `migrations/**` — never edit an already-applied migration; write a new one instead.
- `main`, `master`, `production` branches — propose a feature branch instead of committing directly here. The `safe-ops` hook enforces this one; the others are judgment calls for Claude to apply.
