# CURRENT EXECUTION STATE
_Last updated: <YYYY-MM-DD HH:MM> by <tool> (<model>)_

> This is the single "start here" file. Any AI tool — on any provider — reads this FIRST, before doing anything else, to reconstruct the exact task state with zero chat context. Overwrite it at every checkpoint so it is never stale, and **keep it to a screenful** — it's a synthesized snapshot, not a log. This is the ONLY thing that survives a switch between Claude / Codex / Cursor / Gemini.
>
> **If you're resuming and the tree is dirty in ways this file doesn't explain, the previous provider was almost certainly cut off mid-task by a usage limit** (the normal case, not a bug). Read `git diff`, work out what it was doing, and fix this file to match reality before continuing.

## Active task
_No active task. If this is a brand-new project, the first task is usually "run the `initiating-a-project` skill: product brief → PRD → populate the harness."_

<!-- When a task is active, fill in like this and DELETE the "No active task" line:

## Active task
Implementing docs/plans/<YYYY-MM-DD>-<topic>-implementation-plan.md
Spec: docs/specs/<YYYY-MM-DD>-<topic>-*.md

## Status: IN_PROGRESS — Task <N> of <M>

## Done (committed)
- [x] Tasks 1–<N-1> (<short description>) — commit <sha>
- [x] Task <N> code written, NOT yet verified

## Next action (do this FIRST — do not re-plan or restart)
<The single most concrete next step. Include the exact command to run.>
  <verify command, e.g. the task's targeted test — NOT the full suite>
If green: mark this task done here, commit, start Task <N+1>.
If red: <where the failure is / what to look at — see Dead ends below>.

## Working state / uncommitted changes
- Modified: <path> (<why>, unstaged)
- <stash state, if any>
- `git status` and `git diff` will show the real state.

## Dead ends — do NOT retry
- <approach tried + why it failed, one line each — so no provider re-explores it this task>
- (Keep this list here in CURRENT.md; that way nobody has to trawl docs/state/sessions/ to avoid a known dead end. Prune entries once they're no longer relevant.)

## Guardrails for THIS task (do not violate)
- <task-specific invariant 1>
- <anything expensive to get wrong, e.g. "do NOT run the full test suite mid-task">

## Open questions / decisions pending
- <None, or the blocking question. A pending decision blocks the next task until resolved
   and gets logged in docs/DECISIONS.md once made.>
-->
