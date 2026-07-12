# Copilot instructions

All project conventions, invariants, and skill routing live in [`AGENTS.md`](../AGENTS.md) at the repository root. Read it first.

Before starting work, read [`docs/state/CURRENT.md`](../docs/state/CURRENT.md) — it holds the active task and the exact next action. This project is worked across multiple AI providers (Claude Code, Codex, Cursor, Gemini) switched mid-task when usage limits trip; on-disk state in `docs/state/` is the only source of continuity between them.

This file is a thin pointer — it exists so Copilot surfaces that look for `.github/copilot-instructions.md` still find their way to the canonical `AGENTS.md`. Do not duplicate content here.
