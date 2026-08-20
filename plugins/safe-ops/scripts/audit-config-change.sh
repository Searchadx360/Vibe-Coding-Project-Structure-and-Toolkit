#!/usr/bin/env bash
# ConfigChange hook: append a timestamped line to a local audit log whenever
# Claude Code settings/config change during a session. Never blocks anything.
set -euo pipefail
log_dir="${CLAUDE_PROJECT_DIR:-.}/.claude/audit"
mkdir -p "$log_dir"
echo "$(date -u +%FT%TZ) config-change: $(cat)" >> "$log_dir/config-changes.log"
exit 0
