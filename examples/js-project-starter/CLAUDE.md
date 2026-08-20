# CLAUDE.md

## Project overview

`acme-widgets` is a TypeScript REST API (Express) with a Postgres-backed
data layer, deployed as a Docker image. It's in active development —
production traffic is live, so treat `main` as protected.

## Tech stack

- Node.js 22, TypeScript 5, Express 5
- Postgres via `pg` + Zod schemas for runtime validation (see
  `.claude/skills/schema-patterns/SKILL.md`)
- Vitest for tests, ESLint + Prettier for lint/format
- pnpm as the package manager — never use npm or yarn in this repo

## Commands

| Task | Command |
| --- | --- |
| Install | `pnpm install` |
| Dev server | `pnpm dev` |
| Test | `pnpm test` |
| Test (watch) | `pnpm test:watch` |
| Lint | `pnpm lint` |
| Build | `pnpm build` |

## Conventions

- One export per file in `src/utils/`; barrel files only in `src/index.ts`.
- Validation lives at the boundary: every external input (HTTP body, query
  param, DB row) is parsed through a Zod schema before it's used. See
  `.claude/skills/schema-patterns/SKILL.md`.
- Errors are thrown as typed `AppError` subclasses, never raw `Error` or
  string throws, so the error middleware can map them to HTTP status codes.
- Tests live in `__tests__/` next to the module they cover, not in a
  parallel top-level `tests/` tree. See `.claude/skills/testing/SKILL.md`.

## Rules

@.claude/rules/security.md

## Do not

- Do not edit an already-applied migration in `migrations/` — write a new one.
- Do not commit directly to `main` — a hook enforces this, but don't try to
  work around it either.
- Do not add a new dependency without checking it's actually needed; this
  API has a small, deliberately short dependency list.
