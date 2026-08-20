---
description: Draft release notes from the commits since the last tag.
argument-hint: "[optional: since-tag, defaults to latest tag]"
---

## Commits since last release

!`git log $(git describe --tags --abbrev=0 2>/dev/null || echo "$(git rev-list --max-parents=0 HEAD)")..HEAD --oneline`

## Instructions

Group the commits above into release notes with these sections, omitting any
that are empty:

- **Breaking changes**
- **New features**
- **Fixes**
- **Internal / chores** (collapsed to a one-line summary, not itemized)

Write each entry as a user-facing sentence, not the raw commit message.
Drop merge commits and anything purely mechanical (version bumps, lockfile
updates) from the visible sections.
