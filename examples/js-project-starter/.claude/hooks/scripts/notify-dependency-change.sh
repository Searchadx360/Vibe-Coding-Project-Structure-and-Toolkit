#!/usr/bin/env bash
# FileChanged hook (matcher: package.json): FileChanged has no decision
# control (no additionalContext) — it's a side-effect-only event, so this
# just surfaces a systemMessage to the user in the terminal, and also
# appends to a local log Claude can read back if it wants full history.
set -euo pipefail
input="$(cat)"
echo "$(date -u +%FT%TZ) package.json changed on disk" >> .claude/hooks/dependency-changes.log
jq -n '{systemMessage: "package.json changed on disk — run `pnpm install` before the dev server or tests."}'
exit 0
