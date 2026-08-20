#!/usr/bin/env bash
# PostToolUse hook: auto-format the file Claude just wrote or edited.
# Reads the hook JSON payload from stdin and formats tool_input.file_path
# with whatever formatter matches the project, then exits quietly.
set -euo pipefail

input="$(cat)"
file_path="$(echo "$input" | python3 -c 'import json,sys;print(json.load(sys.stdin).get("tool_input",{}).get("file_path",""))' 2>/dev/null || true)"

[ -z "$file_path" ] && exit 0
[ -f "$file_path" ] || exit 0

case "$file_path" in
  *.js|*.jsx|*.ts|*.tsx)
    if [ -f "package.json" ] && npx --no-install prettier -v >/dev/null 2>&1; then
      npx --no-install prettier --write "$file_path" >/dev/null 2>&1 || true
    fi
    ;;
  *.py)
    command -v black >/dev/null 2>&1 && black -q "$file_path" || true
    ;;
  *.go)
    command -v gofmt >/dev/null 2>&1 && gofmt -w "$file_path" || true
    ;;
esac

exit 0
