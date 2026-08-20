#!/usr/bin/env bash
# PreToolUse hook (Write|Edit): refuse edits while on a protected branch.
# Exit code 2 blocks the call; Claude sees stderr as the reason.
set -euo pipefail
branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || true)"
case "$branch" in
  main|master|production)
    echo "Blocked: direct edits on protected branch '$branch'. Create a feature branch first." >&2
    exit 2 ;;
esac
exit 0
