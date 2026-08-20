#!/usr/bin/env bash
# Scaffolds a .claude/ directory in the CURRENT project by copying selected
# catalog items out of this toolkit repo. Run from your project root:
#   /path/to/vibe-coding-toolkit/scripts/setup.sh
set -euo pipefail

TOOLKIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="$(pwd)"

mkdir -p .claude/skills .claude/agents .claude/commands .claude/hooks/scripts .claude/rules

echo "Copying starter skills..."
cp -r "$TOOLKIT_DIR/skills/testing-patterns" .claude/skills/
cp -r "$TOOLKIT_DIR/skills/schema-review" .claude/skills/

echo "Copying starter agent..."
cp "$TOOLKIT_DIR/agents/code-reviewer.md" .claude/agents/

echo "Copying starter command..."
cp "$TOOLKIT_DIR/commands/release-notes.md" .claude/commands/

echo "Copying starter hooks (auto-format + protected branch)..."
cp "$TOOLKIT_DIR/hooks/auto-format.hooks.json" /tmp/_auto-format.hooks.json
cp "$TOOLKIT_DIR/hooks/scripts/auto-format.sh" .claude/hooks/scripts/
cp "$TOOLKIT_DIR/hooks/scripts/block-protected-branch.sh" .claude/hooks/scripts/
chmod +x .claude/hooks/scripts/*.sh

echo "Copying starter rule (security)..."
cp "$TOOLKIT_DIR/rules/security.md" .claude/rules/

if [ ! -f CLAUDE.md ]; then
  cp "$TOOLKIT_DIR/templates/CLAUDE.md.template" CLAUDE.md
  echo "Created CLAUDE.md from template — fill in the placeholders."
else
  echo "CLAUDE.md already exists, left untouched."
fi

cat <<'NOTE'

Done. Next steps:
  1. Merge the hooks from /tmp/_auto-format.hooks.json and
     hooks/block-protected-branch.hooks.json into your .claude/settings.json
     "hooks" key (see templates/settings.json.template for the shape).
  2. Fill in CLAUDE.md.
  3. Run `claude` and try `/release-notes`.
NOTE
