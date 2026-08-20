#!/usr/bin/env bash
# PostToolUse hook (Write|Edit): format the touched file with the matching
# formatter for its extension, if one is available. Never fails the tool call.
set -euo pipefail
input="$(cat)"
file_path="$(echo "$input" | python3 -c 'import json,sys;print(json.load(sys.stdin).get("tool_input",{}).get("file_path",""))' 2>/dev/null || true)"
[ -z "$file_path" ] && exit 0
[ -f "$file_path" ] || exit 0
case "$file_path" in
  *.js|*.jsx|*.ts|*.tsx|*.json|*.css|*.md)
    npx --no-install prettier --write "$file_path" >/dev/null 2>&1 || true ;;
  *.py)
    command -v black >/dev/null 2>&1 && black -q "$file_path" || true ;;
  *.go)
    command -v gofmt >/dev/null 2>&1 && gofmt -w "$file_path" || true ;;
  *.rs)
    command -v rustfmt >/dev/null 2>&1 && rustfmt "$file_path" || true ;;
esac
exit 0
