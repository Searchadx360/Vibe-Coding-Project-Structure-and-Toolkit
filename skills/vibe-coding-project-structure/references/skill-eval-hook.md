# The skill-eval hook: deterministic skill triggering

## The problem

`.claude/skills/*/SKILL.md` files declare a `description` and rely on the
model reading it and deciding, mid-conversation, whether the current prompt
needs that skill. That's a probabilistic step — it works well when there
are one or two skills and the prompt clearly matches, and gets less
reliable as the skill count grows or the match is indirect (the user says
"this form keeps double-submitting" and the relevant skill is filed under
"mutation patterns," not "forms").

## The fix

A `UserPromptSubmit` hook that scores the incoming prompt against an
explicit rule set, and hands the model a ranked list of "these skills
probably apply" before it starts working — instead of hoping it independently
arrives at the same conclusion by reading every description carefully.

This turns skill triggering from "the model might notice" into "the repo
tells it."

## `skill-rules.json` — the schema

One entry per skill, matched by folder name under `.claude/skills/`:

```json
{
  "testing-patterns": {
    "description": "Jest testing patterns and TDD workflow",
    "priority": 9,
    "triggers": {
      "keywords": ["test", "jest", "spec", "tdd", "mock"],
      "keywordPatterns": ["\\btest(?:s|ing)?\\b"],
      "pathPatterns": ["**/*.test.ts", "**/*.test.tsx"],
      "intentPatterns": ["(?:write|add|create|fix).*(?:test|spec)"]
    },
    "excludePatterns": ["e2e", "maestro"]
  },
  "graphql-schema": {
    "description": "Query/mutation/schema conventions and codegen",
    "priority": 7,
    "triggers": {
      "keywords": ["graphql", "resolver", "mutation", "schema", "codegen"],
      "pathPatterns": ["**/*.graphql", "**/schema/**"]
    }
  }
}
```

Scoring, per skill, summed across whatever matches:

| Match type | Points | Why this weight |
|---|---|---|
| `keywords` (plain substring) | 2 | Weakest signal — common words can appear incidentally |
| `keywordPatterns` (regex) | 3 | More precise than a bare keyword — catches variants without over-matching |
| `pathPatterns` (glob against files mentioned/touched) | 4 | If the prompt or recent edits touch a matching path, that's strong, concrete evidence |
| `intentPatterns` (regex over the whole prompt, phrased as an action) | 4 | Catches "fix the login test" even without the word "testing" appearing |
| directory-level mapping (if you add one) | 5 | The most specific signal available — a task scoped to a known directory almost always wants that directory's skill |

`excludePatterns` subtracts a skill from consideration even if it would
otherwise match — e.g. don't suggest the unit-test skill when the prompt is
clearly about `e2e` or `maestro` tests, which have their own conventions.

Skills scoring above a threshold (start with something like 4) get
surfaced; the hook returns the top few, not every skill that scored above
zero, so the suggestion stays a nudge rather than noise.

## The hook script

`assets/hooks/skill-eval.js` (copied to `.claude/hooks/skill-eval.js` by the
bootstrap script) is a small Node script that:

1. Reads the `UserPromptSubmit` event payload from stdin.
2. Loads `.claude/hooks/skill-rules.json`.
3. Scores the prompt text against every skill's triggers.
4. Emits a non-blocking `feedback` string listing the top matches (if any),
   and exits 0.

It never sets `block: true` — this hook informs, it doesn't gate. If you
want a *required* skill (e.g. "never touch billing code without consulting
the billing skill"), that's a `PreToolUse` hook with a real block, not this
one — see [choosing-a-mechanism.md](choosing-a-mechanism.md).

Wire it into `.claude/settings.json`:

```json
{
  "hooks": {
    "UserPromptSubmit": [
      { "command": "node .claude/hooks/skill-eval.js" }
    ]
  }
}
```

## A caveat worth taking seriously

The exact JSON shape Claude Code sends into a hook's stdin, and the exact
shape it expects back on stdout, can change between Claude Code versions —
this pattern is synthesized from observed working examples, not from
pinning a specific version's schema. Before relying on this in a real
project, verify the current hook I/O contract for the Claude Code version
you're running (`claude doctor` or the current docs), and adjust
`skill-eval.js`'s input parsing and output shape to match. Treat the script
here as a correct *starting point and mechanism*, not a guarantee it's
byte-for-byte wired to whatever version you're on.
