# Workflow: ticket → feature branch → reviewed PR

How the pieces in this toolkit combine on a normal feature ticket, end to end.

## Setup (one-time, per project)

```
/plugin marketplace add ./vibe-coding-toolkit
/plugin install review-suite@vibe-coding-toolkit
/plugin install safe-ops@vibe-coding-toolkit
```

Copy [`templates/CLAUDE.md.template`](../../templates/CLAUDE.md.template) to
`CLAUDE.md` and fill in your stack. Copy
[`rules/security.md`](../../rules/security.md) to `.claude/rules/`.

## The workflow

1. **Kick off the ticket.** Run the [`ticket-to-pr`](../../commands/ticket-to-pr.md)
   command (copied to `.claude/commands/`): `/ticket-to-pr ENG-482`. Claude
   fetches the ticket, restates acceptance criteria, and creates a branch —
   `safe-ops`'s `block-protected-branch` hook makes this safe by construction,
   since edits on `main` are refused regardless of what Claude intends to do.
2. **Implement.** Claude writes code following `CLAUDE.md` conventions. Every
   `Write`/`Edit` triggers `review-suite`'s format-on-save hook, so style
   nits never reach review.
3. **Self-review before opening the PR.** Claude (or you) invokes
   `/quality-review` — the `review-suite` skill — against the working diff.
4. **Escalate for anything security-sensitive.** If the ticket touched auth,
   payments, or user input, invoke the `security-auditor` subagent
   explicitly: `Use the security-auditor agent on this diff.`
5. **Open the PR.** `ticket-to-pr` finishes by running `gh pr create` with a
   description linking the ticket and summarizing coverage.
6. **Automated review on GitHub.** The repo's `claude-code-review.yml`
   workflow (see [`examples/js-project-starter`](../js-project-starter)) runs
   `code-reviewer` again on the opened PR and posts inline comments — a
   second, disinterested pass independent of the local session.

## Why this combination

- The **hook** (safe-ops) enforces the one rule that must never depend on
  Claude remembering it: no direct commits to `main`.
- The **command** (ticket-to-pr) encodes the repeatable sequence so it isn't
  re-explained every time.
- The **skill** (quality-review) is cheap to invoke mid-session, before
  anything is pushed.
- The **subagent** (security-auditor) is reserved for the subset of changes
  where a deeper, isolated pass is worth the extra turns.
- The **CI workflow** is the backstop that runs even if a step above got
  skipped locally.
