# <Topic> — Progress

**Status: DRAFT**

**Spec:** `docs/specs/YYYY-MM-DD-<topic>-design.md`

**Plan:** `docs/plans/YYYY-MM-DD-<topic>-implementation-plan.md`

## Done
- (none yet)

## In progress
- Task 1 — <description> (what's touched on disk, build green/red, and *why this approach*)

## Not started
- Remaining tasks from the implementation plan.

## Gotchas / decisions
- Record non-obvious dead ends, constraints discovered late, and deliberate choices a fresh agent would otherwise undo.

## Verification
- Record commands run and outcomes per accepted task (commit hash + pass/fail).

## Next action
1. Read `docs/state/CURRENT.md` and reconcile with `git status` / `git log`.
2. <Exact next step from the active task in the implementation plan>.

## CURRENT synchronization
After each task boundary, update `docs/state/CURRENT.md` with active task, status, and the same next action above.

## Memory-promotion checkpoint
Before each task commit, ask: *did this task surface a learning that will outlive it?*
- **Yes** — add or update a file under `.agents/memory/` and index it in `MEMORY.md`.
- **No** — record task-scoped history in `docs/state/sessions/` only.

## Changelog
- **YYYY-MM-DD** — Created progress ledger from `_TEMPLATE-progress.md`.
