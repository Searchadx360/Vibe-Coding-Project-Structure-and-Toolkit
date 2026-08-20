#!/usr/bin/env bash
# Adds this repo as a Claude Code plugin marketplace and installs the
# plugin bundles you choose. Run from anywhere; Claude Code prompts
# interactively for the ones that need a scope decision.
set -euo pipefail

REPO_URL="${1:-Searchadx360/Vibe-Coding-Project-Structure-and-Toolkit}"

echo "Adding marketplace: $REPO_URL"
claude plugin marketplace add "$REPO_URL"

echo
echo "Available plugins:"
echo "  review-suite     - code-reviewer + security-auditor agents, quality-review skill, format hook"
echo "  growth-ops       - growth-analyst agent, campaign-brief + ad-copy-compliance skills"
echo "  safe-ops         - protected-branch + protected-path hooks"
echo "  mcp-connectors   - github/postgres/filesystem MCP servers"
echo
read -rp "Install all four? [y/N] " reply
if [[ "$reply" =~ ^[Yy]$ ]]; then
  for plugin in review-suite growth-ops safe-ops mcp-connectors; do
    claude plugin install "${plugin}@vibe-coding-toolkit"
  done
else
  echo "Install individually with: claude plugin install <name>@vibe-coding-toolkit"
fi
