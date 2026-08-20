---
name: testing
description: House testing conventions for acme-widgets — file layout, mocking rules, and coverage expectations. Claude should apply this automatically whenever writing or reviewing tests.
---

- Co-locate tests as `__tests__/<name>.test.ts` next to the module, not in a
  parallel top-level `tests/` tree.
- One behavior per `it()`.
- Mock at the network/IO boundary only (the `pg` client, `fetch` calls) —
  never mock a plain function just because it's inconvenient to set up.
- Every bug fix gets a regression test first, written to fail against the
  old code before the fix lands.
- Validation logic (anything using a Zod schema) gets both a valid-input and
  at least one invalid-input test case, per field that has a non-trivial
  constraint (regex, range, enum).
- Run `pnpm test` before considering a change done — don't rely on the
  `run-tests-on-change` hook alone, since it only covers the file that changed.
