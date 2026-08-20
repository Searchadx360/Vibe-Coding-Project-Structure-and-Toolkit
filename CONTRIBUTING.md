# Contributing

Pull requests welcome. A few guidelines to keep the catalog useful:

## Adding a skill, agent, command, hook, or rule

1. Put it in the matching top-level folder (`skills/`, `agents/`,
   `commands/`, `hooks/`, `rules/`), following the existing naming pattern.
2. Add a row to that folder's `README.md` table.
3. Keep instructions concrete and testable — "review for quality" is not
   useful; "flag any handler that skips input validation, with file:line"
   is. See existing entries for the level of specificity we're going for.
4. If it's genuinely reusable across many stacks, it belongs in the
   top-level catalog. If it's specific to one workflow, put it in
   `examples/` instead and link to it from the relevant catalog README.

## Adding a plugin bundle

1. Create `plugins/<name>/.claude-plugin/plugin.json` plus whatever
   components it bundles (`agents/`, `skills/`, `hooks/hooks.json`, etc.).
2. Add an entry to `.claude-plugin/marketplace.json`.
3. Run `claude plugin validate ./plugins/<name>` before opening a PR.
4. Bump `version` in `plugin.json` on every change — see
   [plugin version management](https://code.claude.com/docs/en/plugins-reference#version-management).

## Adding an example workflow

Add a markdown file under `examples/workflows/` that names the specific
agents/skills/hooks/rules involved and explains *why* that combination,
not just what each piece does — see `feature-to-pr.md` for the pattern.

## Testing your change

```
/plugin marketplace add .
/plugin install <your-plugin>@vibe-coding-toolkit
```

Run `claude plugin validate .` from the repo root to catch schema errors
in `marketplace.json` before opening a PR.
