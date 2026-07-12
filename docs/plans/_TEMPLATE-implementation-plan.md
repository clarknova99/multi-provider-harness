# <Topic> — Implementation Plan

> **For agentic workers:** Execute this plan task-by-task with the [`executing-plans`](../../.agents/skills/executing-plans/SKILL.md) skill — subagent-driven where independent, one commit per task, the verify gate green plus a `docs/state/CURRENT.md` checkpoint after each. Steps use checkbox (`- [ ]`) syntax for durable tracking.

**Status: DRAFT**

**Spec:** `docs/specs/YYYY-MM-DD-<topic>-design.md`

**Progress:** `docs/plans/YYYY-MM-DD-<topic>-progress.md`

**Goal:** One sentence describing the shipped outcome.

**Architecture:** How this plan maps onto the codebase's modules/layers and which `docs/system/` file(s) it updates.

**Tech Stack:** List only what this plan actually touches.

## Global Constraints
- Preserve the non-negotiable invariants in `AGENTS.md`.
- The [`verify`](../../.agents/skills/verify/SKILL.md) gate must stay green after each task unless the plan explicitly allows a brief intentional red mid-refactor (say so in the progress ledger).
- Every task updates the progress ledger, `docs/state/CURRENT.md`, and the session log at boundaries.
- **Memory checkpoint (before each task commit):** ask *did this task surface a learning that will outlive it?* Promote durable project-scoped learnings to `.agents/memory/`; keep task-scoped dead ends in `docs/state/sessions/` only.
- User-reachable UI changes require whatever integration/UI test the project uses, added in the same task.

## Task 1: <First task title>

**Files:**
- Modify: `path/to/file.ext`

**Interfaces:**
- What this task produces or changes.

- [ ] **Step 1: <Step title>** — write the failing test first (see `test-driven-development`).
- [ ] **Step 2: Verify** — run the project's verify gate; confirm green.

## Final task: System update, docs reconcile, and handoff

- [ ] Fold delivered behavior into the target `docs/system/` document(s) named in the spec.
- [ ] Reconcile README, the PRD if scope shifted, and affected `.agents/skills/` entries.
- [ ] Set `Status: FINAL` on spec, plan, and progress; record commit hashes and verification evidence.
- [ ] Update `docs/state/CURRENT.md` to route the next active task.

## Changelog
- **YYYY-MM-DD** — Created DRAFT from `_TEMPLATE-implementation-plan.md`.
