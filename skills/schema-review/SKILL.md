---
name: schema-review
description: Review a data model or API schema change for backward compatibility and validation gaps. Use before merging a change to a database schema, API contract, or shared type definition.
---

## Changed schema files

!`git diff HEAD -- '**/*.schema.*' '**/migrations/**' '**/*.proto' 2>/dev/null | head -c 4000`

## Instructions

Review the schema change above for:

1. **Backward compatibility** — does this break existing consumers? Flag any
   removed field, renamed field, or tightened constraint (new required field,
   narrower enum) that isn't additive.
2. **Validation gaps** — are there fields with no format/range constraint that
   should have one (emails, currency amounts, enums as free strings)?
3. **Migration safety** — for a database migration, is it reversible? Does it
   lock a large table? Should it ship as two migrations (add nullable, backfill,
   then enforce)?
4. **Naming consistency** — does the new field/table follow the naming
   convention already used elsewhere in this schema?

If the diff is empty, say so and stop — don't invent a schema to review.
