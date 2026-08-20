---
paths: "src/components/**/*.tsx, src/components/**/*.jsx"
---

# Frontend style rules

- Functional components with hooks only — no new class components.
- Co-locate a component's styles and tests next to the component file.
- Props get an explicit TypeScript interface, not inline object types, once
  a component takes more than two props.
- Prefer composition (children/render props) over a boolean-flag prop that
  branches internal rendering (`showFooter` → pass a `<Footer />` child instead).
