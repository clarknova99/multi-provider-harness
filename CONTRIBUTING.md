# Contributing to multi-provider-harness

Thanks for your interest in improving this project! This repo is a **standalone, dependency-free harness** that lets several AI coding tools (Claude Code, ChatGPT Codex, Cursor, Gemini CLI) share task state through plain files in the repo. Contributions that keep it lean, tool-agnostic, and true to its single-source-of-truth design are especially welcome.

## Code of Conduct
This project is governed by our [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold it. Please report unacceptable behavior as described there.

## Ways to contribute
- **Report a bug** or unexpected behavior — open an issue using the bug template.
- **Propose a feature** or workflow improvement — use the feature template.
- **Improve documentation, skills, or personas** — these are the heart of the harness.
- **Add a new capability workflow** as a skill under `.agents/skills/`.

## Before you start
Read [`AGENTS.md`](AGENTS.md) first — it is the source of truth for how the harness works and the conventions every change must follow. Then read [`docs/state/CURRENT.md`](docs/state/CURRENT.md) to see whether there is active work in flight before you begin something new.

## Local setup
```bash
git clone <your-fork-url>
cd multi-provider-harness
bash scripts/setup-harness.sh   # (re)create the symlinks if your checkout flattened them
bash scripts/verify-harness.sh  # confirm the wiring is intact
```
If you cloned via `git` on macOS/Linux the symlinks come through automatically. ZIP downloads and some Windows checkouts flatten them — `setup-harness.sh` rebuilds them, and `verify-harness.sh` will tell you if anything is broken.

## Development workflow
The required spine for any non-trivial change is **spec → plan → execute (test-first) → verify → checkpoint**. Each phase has a first-class skill in `.agents/skills/`:
1. **Spec** — write a dated change proposal in `docs/specs/` from `_TEMPLATE-spec.md`.
2. **Plan** — write a task-by-task plan in `docs/plans/` from the templates.
3. **Execute** — one task at a time, test-first (red → green → refactor), one commit per task.
4. **Verify** — keep the build+test gate green (`bash scripts/verify-harness.sh` for harness changes) and do a `code-reviewer`-persona pass.
5. **Checkpoint** — update `docs/state/CURRENT.md` so any provider can pick up where you left off.

Small, obvious fixes (a typo, a broken link) don't need the full spine — just make the change and open a PR.

## Conventions
- **No artificial line breaks in Markdown.** One paragraph = one continuous line; let the editor soft-wrap. Lists, tables, headings, and code blocks are fine.
- **Keep `AGENTS.md` lean.** It loads on every turn and Codex truncates past 32 KiB. Put depth in `.agents/skills/*/SKILL.md`, not in `AGENTS.md`.
- **Keep the top of every doc true.** Edit docs in place when reality changes; append the "why" to the doc's `## Changelog`.
- **Keep the canonical files and their mirrors in sync.** The `.agents/agents/*.md` personas are canonical; update the `.codex/agents/*.toml` adapters to match.
- **Match the surrounding style** of whatever file you're editing.

## Submitting a pull request
1. Fork the repo and create a branch from `main`.
2. Make your change following the conventions above.
3. Run `bash scripts/verify-harness.sh` and make sure it passes.
4. Update `docs/` (CURRENT.md, DECISIONS.md, specs, or plans) wherever your change affects task state or documented behavior.
5. Open a PR and fill out the pull request template.

## Reporting security issues
Please **do not** open public issues for security vulnerabilities. Follow the process in [SECURITY.md](SECURITY.md) instead.
