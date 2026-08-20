#!/usr/bin/env bash
# Bootstrap the "vibe coding" project structure into a target directory.
# Safe to re-run: only creates files/folders that don't already exist,
# never overwrites anything.
#
# Usage: bootstrap.sh /path/to/project [--with-actions] [--with-context]
#
#   --with-actions   also install the GitHub Actions review/maintenance
#                     templates into .github/workflows/ (these run on a
#                     schedule and cost real API money - see
#                     references/github-actions.md before enabling)
#   --with-context   also create CONTEXT.md for human-authored narrative
#                     context, split out from CLAUDE.md

set -euo pipefail

TARGET="."
WITH_ACTIONS=0
WITH_CONTEXT=0

for arg in "$@"; do
  case "$arg" in
    --with-actions) WITH_ACTIONS=1 ;;
    --with-context) WITH_CONTEXT=1 ;;
    *) TARGET="$arg" ;;
  esac
done

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

mkdir -p "$TARGET/.claude/rules" \
         "$TARGET/.claude/commands" \
         "$TARGET/.claude/skills" \
         "$TARGET/.claude/agents" \
         "$TARGET/.claude/hooks"

copy_if_missing() {
  local src="$1" dest="$2"
  if [[ -f "$dest" ]]; then
    echo "skip  (exists) $dest"
  else
    cp "$src" "$dest"
    echo "create         $dest"
  fi
}

copy_if_missing "$SKILL_DIR/assets/CLAUDE.md.template"        "$TARGET/CLAUDE.md"
copy_if_missing "$SKILL_DIR/assets/CLAUDE.local.md.template"   "$TARGET/CLAUDE.local.md"
copy_if_missing "$SKILL_DIR/assets/settings.json.template"     "$TARGET/.claude/settings.json"
copy_if_missing "$SKILL_DIR/assets/settings.local.json.template" "$TARGET/.claude/settings.local.json"
copy_if_missing "$SKILL_DIR/assets/mcp.json.template"          "$TARGET/.mcp.json"
copy_if_missing "$SKILL_DIR/assets/hooks/skill-eval.js"        "$TARGET/.claude/hooks/skill-eval.js"
copy_if_missing "$SKILL_DIR/assets/hooks/skill-rules.json.template" "$TARGET/.claude/hooks/skill-rules.json"

# .gitignore: append the personal-override lines if they're not already there
GITIGNORE="$TARGET/.gitignore"
touch "$GITIGNORE"
if ! grep -qF ".claude/settings.local.json" "$GITIGNORE"; then
  cat "$SKILL_DIR/assets/gitignore.append.txt" >> "$GITIGNORE"
  echo "append         $GITIGNORE (.claude/settings.local.json, CLAUDE.local.md)"
else
  echo "skip  (exists) $GITIGNORE already ignores personal-override files"
fi

if [[ "$WITH_CONTEXT" -eq 1 ]]; then
  copy_if_missing "$SKILL_DIR/assets/CONTEXT.md.template" "$TARGET/CONTEXT.md"
fi

if [[ "$WITH_ACTIONS" -eq 1 ]]; then
  mkdir -p "$TARGET/.github/workflows"
  for f in "$SKILL_DIR"/assets/github-actions/*.yml; do
    name="$(basename "$f")"
    copy_if_missing "$f" "$TARGET/.github/workflows/$name"
  done
  echo ""
  echo "GitHub Actions templates installed. Before they run for real:"
  echo "  - Add ANTHROPIC_API_KEY as a repository secret."
  echo "  - Read references/github-actions.md for what each one costs."
  echo "  - They reference .claude/agents/code-reviewer.md - create it first."
fi

echo ""
echo "Done. Next steps:"
echo "  1. Fill in $TARGET/CLAUDE.md with real project facts."
echo "  2. Fill in $TARGET/.claude/hooks/skill-rules.json once you add real skills."
echo "  3. Add rules/commands/skills/agents only as you actually need them."
echo "  4. See the skill's references/ folder for what each piece is for."
