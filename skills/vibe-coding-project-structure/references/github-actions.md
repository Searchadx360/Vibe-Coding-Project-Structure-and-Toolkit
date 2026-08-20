# GitHub Actions: making the repo maintain itself

These turn Claude Code from something you only get value from while
sitting at the keyboard into something that keeps reviewing and maintaining
the repo between sessions. All four are optional — the bootstrap script
only installs them with `--with-actions` — because they cost real API
money on a schedule and shouldn't be turned on silently.

## Setup required for all four

1. Add `ANTHROPIC_API_KEY` as a repository secret (Settings → Secrets and
   variables → Actions).
2. Confirm `anthropics/claude-code-action` (or whichever action your
   Claude Code version documents) is the correct action reference — pin a
   version rather than `@main` for anything that runs unattended on a
   schedule.
3. Start with just the PR review workflow. Add the scheduled ones once
   you've seen the PR workflow's actual cost and quality on a few runs.

## 1. `pr-claude-code-review.yml` — review on every PR

- **Trigger:** `pull_request` (`opened`, `synchronize`, `reopened`), or an
  issue comment mentioning `@claude`.
- **What it does:** runs `git diff origin/main...HEAD` and reviews it
  against whatever standard you point it at — typically
  `.claude/agents/code-reviewer.md`'s checklist.
- **Problem it solves:** removes the wait for a human reviewer to be free,
  and catches issues before a human even looks.
- **Rough cost:** $0.05–$0.50 per PR, depending on diff size and model.

## 2. `scheduled-claude-code-docs-sync.yml` — monthly doc-drift check

- **Trigger:** scheduled, 1st of the month.
- **What it does:** reads the commit history since the last run and flags
  (or drafts) documentation updates that code changes imply but nobody
  wrote.
- **Problem it solves:** docs silently drifting from what the code actually
  does — nobody proactively re-reads the README after every merge.
- **Rough cost:** $0.50–$2.00/month.

## 3. `scheduled-claude-code-quality.yml` — weekly quality sweep

- **Trigger:** scheduled, weekly (e.g. Sunday).
- **What it does:** reviews a random sample of directories that haven't
  had a PR-triggered review recently, and either flags or auto-fixes
  findings depending on how you configure it.
- **Problem it solves:** code that never goes through a PR (small direct
  commits, older code nobody's touched) never gets reviewed otherwise.
- **Rough cost:** $1.00–$5.00/week.

## 4. `scheduled-claude-code-dependency-audit.yml` — biweekly dependency check

- **Trigger:** scheduled, 1st and 15th of the month.
- **What it does:** checks for outdated/vulnerable dependencies, proposes
  updates, and runs the test suite against the bump before opening a PR —
  so a broken update gets caught by CI, not by a person.
- **Problem it solves:** dependency bumps that quietly break something,
  caught as part of the update instead of discovered later.
- **Rough cost:** $0.20–$1.00/cycle.

## Estimated total if you run all four

Roughly **$10–$50/month** for a moderately active repo — cheap relative to
a human doing the equivalent monthly doc pass, weekly sweep, and dependency
audit by hand, but not free, and it scales with repo activity. Turn on one
at a time and watch actual billing before adding the next.

## Templates

The four `.yml` files in `assets/github-actions/` are starting points, not
drop-in-and-forget automation — each references `.claude/agents/` files
that need to actually exist (a `code-reviewer.md` agent, for instance) and
assumes `ANTHROPIC_API_KEY` is set. Read each file's comments before
enabling it, and adjust the model, schedule, and prompt to the specific
repo.
