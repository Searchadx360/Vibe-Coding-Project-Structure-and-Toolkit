---
name: schema-patterns
description: How this repo validates external input with Zod. Use when adding a new endpoint, queue consumer, or anywhere data crosses a trust boundary.
---

Every external input is parsed through a Zod schema at the boundary, before
it's used anywhere else:

```ts
const parsed = someInputSchema.safeParse(rawInput);
if (!parsed.success) {
  // handle the 400/validation-error path — never throw the ZodError raw
  return res.status(400).json({ error: parsed.error.flatten() });
}
const data = parsed.data; // fully typed from here on
```

Conventions:
- Schema lives in `src/utils/schema.ts` (or a feature-scoped `*.schema.ts`
  file once that file gets large), named `<thing>InputSchema`.
- Export the inferred type alongside the schema: `export type X = z.infer<typeof xSchema>`.
- Strings that have a real format (SKU, currency code, slug) get a `.regex()`
  or `.enum()`, not a bare `z.string()`.
- Numbers that represent money are always integer cents (`z.number().int()`),
  never floats.
- Arrays get a `.max()` bound — an unbounded array from user input is a
  denial-of-service surface.

When reviewing a schema change, also check
`.claude/skills/schema-patterns/SKILL.md` (this file) against the actual
diff — the `schema-review` skill in the toolkit's `skills/` catalog covers
the reviewer side of this same convention.
