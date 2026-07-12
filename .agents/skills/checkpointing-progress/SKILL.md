---
name: checkpointing-progress
description: How to keep multi-step work resumable by ANY agent (on any provider) if the current one runs out of context/tokens mid-task, AND how a fresh or continuing agent checks for and surfaces BOTH in-progress work AND already-approved-but-unstarted plans before starting something new. Also covers keeping product docs/specs/plans as living documents (DRAFT/IN_PROGRESS/FINAL + Changelog) that stay true as implementation diverges. Use whenever you start non-trivial multi-step work, whenever implementation reveals a doc needs to change, AND at the start of every session as a quick check for pending work — especially if the ask sounds like "keep going," "continue," "where were we," "pick up," or "what should I work on," or if `docs/plans/` has any `Status: DRAFT` or `Status: IN_PROGRESS` files.
---
# Skill: Checkpoint progress so work survives an interrupted agent

Chat context and any in-tool todo list do not survive a new session, a context-limit cutoff, or a switch to another provider — only what's on disk does. For any task that could plausibly span more than one sitting, keep a progress file on disk that a completely fresh agent can read cold and continue from, with no memory of this conversation.

This skill has two halves: **writing** a checkpoint (below, "Steps") and **checking for/surfacing** pending work before starting something new (below, "Resuming/surfacing — do this first") — including work that's merely `DRAFT` (approved, not yet started), not just work already `IN_PROGRESS`. Both matter; a checkpoint nobody reads is wasted effort, and so is a plan nobody remembers exists.

## Resuming/surfacing — do this first, before starting any non-trivial task
0. Read [`docs/state/CURRENT.md`](../../../docs/state/CURRENT.md) and reconcile with `git status` / `git log --oneline -5`. CURRENT is the cross-provider routing snapshot; execute its next action. **Crash recovery:** usage-limit cutoffs are abrupt — the previous provider was killed mid-turn with no chance to checkpoint, so a dirty tree plus a slightly stale CURRENT.md is the *normal* way a limit-terminated session hands off, not a bug. If the tree has uncommitted changes CURRENT.md doesn't explain, read the `git diff`, work out what the last agent was mid-way through, and reconcile CURRENT.md to reality *before* doing anything else.
1. Check `docs/plans/*.md` for a `Status:` line (`grep -l "Status:" docs/plans/*.md 2>/dev/null` or Glob+read). This must catch **both** cases, not just one:
   - **`Status: IN_PROGRESS`** with a matching `*-progress.md` — a previous agent was mid-task. Read it before touching code or asking the user what to do.
   - **`Status: DRAFT`** with no matching `*-progress.md` yet — an approved plan that nobody has started. This is easy to miss (there's no "in progress" signal at all), which is exactly why it's dangerous to skip: approved, decided work can sit invisible indefinitely if the check only looks for `IN_PROGRESS`.
2. For an `IN_PROGRESS` find: cross-check it against reality (`git log`, `git status`) before trusting it — a progress file only helps if it matches the actual tree. If the "Done" section claims a commit that isn't in `git log`, or the tree has uncommitted changes the file doesn't mention, reconcile first (the file may itself be stale from an even earlier interrupted attempt). Then resume from its "In progress"/"Not started" sections directly — don't re-derive the plan, don't re-ask questions the linked spec/plan already answered.
3. For a `DRAFT` find: **surface it, don't auto-start it.** Tell the user it exists ("Found an approved, unstarted plan: `docs/plans/<name>.md` — want me to start it, or is there something else first?") rather than silently launching multi-step work the user didn't ask for this turn, and rather than silently ignoring it because the request didn't name it.
4. If the user's request is ambiguous about whether they want to resume/start this vs. something else, and a matching file exists (either status), surface it explicitly rather than silently picking one.

## Where things are
`docs/state/CURRENT.md` — cross-provider active snapshot (one file, overwritten at task boundaries; points to the active ledger below). `docs/state/sessions/` — append-only handoff logs (where work stopped, next action, rejected approaches, memory-promotion notes).

`docs/plans/<topic>-progress.md` — one file per active plan/feature, named to match its plan/spec. Committed to git alongside the code changes it describes, not gitignored — it must survive exactly like the code does. Specs live in the sibling `docs/specs/` directory while active; FINAL artifacts are folded into `docs/system/` and the bundle can be archived. None of this depends on any plugin — it's a plain project convention documented in AGENTS.md's "Documentation conventions."

## Status lifecycle for product docs, specs, AND plans
The PRD (`docs/product/PRD.md`), each spec (`docs/specs/`), and its plan/progress file (`docs/plans/`) carry a one-line `Status:` near the top:
- **`DRAFT`** — approved design/plan, implementation not yet started.
- **`IN_PROGRESS`** — implementation underway. This is the status for the whole duration of the build, including when reality diverges from the original design — divergence doesn't get its own status, it gets a Changelog entry.
- **`FINAL`** — shipped. The document, as it now reads, matches what's actually in the code.

**The rule that matters most: the top of the document must always reflect current truth.** If implementation reveals the spec's design (or the plan's steps) needs to change — a bad assumption, a simpler approach found, a constraint discovered late — **edit that document in place** so anyone reading it top-to-bottom gets the accurate current picture, never the stale original plan. Then append a dated entry to that document's `## Changelog` section (add one if it doesn't exist) stating what changed and why. The changelog is where history/rationale lives; the rest of the document is where truth lives. A reader should never have to cross-reference the changelog just to know what's currently true — only to understand *why* it changed.

This can touch either document, both, or neither, depending on what actually changed:
- Design/intent changed (a different architecture than specified) → edit the **spec**, changelog entry there.
- Only the steps/sequencing changed, not the destination → edit the **plan**, changelog entry there.
- Both → edit both, each with its own changelog entry (they don't share one changelog).

## Steps (writing a progress checkpoint)
**Match the ceremony to the work.** The always-required checkpoint is small: keep `docs/state/CURRENT.md` true (done, next action, dead ends, uncommitted state) and commit. A separate `docs/plans/<topic>-progress.md` ledger earns its keep only for a large feature spanning several sessions, where CURRENT.md alone can't hold the detail — don't create one for a task that doesn't need it. The goal is resumability, not paperwork. When you do keep a ledger:
1. **Create the progress file when work starts**, not when it ends. Link the spec/plan it belongs to at the top, and set its `Status: DRAFT` until implementation actually begins, then `IN_PROGRESS`.
2. Track state under three headings: **Done** (with the commit hash each step landed in), **In progress** (what's underway right now, what's actually been touched on disk, whether the build is currently green or red, and *why* this approach — the reasoning a fresh agent would otherwise have to reconstruct), **Not started**.
3. **Update it at natural checkpoints**: immediately after each todo item completes (mirror it here — an in-tool todo list won't be visible to the next agent), before attempting anything risky or multi-file, and right before ending a turn if anything is left mid-stream.
4. Add a **Gotchas / decisions** section for anything non-obvious hit along the way — a dead end tried and abandoned, a constraint discovered late — so it isn't rediscovered at cost by whoever picks this up next. If the discovery actually changes the spec or plan's substance, that's also a Changelog entry per the lifecycle rule above, not just a gotcha note.
5. When the feature ships, set `Status: FINAL` on both the spec and the plan (or delete the plan/progress file if the team prefers a clean tree, but the spec stays as the permanent FINAL record) rather than leaving either stale — a lingering `IN_PROGRESS` file for finished work will falsely trigger the resume check above for every future task.
6. **Delivery step:** fold delivered behavior into `docs/system/`, reconcile README and affected `.agents/skills/` entries, then update `docs/state/CURRENT.md` to route the next active task.
7. **Before each task commit:** ask *did this task surface a learning that will outlive it?* Promote durable project-scoped learnings to `.agents/memory/` (and index in `MEMORY.md`); keep task-scoped dead ends in `docs/state/sessions/` only. Append a session-log entry at task boundaries with where work stopped, next action, and verification command.

## Conventions to keep
- One progress file per plan, not one giant running log for the whole project.
- Never let it go stale relative to the actual tree state — an inaccurate progress file is worse than none, since it actively misleads the next agent. If unsure it's current, `git status`/`git diff` first and reconcile before trusting it.
- This progress file is the *state* layer under [`executing-plans`](../executing-plans/SKILL.md): the plan says what to build, the progress file says how far along it is right now.

## Gotchas
- Don't just log "step 3 done" — log *why* a non-obvious choice was made. The next agent needs the reasoning, not just the checklist state, or it may "fix" a deliberate choice back to something wrong.
- If the build/tests are intentionally red mid-refactor, say so explicitly — otherwise a fresh agent may burn time assuming it broke something and start debugging instead of continuing the refactor.

## Verify
A fresh agent (or a fresh conversation with a different subagent) should be able to read only the progress file + spec + plan, run `git log`/`git status`, and correctly state what to do next without any other context.
