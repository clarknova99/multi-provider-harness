#!/usr/bin/env bash
# verify-harness.sh — assert the cross-tool harness pointers are intact.
# Symlink/pointer setups fail silently (a symlink clobbered into a real file,
# a miscased path, an oversized AGENTS.md). Run this in CI and as a pre-commit hook.

set -euo pipefail

fail() { echo "HARNESS BROKEN: $1" >&2; exit 1; }
warn() { echo "  warn: $1" >&2; }
ok()   { echo "  ok: $1"; }

echo "Verifying cross-tool harness..."

# --- Claude Code pointers ---
if [ -e CLAUDE.md ]; then
  if [ -L CLAUDE.md ]; then
    [ "$(readlink CLAUDE.md)" = "AGENTS.md" ] || fail "CLAUDE.md symlink points somewhere other than AGENTS.md"
    ok "CLAUDE.md -> AGENTS.md (symlink)"
  else
    # Allowed alternative: a one-line @AGENTS.md import (use this on Windows teams).
    # A ZIP/Windows checkout can also flatten the symlink into a file literally
    # containing "AGENTS.md" (no @) — that's broken, so re-run setup-harness.sh.
    grep -q '@AGENTS.md' CLAUDE.md || fail "CLAUDE.md is a real file but doesn't @AGENTS.md-import (a ZIP/Windows checkout may have flattened the symlink). Run: bash scripts/setup-harness.sh"
    ok "CLAUDE.md imports AGENTS.md (real file)"
  fi
else
  fail "CLAUDE.md missing (Claude Code won't find the instructions)"
fi

for link in .claude/skills .claude/agents; do
  if [ ! -L "$link" ]; then
    # A ZIP download or a Windows checkout can flatten a symlink into a plain file
    # whose contents are literally the target path. Detect that and point at the fix.
    if [ -f "$link" ] && grep -q '\.agents/' "$link" 2>/dev/null; then
      fail "$link is a plain file, not a symlink — a ZIP download or Windows checkout flattened it. Run: bash scripts/setup-harness.sh"
    fi
    fail "$link is not a symlink (Claude Code expects it to point at ../.agents/...). Run: bash scripts/setup-harness.sh"
  fi
  target="$(readlink "$link")"
  [ -e "$link" ] || fail "$link symlink is dangling (target '$target' does not resolve). Run: bash scripts/setup-harness.sh"
  ok "$link -> $target"
done

[ -e .claude/settings.json ] || echo "  note: .claude/settings.json absent (optional, but recommended)"

# --- Gemini ---
[ -e .gemini/settings.json ] || fail ".gemini/settings.json missing (Gemini won't read AGENTS.md)"
grep -q 'AGENTS.md' .gemini/settings.json || fail ".gemini/settings.json does not set contextFileName to AGENTS.md"
ok ".gemini/settings.json -> contextFileName: AGENTS.md"

# --- Cursor / Copilot pointers (thin, but should exist) ---
[ -e .cursor/rules/00-harness.mdc ] || warn ".cursor/rules/00-harness.mdc absent (Cursor won't be pointed at AGENTS.md)"
[ -e .github/copilot-instructions.md ] || warn ".github/copilot-instructions.md absent (Copilot surfaces won't be pointed at AGENTS.md)"

# --- Codex adapters (committed files, mirror of .agents/agents/*.md) ---
[ -e .codex/config.toml ] || warn ".codex/config.toml absent"
for md in .agents/agents/*.md; do
  [ -e "$md" ] || continue
  base="$(basename "$md" .md)"
  [ -e ".codex/agents/${base}.toml" ] || warn "persona '${base}' has no matching .codex/agents/${base}.toml (Codex won't see it — keep adapters in sync)"
done
ok "checked Codex persona adapters against .agents/agents/"

# --- Canonical files present ---
[ -f AGENTS.md ] || fail "AGENTS.md missing (this is the source of truth)"
[ -f docs/state/CURRENT.md ] || fail "docs/state/CURRENT.md missing (the cross-provider handoff file)"
[ -d .agents/skills ] || fail ".agents/skills missing"
ok "canonical files present"

# --- Codex 32 KiB cap on AGENTS.md ---
size=$(wc -c < AGENTS.md | tr -d ' ')
if [ "$size" -gt 32768 ]; then
  fail "AGENTS.md is ${size} bytes — over Codex's 32 KiB (32768) cap; Codex will silently truncate it. Move detail into .agents/skills/*/SKILL.md."
fi
ok "AGENTS.md within Codex cap (${size} / 32768 bytes)"

echo "Harness OK."
