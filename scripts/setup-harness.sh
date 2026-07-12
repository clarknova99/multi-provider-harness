#!/usr/bin/env bash
# setup-harness.sh — (re)create the tool pointer symlinks after a fresh clone.
# Git preserves symlinks on macOS/Linux, so you normally don't need this. Use it
# to repair a clobbered symlink, or on a machine where symlinks didn't materialize.
#
# On Windows, or a mixed team, DON'T use symlinks for CLAUDE.md — run with
# CLAUDE_IMPORT=1 to write a one-line @AGENTS.md import file instead.

set -euo pipefail
cd "$(git rev-parse --show-toplevel 2>/dev/null || echo .)"

# --- CLAUDE.md ---
if [ "${CLAUDE_IMPORT:-0}" = "1" ]; then
  printf '@AGENTS.md\n' > CLAUDE.md
  echo "wrote CLAUDE.md (@AGENTS.md import)"
else
  ln -sf AGENTS.md CLAUDE.md
  echo "linked CLAUDE.md -> AGENTS.md"
fi

# --- .claude subdirs (Claude Code reads skills/agents from here) ---
mkdir -p .claude
ln -sfn ../.agents/skills .claude/skills
ln -sfn ../.agents/agents .claude/agents
echo "linked .claude/skills and .claude/agents -> ../.agents/*"

# --- Gemini (config, not symlink; already committed) ---
mkdir -p .gemini
[ -e .gemini/settings.json ] || printf '{ "contextFileName": "AGENTS.md" }\n' > .gemini/settings.json
echo "ensured .gemini/settings.json"

# --- Codex adapters are committed files (.codex/config.toml + .codex/agents/*.toml),
#     not symlinks — nothing to link here. Keep them in sync with .agents/agents/*.md.

echo "Done. Run scripts/verify-harness.sh to confirm."
