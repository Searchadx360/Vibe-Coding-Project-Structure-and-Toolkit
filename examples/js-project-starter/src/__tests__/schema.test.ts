import { describe, expect, it } from "vitest";
import { widgetInputSchema } from "../utils/schema.js";

describe("widgetInputSchema", () => {
  it("accepts a valid widget", () => {
    const result = widgetInputSchema.safeParse({
      name: "Acme Bolt",
      sku: "AB-1234",
      priceCents: 999,
    });
    expect(result.success).toBe(true);
  });

  it("rejects a lowercase sku", () => {
    const result = widgetInputSchema.safeParse({
      name: "Acme Bolt",
      sku: "ab-1234",
      priceCents: 999,
    });
    expect(result.success).toBe(false);
  });

  it("rejects a negative price", () => {
    const result = widgetInputSchema.safeParse({
      name: "Acme Bolt",
      sku: "AB-1234",
      priceCents: -1,
    });
    expect(result.success).toBe(false);
  });
});
