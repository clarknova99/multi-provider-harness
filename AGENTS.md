# AGENTS.md — <PROJECT_NAME>

> One-line description of what this project is and its single most important reason to exist.

This file is the source of truth for every AI coding tool used on this project (Claude Code, ChatGPT Codex, Cursor, Gemini CLI). Keep it lean — every token here loads on every turn, and Codex truncates past 32 KiB. Put depth in `.agents/skills/*/SKILL.md`, not here. This harness is **standalone**: it depends on no external plugin or framework. Everything it needs is in this repo.

## What this project is
<2–4 sentences. What it does, who it's for, and the one differentiator that must never be compromised. If this is a brand-new scaffold, leave this until you run [`initiating-a-project`](.agents/skills/initiating-a-project/SKILL.md) — it fills this in from your product brief.>

## Where the code lives
<Point to the main source dir and give a one-line map of the top-level modules/packages.>

```
src/moduleA     <what it is>
src/moduleB     <what it is>
tests/          <what it is>
```

## Quickstart
```bash
<build command>
<test command>
<run command>
```

## Non-negotiable invariants
1. <The single most important rule that must never be broken. Point to a skill for detail.>
2. <Second invariant.>
3. <Add project-specific invariants. Keep them short; link skills for the full story.>

## Execution state & cross-provider handoff (READ THIS FIRST, every session)
This project is worked by multiple AI providers, switched mid-task when usage limits trip. **Chat history and any single tool's native `/resume` do NOT transfer between providers.** On-disk state in `docs/state/` is the ONLY source of continuity, and **[`docs/state/CURRENT.md`](docs/state/CURRENT.md) is the one file that must always be true.** Every session:

1. **START by reading `docs/state/CURRENT.md`** before anything else — it holds the active task, what's done, the exact next action, the dead ends already tried for this task, and any uncommitted state. Then run `git status` and `git log --oneline -5` to confirm reality matches it.
2. **Crash check — usage-limit cutoffs are abrupt, with no warning.** A provider that hits a limit is killed mid-turn, with no chance to checkpoint, so expect to inherit a dirty tree and a slightly stale CURRENT.md — that's the *normal* handoff, not an error. If `git status` shows uncommitted changes CURRENT.md doesn't explain, assume an abrupt stop: read the `git diff`, deduce what the last agent was doing, reconcile CURRENT.md to reality, and only then continue. Never blindly discard uncommitted work or assume it was finished.
3. **Do the "Next action" in CURRENT.md first.** Don't re-plan, re-explore, or restart, and don't repeat the dead ends CURRENT.md lists. The fuller history in `docs/state/sessions/` is an archive — consult it only if CURRENT.md is missing a detail you need, not on every session.
4. **Also check `docs/plans/` for pending work:** resume anything `Status: IN_PROGRESS`, and **surface (don't silently skip or auto-start) anything `Status: DRAFT`** — an approved-but-unstarted plan has no "in progress" signal, so it's easy to miss. See [`checkpointing-progress`](.agents/skills/checkpointing-progress/SKILL.md).
5. **Checkpoint = update ONE file, then commit.** At each task boundary, overwrite `CURRENT.md` with the new reality (done, next action, dead ends, uncommitted state) and commit. That single write plus the commit *is* the handoff — don't burn tokens maintaining parallel bookkeeping mid-task. The other state files are optional and event-driven, written only when they earn their keep: a per-plan progress ledger in `docs/plans/` for a large multi-session feature, a `docs/state/sessions/` entry when you stop for the day or hit a limit, a `docs/DECISIONS.md` entry when you actually decide something, an `.agents/memory/` note when you learn something durable.
6. **Keep CURRENT.md short, and prefer stopping at a commit.** It's a synthesized snapshot (a screenful), not a running log — if it grows every session, you're logging where you should be summarizing. If you must stop mid-task, capture the exact uncommitted state so the next provider can reconstruct it from `git diff`.

## Starting a new project (from a product brief)
If this repo is a fresh scaffold with no product yet, begin here. The flow turns a human-written product brief into everything the harness needs to start building — modeled on the "brief → PRD → build" idea, but native and dependency-free:

1. **Human writes a product brief** — copy `docs/product/_TEMPLATE-product-brief.md` to `docs/product/product-brief.md` and fill in what you know, even roughly.
2. **Run [`initiating-a-project`](.agents/skills/initiating-a-project/SKILL.md).** It reads the brief, **asks you about anything critical that's missing** (target users, the one differentiator, success metrics, scope boundaries, hard constraints), and writes a complete **PRD** to `docs/product/PRD.md`.
3. **Populate the harness.** The same skill helps you fill in this `AGENTS.md` (project name, what it is, where code lives, invariants, build/test/run commands) and seed `docs/system/` with the intended capabilities.
4. **Build the first slice.** From the PRD, pick the first feature, write its spec (`docs/specs/`) and plan (`docs/plans/`), and execute. Everything from "spec" onward is the normal loop below.

## Workflow (local, provider-independent, no plugins)
The **required spine** for any change is: **spec → plan → execute (test-first) → verify → checkpoint**. Optional tools slot in where they add value — don't run them as mandatory ceremony.

1. *(New project only)* **Initiate** — brief → PRD → populate harness → [`initiating-a-project`](.agents/skills/initiating-a-project/SKILL.md).
2. *(Optional)* **Brainstorm** — expand a rough idea into a coherent design + a menu of approaches → [`brainstorming`](.agents/skills/brainstorming/SKILL.md). Reach for this when the shape isn't obvious yet.
3. *(Optional)* **Idea review** — adversarially pressure-test a risky design before it earns a spec; record the kill/proceed verdict in [`docs/DECISIONS.md`](docs/DECISIONS.md) → [`idea-review`](.agents/skills/idea-review/SKILL.md).
4. **Spec** — write the `DRAFT` spec in `docs/specs/` from `_TEMPLATE-spec.md` (the `product-manager` persona can author it).
5. **Plan** — write the task-by-task plan + progress ledger in `docs/plans/` from the templates; [`checkpointing-progress`](.agents/skills/checkpointing-progress/SKILL.md) owns the `DRAFT`/`IN_PROGRESS`/`FINAL` lifecycle.
6. **Execute** — drive the plan one task at a time, a subagent per independent task, one commit per task; write the failing test first (red → green → refactor) → [`executing-plans`](.agents/skills/executing-plans/SKILL.md) + [`test-driven-development`](.agents/skills/test-driven-development/SKILL.md).
7. **Verify + review** — the build+test gate stays green, then a `code-reviewer`-persona pass before the work is called done → [`verify`](.agents/skills/verify/SKILL.md).
8. **Checkpoint + hand off** — at every task boundary do the [Execution state](#execution-state--cross-provider-handoff-read-this-first-every-session) updates (CURRENT + progress ledger + session log + commit). This is the cross-provider handoff; nothing else replaces it.

## Skill routing table
When your task matches a row, read that skill's `SKILL.md` first. When no row fits, read the onboarding skill first to place the work.

| If you need to… | Read |
|---|---|
| Get oriented / build / run / debug | [`.agents/skills/onboarding/SKILL.md`](.agents/skills/onboarding/SKILL.md) |
| Start a brand-new project from a product brief | [`.agents/skills/initiating-a-project/SKILL.md`](.agents/skills/initiating-a-project/SKILL.md) |
| Refine a rough idea into a design (generative, optional) | [`.agents/skills/brainstorming/SKILL.md`](.agents/skills/brainstorming/SKILL.md) |
| Pressure-test / kill an idea before it earns a spec (adversarial, optional) | [`.agents/skills/idea-review/SKILL.md`](.agents/skills/idea-review/SKILL.md) |
| Keep multi-step work resumable / resume or surface pending work | [`.agents/skills/checkpointing-progress/SKILL.md`](.agents/skills/checkpointing-progress/SKILL.md) |
| Execute an approved plan task-by-task | [`.agents/skills/executing-plans/SKILL.md`](.agents/skills/executing-plans/SKILL.md) |
| Write code test-first (red → green → refactor) | [`.agents/skills/test-driven-development/SKILL.md`](.agents/skills/test-driven-development/SKILL.md) |
| Prove a change is good (build + test gate) | [`.agents/skills/verify/SKILL.md`](.agents/skills/verify/SKILL.md) |
| Review a change before it lands | [`code-reviewer` persona](.agents/agents/code-reviewer.md) |
| Add a new capability workflow as a skill | [`.agents/skills/_template/SKILL.md`](.agents/skills/_template/SKILL.md) |
| <task> | <skill path> |

**Adding a skill:** copy `.agents/skills/_template/` to `.agents/skills/<kebab-verb-phrase>/SKILL.md`, fill the frontmatter (`name` = folder name; `description` = what it covers AND when to consult it), then add a row above. Keep each `SKILL.md` skimmable (act after one read, ~60 lines) and reference real files/symbols.

## Agents (personas)
Role personas live in [`.agents/agents/`](.agents/agents/). Invoke a persona when the task calls for that lens (scoping / PRD / spec → `product-manager`; design & architecture → `principal-engineer`; UX → `ux-design-reviewer`; test strategy → `qa-analyst`; pre-commit review → `code-reviewer`). See each file for its charter and boundaries. Codex reads the mirror adapters in `.codex/agents/*.toml`; keep the two in sync (the `.md` files are canonical).

## Agent memory
Persistent memory lives in [`.agents/memory/`](.agents/memory/), checked into the repo so it is shared across tools and machines.
- One markdown file per fact/learning, with frontmatter (`name`, `description`, `metadata.type`: `user` | `feedback` | `project` | `reference`).
- [`.agents/memory/MEMORY.md`](.agents/memory/MEMORY.md) is the index — one line per memory, no content in the index.
- Before saving, check for an existing file on the topic and update it rather than duplicate; delete memories that turn out wrong. Don't record what the repo already encodes.
- **Capture memory at the moment of learning, not only at end of day** — a durable gotcha, infra trap, or rejected approach gets written the moment it's found, so it survives a mid-task provider switch.

## Documentation conventions
- **Product intent = `docs/product/`.** The human's `product-brief.md` and the generated `PRD.md` — the "what & why" of the product as a whole. Seeded once at project start; updated when product direction shifts.
- **Living spec = `docs/system/`.** One file per capability, no dates, no status line — always reflects current behavior. When a plan ships, fold its outcome here. If it's wrong, that's a bug.
- **Change proposals = `docs/specs/`**, dated `YYYY-MM-DD-<topic>-*.md`, with a `Status:` line (`DRAFT` / `IN_PROGRESS` / `FINAL`) and a `## Changelog`.
- **Implementation plans = `docs/plans/`**, each with a progress file and a `Status:` line. Resume anything `IN_PROGRESS`; surface (don't auto-start) anything `DRAFT`.
- **Decisions = `docs/DECISIONS.md`**, append-only ADR entries. Superseding a decision means a new entry, never editing the old one.
- **Keep the top of every doc true.** Edit in place when reality changes; append the "why" to the `## Changelog`. A reader must be able to trust the top without reading the changelog.
- **No artificial line breaks in markdown.** One paragraph = one continuous line (the editor soft-wraps). Lists, tables, headings, code blocks are fine.

## Conventions in one breath
<Match surrounding style. State the 2–3 code conventions that differ from language defaults — e.g. error handling, concurrency model, where new cross-cutting types go. Be specific and behavioral, not aspirational. If this is a fresh scaffold, `initiating-a-project` helps you fill this in from the PRD.>
