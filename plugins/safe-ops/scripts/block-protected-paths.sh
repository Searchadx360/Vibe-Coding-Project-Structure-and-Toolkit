#!/usr/bin/env bash
# PreToolUse hook (Write|Edit): block edits to the current branch if it's a
# protected branch, and block edits to a small deny-list of sensitive paths.
# Exit code 2 blocks the tool call and returns stderr to Claude as the reason.
set -euo pipefail

input="$(cat)"
file_path="$(echo "$input" | python3 -c 'import json,sys;print(json.load(sys.stdin).get("tool_input",{}).get("file_path",""))' 2>/dev/null || true)"

# 1. Block edits while checked out on a protected branch.
branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || true)"
case "$branch" in
  main|master|production)
    echo "Blocked: direct edits on protected branch '$branch'. Create a feature branch first." >&2
    exit 2
    ;;
esac

# 2. Block edits to a small deny-list, regardless of branch.
case "$file_path" in
  *.env|*.env.*|*/secrets/*|*/.git/*)
    echo "Blocked: '$file_path' matches a protected-path rule in safe-ops." >&2
    exit 2
    ;;
esac

exit 0
