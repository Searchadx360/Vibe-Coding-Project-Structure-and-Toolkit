/**
 * Source of truth for this site's project index.
 *
 * Every entry mirrors a real file or folder in the vibe-coding-toolkit
 * repo (https://github.com/Searchadx360/Vibe-Coding-Project-Structure-and-Toolkit) — update REPO_BASE
 * once you fork/rename that repo, and keep this file in sync when the repo
 * structure changes. Nothing here is fetched at runtime; it's a static
 * snapshot so the site works with zero build step and no API calls.
 */

const REPO_BASE = "https://github.com/Searchadx360/Vibe-Coding-Project-Structure-and-Toolkit/tree/main";

const CATEGORIES = [
  {
    id: "systems-administration",
    label: "systems-administration",
    tagline: "Guardrails, audit trails, and ops-facing MCP connectors.",
  },
  {
    id: "planning",
    label: "planning",
    tagline: "Ticket-to-PR flows, release notes, incident triage.",
  },
  {
    id: "research",
    label: "research",
    tagline: "Agents built for digging — data, security, growth, code.",
  },
  {
    id: "writing",
    label: "writing",
    tagline: "Commit messages, briefs, ad copy, release copy.",
  },
  {
    id: "plugins",
    label: "plugins",
    tagline: "Bundled, installable — the toolkit's own marketplace entries.",
  },
  {
    id: "templates",
    label: "templates",
    tagline: "CLAUDE.md, settings.json, and a full project starter.",
  },
  {
    id: "workspace-ideas",
    label: "workspace-ideas",
    tagline: "Companion surfaces, rule sets, and other starting points.",
  },
];

const PROJECTS = [
  // systems-administration
  {
    category: "systems-administration",
    title: "safe-ops",
    description:
      "Hooks that deny edits on protected branches/paths and log every config change to a local audit trail.",
    href: `${REPO_BASE}/plugins/safe-ops`,
    tags: ["plugin", "hooks", "guardrails"],
  },
  {
    category: "systems-administration",
    title: "mcp-connectors",
    description:
      "Starter .mcp.json bundling GitHub, Postgres, and filesystem servers behind env-var credentials.",
    href: `${REPO_BASE}/plugins/mcp-connectors`,
    tags: ["plugin", "mcp"],
  },
  {
    category: "systems-administration",
    title: "protected-paths rule",
    description:
      "Path-scoped rule flagging .env files, Terraform, and applied migrations for extra care.",
    href: `${REPO_BASE}/plugins/safe-ops/rules/protected-paths.md`,
    tags: ["rules"],
  },
  {
    category: "systems-administration",
    title: "audit-config-change hook",
    description:
      "ConfigChange hook that appends a timestamped line every time session settings change.",
    href: `${REPO_BASE}/plugins/safe-ops/scripts/audit-config-change.sh`,
    tags: ["hooks"],
  },

  // planning
  {
    category: "planning",
    title: "ticket-to-pr",
    description:
      "Pulls a ticket, restates acceptance criteria, branches, implements, tests, and opens a PR.",
    href: `${REPO_BASE}/commands/ticket-to-pr.md`,
    tags: ["command"],
  },
  {
    category: "planning",
    title: "feature-to-pr workflow",
    description:
      "Walkthrough of how a hook, a command, a skill, and a subagent combine on one ticket end to end.",
    href: `${REPO_BASE}/examples/workflows/feature-to-pr.md`,
    tags: ["workflow"],
  },
  {
    category: "planning",
    title: "release-notes",
    description:
      "Drafts grouped, user-facing release notes from the commits since the last tag.",
    href: `${REPO_BASE}/commands/release-notes.md`,
    tags: ["command"],
  },
  {
    category: "planning",
    title: "incident-triage workflow",
    description:
      "Bug report to confirmed root cause to regression test, using an isolated debugger subagent.",
    href: `${REPO_BASE}/examples/workflows/incident-triage.md`,
    tags: ["workflow"],
  },

  // research
  {
    category: "research",
    title: "data-scientist",
    description:
      "Runs SQL against your project's database and explains results in plain language, filters stated explicitly.",
    href: `${REPO_BASE}/agents/data-scientist.md`,
    tags: ["agent"],
  },
  {
    category: "research",
    title: "schema-review",
    description:
      "Reviews a schema/API diff for backward compatibility, validation gaps, and migration safety.",
    href: `${REPO_BASE}/skills/schema-review/SKILL.md`,
    tags: ["skill"],
  },
  {
    category: "research",
    title: "security-auditor",
    description:
      "Deeper, isolated security pass for auth, payment, and input-parsing changes — impact-rated findings.",
    href: `${REPO_BASE}/plugins/review-suite/agents/security-auditor.md`,
    tags: ["agent"],
  },
  {
    category: "research",
    title: "growth-analyst",
    description:
      "Unit-economics-first analysis of campaigns and channels — CAC/ROAS math before creative opinions.",
    href: `${REPO_BASE}/plugins/growth-ops/agents/growth-analyst.md`,
    tags: ["agent"],
  },

  // writing
  {
    category: "writing",
    title: "commit-message-writer",
    description:
      "Writes a Conventional Commits message from the currently staged diff — you invoke it, it never guesses.",
    href: `${REPO_BASE}/skills/commit-message-writer/SKILL.md`,
    tags: ["skill"],
  },
  {
    category: "writing",
    title: "campaign-brief",
    description:
      "Turns a one-line campaign idea into a one-page brief a media buyer or designer could act on today.",
    href: `${REPO_BASE}/plugins/growth-ops/skills/campaign-brief/SKILL.md`,
    tags: ["skill"],
  },
  {
    category: "writing",
    title: "ad-copy-compliance",
    description:
      "Rates ad copy for policy risk line by line and rewrites anything flagged Medium or High.",
    href: `${REPO_BASE}/plugins/growth-ops/skills/ad-copy-compliance/SKILL.md`,
    tags: ["skill"],
  },
  {
    category: "writing",
    title: "CONTRIBUTING guide",
    description:
      "House style for writing a new catalog entry — concrete and testable instructions, not vague guidance.",
    href: `${REPO_BASE}/CONTRIBUTING.md`,
    tags: ["docs"],
  },

  // plugins
  {
    category: "plugins",
    title: "review-suite",
    description:
      "code-reviewer + security-auditor agents, a quality-review skill, and a format-on-save hook.",
    href: `${REPO_BASE}/plugins/review-suite`,
    tags: ["plugin"],
  },
  {
    category: "plugins",
    title: "growth-ops",
    description:
      "Domain-expert bundle for marketers: growth-analyst agent plus campaign-brief and ad-copy skills.",
    href: `${REPO_BASE}/plugins/growth-ops`,
    tags: ["plugin"],
  },
  {
    category: "plugins",
    title: "safe-ops",
    description: "Protected-branch and protected-path guardrail hooks, plus an audit log.",
    href: `${REPO_BASE}/plugins/safe-ops`,
    tags: ["plugin"],
  },
  {
    category: "plugins",
    title: "mcp-connectors",
    description: "GitHub, Postgres, and filesystem MCP servers, ready to enable individually.",
    href: `${REPO_BASE}/plugins/mcp-connectors`,
    tags: ["plugin"],
  },

  // templates
  {
    category: "templates",
    title: "CLAUDE.md.template",
    description:
      "Fill-in-the-blanks project memory: stack, commands, conventions, testing, rule imports.",
    href: `${REPO_BASE}/templates/CLAUDE.md.template`,
    tags: ["template"],
  },
  {
    category: "templates",
    title: "settings.json.template",
    description: "Starter permissions, one hook, and a pre-enabled plugin.",
    href: `${REPO_BASE}/templates/settings.json.template`,
    tags: ["template"],
  },
  {
    category: "templates",
    title: "js-project-starter",
    description:
      "A complete, copy-paste Claude Code setup for a JS/TS repo — memory, skills, an agent, a ticket command, hooks, MCP, and CI.",
    href: `${REPO_BASE}/examples/js-project-starter`,
    tags: ["template", "example"],
  },

  // workspace-ideas
  {
    category: "workspace-ideas",
    title: "Companion apps guide",
    description:
      "Which Claude Code surface — CLI, Desktop, IDE extension, web, Chrome, GitHub Actions — fits which task.",
    href: `${REPO_BASE}/apps/README.md`,
    tags: ["docs"],
  },
  {
    category: "workspace-ideas",
    title: "Rules catalog",
    description: "Path-scoped .claude/rules/ examples for security and frontend conventions.",
    href: `${REPO_BASE}/rules`,
    tags: ["rules"],
  },
  {
    category: "workspace-ideas",
    title: "quality-review",
    description: "A quick, skill-level pass over the current diff — cheaper than a full subagent review.",
    href: `${REPO_BASE}/plugins/review-suite/skills/quality-review/SKILL.md`,
    tags: ["skill"],
  },
  {
    category: "workspace-ideas",
    title: "code-reviewer",
    description: "The standalone version of review-suite's PR-style reviewer, for copying without the plugin.",
    href: `${REPO_BASE}/agents/code-reviewer.md`,
    tags: ["agent"],
  },
];

// Exposed as globals for the vanilla-JS pages (no bundler, no build step).
window.CLAUDE_INDEX = { REPO_BASE, CATEGORIES, PROJECTS };
