import express from "express";
import { widgetInputSchema } from "./utils/schema.js";

const app = express();
app.use(express.json());

app.post("/widgets", (req, res) => {
  const parsed = widgetInputSchema.safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({ error: parsed.error.flatten() });
  }
  // In a real handler this would hit the database via a repository module.
  return res.status(201).json({ id: "widget_stub", ...parsed.data });
});

const port = process.env.PORT ? Number(process.env.PORT) : 3000;
app.listen(port, () => {
  console.log(`acme-widgets listening on :${port}`);
});
