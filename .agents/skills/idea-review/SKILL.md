---
name: idea-review
description: Run a multi-persona adversarial review of a proposed idea before it earns a spec — a "red team" that tries to kill the idea, so only ideas that survive scrutiny enter a build cycle. Use when evaluating whether a risky or expensive idea is worth building, or pressure-testing a proposal after generative brainstorming. Optional, not a required gate.
---
# Skill: Idea review (adversarial pre-spec gate)

The purpose of this gate is to find the reason an idea should NOT be built before any time goes into a spec or code. This is the structured "red team" step: it produces a decision, and that decision gets recorded.

**This is the *adversarial* half of the idea workflow, and it is optional.** Run [`brainstorming`](../brainstorming/SKILL.md) FIRST if the shape is still unclear (that's the *generative* half). Then run this gate to attack the resulting design. Brainstorming grows ideas; this gate prunes them. Use it when an idea is risky, expensive, or hard to reverse — skip it for small, obvious changes and go straight to a spec.

## How to run it
Convene the relevant personas from `.agents/agents/` and give each an explicit adversarial charge. Run them as separate perspectives (in one session, or as parallel subagents if your tool supports it):

- **product-manager** — Does this serve a real user need, or is it a solution looking for a problem? Does it fight the product's core differentiator? What's the smaller version?
- **principal-engineer** — What does this cost architecturally? Does it force a parallel code path or violate an invariant? What breaks at scale?
- **ux-design-reviewer** — Will users discover and understand it? Does it add chrome or confusion?
- **qa-analyst** — How would this fail in the field? What's expensive to verify?

Each persona's job is to find the strongest reason to NOT build it. Steelman the objections; don't rubber-stamp.

## The gate
After the panel:
- **Killed** — record why in `docs/DECISIONS.md` (a rejected idea is a decision worth remembering, so it isn't re-proposed). Stop.
- **Survives** — record the surviving rationale AND the serious objections raised (with how they'll be mitigated) in `docs/DECISIONS.md`, then write the spec in `docs/specs/` with `Status: DRAFT`.

## Conventions to keep
- When you run this gate, it produces a `docs/DECISIONS.md` entry, kill or proceed — that's the link between the idea and the decision log.
- Don't let the panel become a formality. If nothing is challenged, the review didn't happen.

## Output
A short verdict: KILLED (with reason) or PROCEED (with surviving rationale, top objections, and mitigations), plus the `docs/DECISIONS.md` entry and — if proceeding — the DRAFT spec path.
