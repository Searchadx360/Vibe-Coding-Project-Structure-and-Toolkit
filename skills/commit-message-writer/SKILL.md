---
name: commit-message-writer
description: Write a Conventional Commits-formatted commit message from the currently staged changes. Use before committing when the user wants help wording the message rather than writing the diff itself.
disable-model-invocation: true
---

## Staged changes

!`git diff --cached`

## Instructions

Write a commit message for the staged diff above, formatted as:

```
<type>(<scope>): <summary, imperative mood, under 72 chars>

<body: what changed and why, wrapped at ~72 chars, only if it adds
information the summary line doesn't already carry>
```

Use `type` from: feat, fix, refactor, test, docs, chore, perf, build, ci.
Infer `scope` from the changed path (e.g. the top-level package or module).
If the staged diff is empty, say there's nothing staged and stop.
