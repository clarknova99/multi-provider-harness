---
name: initiating-a-project
description: Turn a human-written product brief into a complete PRD and a populated harness, so a brand-new project goes from "rough idea" to "ready to write specs." Use at the very start of a new project (empty scaffold, placeholders still in AGENTS.md), when the user hands you a product brief, or when they say "start a new project," "here's my idea," or "turn this into a PRD." Ask the human for missing critical information rather than inventing it.
---
# Skill: Initiate a project (product brief → PRD → populated harness)

This is the front door for a brand-new project. It bridges a human's rough product brief to the point where the normal harness loop (spec → plan → execute) takes over. It's inspired by the "brief → PRD → build" method, implemented natively — no external framework, no dependency.

## The flow
1. **Get the brief.** The human copies `docs/product/_TEMPLATE-product-brief.md` to `docs/product/product-brief.md` and fills in what they know. If they pasted an idea into chat instead, capture it into that file first — the brief must exist on disk, because it's the durable input a later provider can re-read.
2. **Read the brief and find the gaps.** Compare it against what a PRD requires (checklist below). List every gap.
3. **Ask the human about critical gaps — don't invent them.** See "Ask vs. assume".
4. **Write the PRD** to `docs/product/PRD.md` from `_TEMPLATE-prd.md`.
5. **Populate the harness from the PRD** (see "Populate the harness").
6. **Hand off to the normal loop:** pick the first feature/slice from the PRD, write its spec (`docs/specs/`) and plan (`docs/plans/`), and execute. Everything downstream already exists in this harness.

## What a PRD must contain (the required-information checklist)
A PRD is "done" only when each of these is answered — this list is exactly what makes a spec writable:
- **Problem & why now** — the pain, who has it, why it's worth solving now.
- **Target users / personas** — who this is for, concretely.
- **The one differentiator** — the single thing this product must do better than the alternatives; its reason to exist. (This usually becomes invariant #1 in `AGENTS.md`.)
- **Goals & success metrics** — how you'll know it worked (measurable where possible).
- **Scope: in / out** — the MVP boundary and explicit non-goals.
- **Key features / capabilities** — the handful that deliver the differentiator, roughly prioritized.
- **Constraints** — platform, tech stack, timeline, budget, compliance, team.
- **Assumptions & risks** — what you're betting on and what could sink it.
- **Open questions** — anything still unresolved (carry these forward, don't hide them).

## Ask vs. assume
- **Ask the human** when a missing answer changes *what gets built*: the differentiator, target users, the MVP scope boundary, hard constraints (platform/compliance/deadline), success metrics. Batch these into one clear list rather than dribbling them out one at a time.
- **Assume and state it** when there's a conventional default and the choice is low-stakes or easily reversed (a doc format, a naming convention). Record the assumption in the PRD's "Assumptions" section so it stays visible and correctable.
- **Never fabricate** a metric, a user, or a differentiator to fill a blank. A confident-but-wrong PRD produces confident-but-wrong specs. A visible "OPEN QUESTION" beats an invented answer every time.

## Populate the harness (from the PRD)
Once the PRD exists, use it to make the scaffold real:
- **`AGENTS.md`** — fill in `<PROJECT_NAME>`, "What this project is" (from problem + differentiator), "Non-negotiable invariants" (the differentiator is usually invariant #1), "Where the code lives", "Quickstart" (build/test/run commands), and "Conventions in one breath".
- **`docs/system/`** — seed one capability file per major intended capability. They describe *intended* behavior now and become *current* behavior as features ship.
- **`docs/DECISIONS.md`** — log any foundational choices already made (stack, platform, architecture direction) as ADR-002 onward.
- **`docs/state/CURRENT.md`** — set the first active task (usually "write the spec for <first feature>").

## Conventions to keep
- The brief is the human's; the PRD is yours to draft but theirs to approve. Surface open questions and get a nod before treating the PRD as settled.
- Keep the PRD a **living document** — when product direction shifts later, edit it in place and append to its `## Changelog` (same lifecycle as specs; see [`checkpointing-progress`](../checkpointing-progress/SKILL.md)).
- Brainstorming and idea-review are **optional** downstream — reach for [`brainstorming`](../brainstorming/SKILL.md) when a feature's shape is unclear and [`idea-review`](../idea-review/SKILL.md) when an idea is risky, but neither is a required gate between the PRD and a spec.

## Output
A complete `docs/product/PRD.md` (approved by the human), a populated `AGENTS.md`, a seeded `docs/system/`, and `docs/state/CURRENT.md` pointing at the first spec to write.
