# Decisions Log (ADRs)

> Append-only record of every non-trivial decision and the rationale behind it. This answers "why is the system the way it is?" — distinct from a spec's `## Changelog`, which answers "why did this document change?"
>
> **Rules:**
> - One entry per decision. Newest at the bottom (append-only).
> - **Never edit a past entry.** Superseding a decision means a NEW entry with `Status: Supersedes ADR-NNN`.
> - Both accepted and rejected decisions belong here — a killed idea recorded here won't be re-proposed.
> - Number sequentially: ADR-001, ADR-002, …

---

## ADR-001 — Adopt the standalone cross-tool harness + handoff protocol (<YYYY-MM-DD>)
**Status:** Accepted
**Context:** Work is done across multiple AI providers (Claude Code, Codex, Cursor, Gemini), switched when usage limits trip. Chat history and any single tool's native `/resume` don't transfer between providers.
**Decision:** Standardize on `AGENTS.md` + `.agents/` as the single source of truth, with thin per-tool pointer files (`CLAUDE.md` symlink, `.codex/`, `.cursor/rules/`, `.gemini/settings.json`, `.github/copilot-instructions.md`), and keep live execution state in `docs/state/` so any provider can resume mid-task. The harness is self-contained — no external plugin or framework is required.
**Alternatives rejected:** Installing a bundled framework that ships its own parallel `AGENTS.md`/config — rejected because a second config competes with `AGENTS.md` for authority ("whichever the tool reads last" ambiguity), which breaks the single-source-of-truth guarantee that makes mid-task switching safe.
**Consequences:** Every provider reads the same files; handoffs are lossless at commit boundaries; one place to edit any rule. Cost: the per-tool pointers must be kept wired (guarded by `scripts/verify-harness.sh`).

## ADR-002 — Native project-initiation flow (brief → PRD → spec) instead of a bundled method framework (<YYYY-MM-DD>)
**Status:** Accepted
**Context:** A brand-new project needs a way to go from a rough human idea to something the harness's spec/plan machinery can act on. Method frameworks (e.g. the BMAD style of brief → PRD → epics → stories) solve this well, but they ship as their own toolchain with their own config.
**Decision:** Implement the initiation flow **natively** as a skill (`initiating-a-project`) plus templates (`docs/product/_TEMPLATE-product-brief.md`, `_TEMPLATE-prd.md`) that obey `AGENTS.md` rather than replacing it. The human supplies a product brief; the flow turns it into a PRD (asking for missing critical info), then populates the harness. Brainstorming and idea-review are optional downstream tools, not required gates.
**Alternatives rejected:** (a) Bundling a method framework — same authority conflict as ADR-001. (b) A fuller brief → PRD → epics → stories hierarchy — deferred as heavier than this harness needs; the PRD feeds specs directly.
**Consequences:** Project startup is covered with no new dependency; the PRD is a living doc under the same lifecycle as specs. Cost: the initiation flow is lighter than a full method framework (no epic/story layer) — revisit if a project outgrows it.

## ADR-003 — Harden the state model against abrupt stops and bookkeeping overhead (2026-07-12)
**Status:** Accepted
**Context:** A design review flagged that (a) usage-limit cutoffs are abrupt, so the graceful "update CURRENT.md then stop" assumption often fails and leaves a dirty tree with stale state; (b) requiring per-task updates to several files (CURRENT + progress ledger + session log + decisions + memory) is real overhead that burns the very tokens/limits the harness exists to conserve; (c) reading CURRENT + plan + spec + a directory of session logs every session bloats context; (d) GUI tools (Cursor, Copilot) are more reactive than CLIs, so it's worth confirming they actually load the instruction files; (e) symlinks break on ZIP downloads and some Windows checkouts.
**Decision:** Make `docs/state/CURRENT.md` the single always-required state file and the single required per-task write; add an explicit crash-recovery step (a dirty tree + stale CURRENT is the *expected* handoff — reconcile from `git diff` before proceeding); keep CURRENT.md short and carry the active task's "don't retry" list in it so `docs/state/sessions/` is an archive, not required reading; make the progress ledger, session log, DECISIONS, and memory event-driven and optional; note that GUI tools load `AGENTS.md` through their pointer files and generally follow CURRENT.md once loaded, with a caveat to sanity-check that early and nudge with "read CURRENT.md and resume" if needed; and have `verify-harness.sh` detect a flattened symlink and point at `setup-harness.sh`.
**Alternatives rejected:** (a) Collapsing all state into one `STATE.md` — the append-only "tried and rejected" history and the decisions log serve a different purpose than the overwritten snapshot, and folding history into the snapshot reintroduces the context-bloat problem; the chosen middle path keeps the snapshot single-and-required while leaving the deeper layers optional. (b) Dropping TDD — kept as a recommended discipline, with the enforceable bar being "the verify gate is green," not the ritual. (c) Converting memory to one append-only journal — one-fact-per-file recall and pruning beats an unbounded journal. (d) A copy-mode setup script instead of symlinks — real copies drift, defeating the single-source guarantee.
**Consequences:** Less per-task paperwork; resilient to the common abrupt-stop case; smaller per-session context. Cost: for a large multi-session feature the optional progress ledger is now a judgment call rather than automatic, so an agent must notice when detail has outgrown CURRENT.md.

<!-- Template for new entries:

## ADR-NNN — <short decision title> (<YYYY-MM-DD>)
**Status:** Accepted | Rejected | Supersedes ADR-MMM
**Context:** <the problem / forces at play>
**Decision:** <what was decided>
**Alternatives rejected:** <what else was considered and why not>
**Consequences:** <what this makes easier/harder; any debt taken on>
**Links:** <spec, plan, or memory references>
-->
