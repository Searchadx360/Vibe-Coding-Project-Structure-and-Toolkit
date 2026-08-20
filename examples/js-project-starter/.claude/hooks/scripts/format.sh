#!/usr/bin/env bash
# PostToolUse hook (Write|Edit): auto-format the file Claude just touched.
# Pure side effect — always exits 0 so it never blocks anything.
set -euo pipefail
input="$(cat)"
file_path="$(jq -r '.tool_input.file_path // empty' <<<"$input")"
[ -z "$file_path" ] && exit 0
[ -f "$file_path" ] || exit 0

case "$file_path" in
  *.ts|*.tsx|*.js|*.jsx|*.json|*.md)
    npx --no-install prettier --write "$file_path" >/dev/null 2>&1 || true ;;
esac
exit 0
