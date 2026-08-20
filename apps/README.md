# Companion apps

Claude Code's CLI is the core, but the same skills, agents, hooks, and
plugins in this repo carry over to these surfaces:

| App | Best for |
| --- | --- |
| **Claude Code (terminal)** | Everyday coding, scriptable/headless automation, CI |
| **Claude Desktop** | Working alongside local files/apps, computer use, parallel sessions |
| **Cowork** | Handing off heavier multi-step research/analysis/writing tasks |
| **VS Code / JetBrains extensions** | Coding inside your existing IDE, inline diffs |
| **Claude Code on the web** | Starting tasks from a browser or phone, no local setup |
| **Claude for Chrome** | Browser automation — testing a local app, filling forms |
| **Claude Tag (Slack)** | Tagging `@Claude` in Slack to delegate a task from chat |
| **GitHub Actions (`claude-code-action`)** | `@claude` PR/issue automation, scheduled reports, auto-review |

Plugins installed at **user** scope follow you across the CLI, Desktop, and
IDE extensions. Plugins declared in a repo's `.claude/settings.json` (project
scope) follow the repo into cloud/web sessions too — see
[`examples/js-project-starter`](../examples/js-project-starter) for a project
set up that way.

Full current list and setup docs:
https://code.claude.com/docs/en/platforms
