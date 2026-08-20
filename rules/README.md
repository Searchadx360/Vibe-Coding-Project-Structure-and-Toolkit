# Rules

Path-scoped instructions for `.claude/rules/`. Unlike a single CLAUDE.md,
each file here only loads when Claude is working with files matching its
`paths` frontmatter — useful for keeping a monorepo's CLAUDE.md small.

| Rule file | Applies to | Covers |
| --- | --- | --- |
| [`security.md`](security.md) | `**/*.env*`, `**/secrets/**`, `**/auth/**` | Secret handling, input validation, auth-change review |
| [`style-frontend.md`](style-frontend.md) | `src/components/**` | Component conventions |

Copy the files you want into your project's `.claude/rules/` directory. See
[`code.claude.com/docs/en/memory#organize-rules-with-claude-rules`](https://code.claude.com/docs/en/memory)
for the path-matching syntax.
