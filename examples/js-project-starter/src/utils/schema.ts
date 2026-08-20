import { z } from "zod";

/**
 * Every external input gets a schema here and is parsed through it at the
 * boundary (route handler, queue consumer, etc.) — see
 * .claude/skills/schema-patterns/SKILL.md for the convention this follows.
 */
export const widgetInputSchema = z.object({
  name: z.string().min(1).max(120),
  sku: z.string().regex(/^[A-Z0-9-]{4,32}$/, "sku must be uppercase alphanumeric"),
  priceCents: z.number().int().nonnegative(),
  tags: z.array(z.string()).max(10).default([]),
});

export type WidgetInput = z.infer<typeof widgetInputSchema>;
