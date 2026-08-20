#!/usr/bin/env bash
# UserPromptSubmit hook: nudge Claude toward the right project skill based
# on keywords in the prompt, via additionalContext (never blocks the prompt).
set -euo pipefail
input="$(cat)"
prompt="$(jq -r '.prompt // empty' <<<"$input" | tr '[:upper:]' '[:lower:]')"

context=""
case "$prompt" in
  *schema*|*validation*|*zod*)
    context="This request touches input validation — apply the schema-patterns skill (.claude/skills/schema-patterns/SKILL.md) for this repo's Zod conventions." ;;
esac
case "$prompt" in
  *test*|*spec*|*coverage*)
    context="${context:+$context }This request touches tests — apply the testing skill (.claude/skills/testing/SKILL.md) for file layout and mocking conventions."
    ;;
esac

if [ -z "$context" ]; then
  exit 0
fi

jq -n --arg ctx "$context" '{hookSpecificOutput: {hookEventName: "UserPromptSubmit", additionalContext: $ctx}}'
exit 0
