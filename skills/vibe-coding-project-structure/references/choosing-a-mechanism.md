# Choosing a mechanism: rules vs commands vs skills vs agents vs hooks

`.claude/` has five kinds of extension points. They overlap in what they *can*
do, but each has a natural fit. Picking the right one keeps the setup legible
instead of turning into five folders that all do the same thing.

## Quick decision guide

Ask, in order:

1. **Does this need to happen automatically, without being asked, and ideally
   be hard to bypass?** → `hooks/`
2. **Is this a fixed sequence of steps I keep typing out by hand?** → `commands/`
3. **Is this specialized knowledge that only matters for some tasks, and would
   bloat every prompt if it were always loaded?** → `skills/`
4. **Does this need its own narrow focus and system prompt, ideally isolated
   from the main conversation (so it doesn't pollute context or get
   distracted)?** → `agents/`
5. **Is this a standing rule that should basically never be violated, and is
   short enough to just always be true?** → `rules/` (or inline in
   `CLAUDE.md` if it's very short)

If a task partially fits several — e.g. "review this PR" wants both a rule
("no `console.log` in production code") and an agent ("run a focused review
pass") — that's normal. These pieces compose.

One more question worth asking once you have more than a couple of
skills/rules: **does the model actually notice these exist when it should?**
If the answer is "not reliably," that's not a reason to write a longer
description — it's a reason to add the deterministic skill-eval hook. See
[skill-eval-hook.md](skill-eval-hook.md).

## `.claude/rules/`

Durable, narrow coding standards: error-handling conventions, forbidden
patterns, required test coverage, style rules not already caught by a linter.

**Good fit:** "All API handlers must validate input with zod before touching
the database." "Never catch an error without either handling it or
re-throwing — no silent swallowing."

**Bad fit:** anything that's really a one-off instruction for a single task —
that belongs in the conversation, not a permanent rule file.

Example — `.claude/rules/error-handling.md`:

```markdown
# Error handling

- Never swallow an error silently. Either handle it meaningfully or let it
  propagate.
- User-facing errors must not leak internal details (stack traces, SQL,
  file paths) — map to a generic message and log the detail server-side.
- Async functions that can fail must have a caller that handles rejection;
  don't fire-and-forget a promise that can throw.
```

## `.claude/commands/`

Slash commands (`/name`) for multi-step workflows you'd otherwise type out
every time. They can include bash execution and argument substitution
(`$ARGUMENTS`, `$1`, `$2`, ...).

**Good fit:** `/ship` that runs lint, tests, and drafts a commit message.
`/new-endpoint` that scaffolds a route handler, its test file, and a schema
stub given a resource name.

**Bad fit:** a single-step action ("run the tests") — just ask for that
directly, a command adds indirection without saving anything.

Example — `.claude/commands/new-endpoint.md`:

```markdown
---
description: Scaffold a new API endpoint with its test and validation schema
---

Create a new endpoint for resource "$1":

1. Add a route handler in `src/api/$1.ts` following the pattern in an
   existing handler in that folder.
2. Add a zod schema for the request body in `src/schemas/$1.ts`.
3. Add an integration test in `tests/api/$1.test.ts` covering the happy path
   and one validation failure.
4. Run the test file and report the result.
```

## `.claude/skills/`

Domain knowledge that should load *conditionally* — only when the task
actually touches that domain — so everyday prompts stay lean. Each skill is
its own folder with a `SKILL.md` (name + description in frontmatter, body
with the actual guidance, optional bundled scripts/references/assets).

**Good fit:** "how our database migrations work and what the naming
convention is," "how to add a new field to the design system," "the house
style for writing changelog entries."

**Bad fit:** something needed on nearly every task in the repo — that's
better placed in `CLAUDE.md` so it doesn't rely on correct triggering.

Once you have more than one or two skills, pair them with the skill-eval
hook (see [skill-eval-hook.md](skill-eval-hook.md)) rather than relying
purely on the model reading each `description` field at the right moment.

## `.claude/agents/`

Specialized subagents with their own system prompt and, often, their own tool
restrictions. They run in a separate context, so they don't crowd out the
main conversation with intermediate work, and they can be given a narrower,
more confident focus than a general-purpose assistant.

**Good fit:** a code-review agent that only reads and comments, never edits.
A migration-planning agent that reasons about a large diff without dragging
that detail into the main thread. A test-writer agent scoped to one
subsystem.

**Bad fit:** something that needs the full context of the ongoing
conversation — spinning it out to an isolated agent will cost you that
context, not save it.

If you want more than one agent touching the repo at the same time, see the
worktree-isolation pattern in
[advanced-patterns.md](advanced-patterns.md) — running them all on one
branch is how they collide.

## `.claude/hooks/`

Scripts triggered by lifecycle events. Unlike a rule (which is an instruction
the model reads and *usually* follows) or a command (which the model chooses
to invoke), a hook runs deterministically and can actually block an action
or inject information.

Four common events:

- **`PreToolUse`** — runs before a tool executes; can block it (e.g. refuse a
  `rm -rf`, refuse an edit to a generated file, refuse edits on `main`).
- **`PostToolUse`** — runs after a tool completes (e.g. auto-run a formatter
  after a file edit, auto-run tests after a file save).
- **`UserPromptSubmit`** — runs when the user submits a prompt, before the
  model sees it (e.g. score the prompt against `skill-rules.json` and
  suggest relevant skills — see [skill-eval-hook.md](skill-eval-hook.md)).
- **`Stop`** — runs when the model would otherwise stop, and can decide
  whether to let it stop or require more work first (e.g. "don't stop until
  tests pass").

**Good fit:** anything you want to be true *no matter what the model
decides*, because prose instructions can be forgotten, deprioritized, or
argued around under pressure, and a hook can't. Also good for anything that
should happen deterministically rather than probabilistically — like
skill triggering.

**Bad fit:** anything subjective or context-dependent where you actually
want the model to use judgment — hooks are for hard constraints and
deterministic nudges, not open-ended guidance.

See [mcp-and-settings.md](mcp-and-settings.md) for the concrete
`.claude/settings.json` shape these events live in, and
[skill-eval-hook.md](skill-eval-hook.md) for the fully worked
skill-suggestion hook.
