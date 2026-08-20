#!/usr/bin/env bash
# PreToolUse hook (Write|Edit): deny edits while checked out on a protected
# branch. Uses the hookSpecificOutput.permissionDecision shape so the ask/
# deny/allow flow stays visible in `/hooks`, rather than a bare exit 2.
set -euo pipefail
branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || true)"

case "$branch" in
  main|master|production)
    jq -n --arg reason "Direct edits on protected branch '$branch' are blocked. Create a feature branch first (see .claude/commands/ticket.md, step 3)." \
      '{hookSpecificOutput: {hookEventName: "PreToolUse", permissionDecision: "deny", permissionDecisionReason: $reason}}'
    exit 0 ;;
esac

exit 0
