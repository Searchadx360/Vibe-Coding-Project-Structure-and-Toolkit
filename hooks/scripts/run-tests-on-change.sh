#!/usr/bin/env bash
# PostToolUse hook (Write|Edit), recommended as an async hook: run the test
# file next to whatever source file just changed, so failures surface
# immediately instead of at the end of the session.
set -euo pipefail
input="$(cat)"
file_path="$(echo "$input" | python3 -c 'import json,sys;print(json.load(sys.stdin).get("tool_input",{}).get("file_path",""))' 2>/dev/null || true)"
[ -z "$file_path" ] && exit 0

case "$file_path" in
  *.test.*|*.spec.*|*__tests__*) test_file="$file_path" ;;
  *.ts|*.tsx|*.js|*.jsx)
    dir="$(dirname "$file_path")"
    base="$(basename "$file_path")"
    name="${base%.*}"
    ext="${base##*.}"
    test_file="$dir/__tests__/$name.test.$ext" ;;
  *) exit 0 ;;
esac

[ -f "$test_file" ] || exit 0
npx --no-install vitest run "$test_file" --reporter=basic 2>&1 | tail -n 20 || true
exit 0
