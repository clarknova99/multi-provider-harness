---
name: brainstorming
description: The generative half of the idea workflow — expand a rough idea, feature request, or vague problem into a coherent design and a short menu of approaches. Use when you start something new (a feature, a UX change, a refactor with real design choices) and the shape isn't obvious yet, or when the user says "I want to add…", "what if we…", or "how should we…". Optional, not a required gate. Pairs with idea-review, which prunes what this grows.
---
# Skill: Brainstorming (generative pre-spec exploration)

This is the *generative* half of the idea workflow; [`idea-review`](../idea-review/SKILL.md) is the *adversarial* half. Grow ideas here, prune them there. This step is **optional** — reach for it when a one-line request would otherwise jump straight to a spec that solves the wrong problem, not as mandatory ceremony for every change.

## Goal
Turn a vague ask into: a crisp problem statement, 2–4 genuinely different approaches, and a recommended direction with its open questions — enough to write a spec (or to hand to `idea-review` if the idea is risky).

## How to run it
1. **Pin the real problem, not the proposed solution.** What does the user actually need, who hits it, and how often? State it in one sentence. If the ask is already a solution ("add a tree view"), work backward to the need it serves.
2. **Check it against the core.** Does this serve the product's reason to exist (the differentiator in `AGENTS.md` / the PRD), or at least not fight it? Does it respect the `AGENTS.md` invariants? An idea that breaks an invariant needs a very good reason — surface it now, not after a spec exists.
3. **Generate 2–4 distinct approaches**, not variations of one. For each: the mechanism, where it lands in the codebase's layers/modules, and the smallest version that delivers value. Always include a "do nothing / smallest possible" option.
4. **Weigh them** on effort, risk, reversibility, and fit with existing seams (prefer extending an existing abstraction over a parallel code path). Name the tradeoffs plainly.
5. **Recommend one**, and list the open questions it still carries.

## When to ask the user vs. decide
Ask when a choice changes what gets built and you can't infer it (scope, which surface first, a hard constraint). Decide yourself — and say so — when there's a conventional default. Don't stall on questions the differentiator or an invariant already answers.

## Output → spec (optionally via idea-review)
A short brief: **problem**, **approaches considered** (with tradeoffs), **recommended direction**, **open questions**. If the idea is risky or expensive, hand that to [`idea-review`](../idea-review/SKILL.md) before writing the spec; otherwise write the `DRAFT` spec in `docs/specs/` directly.

## Conventions
- Breadth before depth: get the option space out before committing. One well-argued option is not a brainstorm.
- Keep the brief short and disposable — it's the input to the spec, not the spec itself.
