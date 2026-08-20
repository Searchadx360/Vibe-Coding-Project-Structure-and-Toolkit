---
name: quality-review
description: Quick quality pass over currently selected code or the latest uncommitted diff. Use when the user asks to review, sanity-check, or clean up recent changes before committing.
---

## Current diff

!`git diff HEAD`

## Instructions

Review the diff above for:
- Bugs or edge cases the tests likely don't cover
- Security concerns (input validation, secrets, unsafe deserialization)
- Readability and naming
- Anything that contradicts conventions already established elsewhere in this repo

Be concise and actionable: a short bullet list, not prose. If the diff is
empty, say there are no uncommitted changes and stop there.
