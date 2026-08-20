---
name: testing-patterns
description: House testing conventions for this repo — how to structure test files, what to mock, and coverage expectations. Claude should apply this automatically whenever writing or reviewing tests.
---

When writing or reviewing tests in this repo:

- Co-locate tests as `__tests__/<name>.test.ts` next to the module, not in a
  parallel top-level `tests/` tree.
- One behavior per `it()`. If a test name needs "and" to describe it, split it.
- Mock at the network/IO boundary only. Don't mock a function just because it's
  slow to reason about — mock the fetch/db call it makes, not the function itself.
- Every bug fix gets a regression test first, written to fail against the old code.
- Prefer table-driven tests (`it.each`) over copy-pasted near-duplicate test blocks.
- Skip snapshot tests for anything that changes often (UI copy, generated IDs).
  Reserve snapshots for stable structural output.
