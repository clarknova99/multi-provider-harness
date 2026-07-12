---
name: onboarding
description: Get oriented in this project — how to build, run, test, and debug, and how the code is laid out. Read this FIRST when you have no more specific skill for the task, or when you are a fresh agent placing a new piece of work.
---
# Skill: Get oriented and place the work

The goal of this skill is to go from "cold start" to "I know where this change belongs and how to prove it works" in one read.

## First, always
1. Read [`docs/state/CURRENT.md`](../../../docs/state/CURRENT.md) — if a task is active, resume it; do not start something new. Also check `docs/plans/` for `Status: IN_PROGRESS` (resume) or `Status: DRAFT` (surface it) — see [`checkpointing-progress`](../checkpointing-progress/SKILL.md).
2. Read [`../../../AGENTS.md`](../../../AGENTS.md) invariants — these are non-negotiable.
3. Skim [`docs/system/`](../../../docs/system/) for the current behavior of the area you're touching.

## Is this a brand-new project?
If `AGENTS.md` still has `<PROJECT_NAME>` and `<...>` placeholders and there's no product yet, don't guess — start with [`initiating-a-project`](../initiating-a-project/SKILL.md): product brief → PRD → populated harness.

## Build / run / test
```bash
<build command>
<test command>
<run command>
```

## Where the code lives
<One-line map of the top-level modules. Mirror AGENTS.md "Where the code lives".>

## How to place a new change
- Which module/layer does it belong in? <rule of thumb>
- Is there an existing abstraction to extend rather than a parallel path to add?
- Which invariant(s) constrain it? (See AGENTS.md.)
- Which skill covers the specific work? (See the routing table in AGENTS.md.)

## Verify
The project's verification gate is:
```bash
<the canonical verify command — build + tests>
```
Run it before considering any change done. See [`verify`](../verify/SKILL.md).

## Reference
<Point at a representative existing module to model new work after.>
