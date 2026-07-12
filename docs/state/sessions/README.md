# Session handoff logs

Append-only history of working sessions. `../CURRENT.md` is the *snapshot* (where things are now); this folder is the *history* (what each provider did, why, and — critically — what it tried and abandoned).

**One file per session**, named `<YYYY-MM-DD-HHMM>-<tool>.md` (e.g. `2026-07-10-1500-codex.md`). Append an entry when a provider stops (task done, or usage limit hit). Never overwrite past entries.

## Why the "tried and rejected" field matters most
When you switch providers because of a usage limit, the next provider starts fresh. If it re-explores a dead end the previous provider already ruled out, it burns *your next provider's* limited quota on wasted work. Recording dead ends is the single highest-leverage habit in this workflow.

## Entry template (copy this)

```markdown
## <YYYY-MM-DD HH:MM> — <tool> (<model>) — <STOPPING (reason) | TASK COMPLETE>

**Where I stopped:** <exact point — task N, verified/unverified, committed/uncommitted>
**Why here:** <hit usage limit mid-task | task finished cleanly | blocked on a question>
**What the next tool must do first:** <points to CURRENT.md "Next action">
**Tried and rejected this session:** <approach + why it failed — so nobody redoes it>
**Do NOT redo:** <the specific dead end(s), with rough time cost>
**Uncommitted:** <files unstaged, or "none — clean at commit <sha>">
**Notes:** <anything the next provider would waste time rediscovering>
```

## Example entry

```markdown
## 2026-07-10 14:32 — claude-code (Claude Opus) — STOPPING (usage limit)

**Where I stopped:** Task 7 code written, verification not yet run.
**Why here:** Hit Claude usage limit mid-verification.
**What the next tool must do first:** Run the Task 7 gate (see CURRENT.md "Next action").
**Tried and rejected this session:** computing the field lazily — reverted, it broke the
  concurrency checker. Used an explicit stored field instead.
**Do NOT redo:** the lazy-computed approach (dead end, ~20 min lost).
**Uncommitted:** 2 files unstaged (listed in CURRENT.md).
**Notes:** the targeted UI test needs a fresh build first or it runs against a stale artifact.
```
