#!/usr/bin/env bash
# PostToolUse hook (Write|Edit), run async: after a source file changes, run
# its co-located test file so failures surface immediately.
set -euo pipefail
input="$(cat)"
file_path="$(jq -r '.tool_input.file_path // empty' <<<"$input")"
[ -z "$file_path" ] && exit 0

case "$file_path" in
  *__tests__*|*.test.*) test_file="$file_path" ;;
  *.ts|*.tsx)
    dir="$(dirname "$file_path")"
    base="$(basename "$file_path")"
    name="${base%.*}"
    test_file="$dir/__tests__/$name.test.ts" ;;
  *) exit 0 ;;
esac

[ -f "$test_file" ] || exit 0
npx --no-install vitest run "$test_file" --reporter=basic 2>&1 | tail -n 30 || true
exit 0
