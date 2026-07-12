---
name: executing-plans
description: How to execute a written implementation plan in docs/plans/ task-by-task — subagent-driven where independent, one commit per task, the verify gate green before each commit, and the cross-provider checkpoint after each. Use whenever you have an approved plan to implement (Status DRAFT/IN_PROGRESS), when the user says "start the plan", "keep going", "implement task N", or when resuming interrupted plan work.
---
# Skill: Executing plans (subagent-driven, checkpointed)

You have a written plan in `docs/plans/` with checkbox tasks. Execute it task by task — never all at once, never skipping the per-task gate.

## Before you start
Run the resume/surfacing check in [`checkpointing-progress`](../checkpointing-progress/SKILL.md): read `docs/state/CURRENT.md`, reconcile with `git status` / `git log`, and confirm which task is next. If a `*-progress.md` ledger disagrees with the tree, trust the tree and reconcile the ledger first.

## The per-task loop
For each task, in order:
1. **Scope it.** Read the task's Files / Interfaces / Steps. It should be one coherent, committable unit. If it's really several, do them as sub-steps but still commit once per task.
2. **Dispatch.** Independent tasks (no shared files, no ordering dependency) can each run in their own subagent — spawn them in parallel, handing each the task text plus the plan's Global Constraints. Tasks that share files or must be sequenced run in order in the main line. Never parallelize work that touches the same file.
3. **Build it test-first.** Follow [`test-driven-development`](../test-driven-development/SKILL.md): failing test (red) → least code (green) → refactor. UI-facing tasks also add whatever integration/UI coverage the plan names.
4. **Verify.** The project's [`verify`](../verify/SKILL.md) gate must be green. If the plan explicitly allows an intentional red mid-refactor, say so in the ledger.
5. **Review.** A `code-reviewer`-persona pass on the task's diff before it's called done; fix findings or record why they're deferred.
6. **Commit + checkpoint.** One commit for the task, then update `docs/state/CURRENT.md` (done, next action, dead ends, uncommitted state) — that's the one required write. If this plan keeps a `*-progress.md` ledger, tick its checkbox too; add a session-log line only when you stop, and an `.agents/memory/` note only when you learned something durable. Don't let the bookkeeping outweigh the task.

## Whole-branch review before FINAL
After the last task, review the **entire** branch diff, not just the per-task diffs — cross-task seams hide bugs no single task's review could catch. Only then run the plan's Final task (fold into `docs/system/`, reconcile README/docs/skills, set `Status: FINAL`, archive) per [`checkpointing-progress`](../checkpointing-progress/SKILL.md).

## Conventions
- One commit per task; small reviewable diffs beat one big drop. Don't push unless asked.
- The checkpoint in step 6 is what makes the work resumable by a *different provider* — it is not optional convenience. Update `CURRENT.md` regardless of which tool you're in, or the next provider loses the thread.
