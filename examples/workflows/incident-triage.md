# Workflow: production bug report → root cause → regression test

## Setup

```
/plugin install review-suite@vibe-coding-toolkit
```
Copy [`agents/debugger.md`](../../agents/debugger.md) to `.claude/agents/`.

## The workflow

1. **Paste the report.** Give Claude the stack trace or bug description and
   say "use the debugger agent." This routes to a subagent with a higher
   effort level and more turns budgeted, since root-causing usually needs
   several rounds of hypothesis-and-check rather than a one-shot fix.
2. **Reproduce first.** The `debugger` agent's instructions require running
   the failing test or a minimal repro before touching any code — this is
   the difference between a real fix and a plausible-looking one.
3. **Confirm the root cause out loud.** The agent states the cause in one
   sentence before patching, which is your checkpoint to redirect it if it's
   chasing the wrong hypothesis.
4. **Fix + regression test together.** The agent adds a test that fails on
   the old code and passes on the new one, so the bug can't silently return.
5. **Format and review.** The same `review-suite` hook and skill from the
   feature workflow apply here unchanged — the safety net doesn't care
   whether the diff came from a feature or a fix.

## Why a dedicated subagent

Bug triage benefits from an isolated context: the debugger doesn't need your
whole conversation history, just the failure and the codebase, and running
it as a subagent means a long, exploratory root-cause hunt doesn't bloat the
main session's context window.
