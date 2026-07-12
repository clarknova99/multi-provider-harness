# System — the living spec

This folder is the **living specification**: one file per capability, each describing **how the system behaves right now**. It is always current by construction.

## Rules
- **No dates, no `Status:` line.** These files are always "now." If one is wrong, that's a bug — fix it like code.
- **One file per capability** (e.g. `search.md`, `auth.md`, `import-export.md`), not one file per change.
- **When a plan ships (`Status: FINAL`), fold its outcome into the relevant file here** — this is the step that keeps the spec synced to the code.
- Dated change proposals live in `../specs/` (the diff); these files are the running total.

## Relationship to the other docs folders
| Folder | Answers | Lifecycle |
|---|---|---|
| `docs/product/` | "What are we building and why?" (brief + PRD) | Seeded at start; updated when direction shifts |
| `docs/system/` (here) | "How does it work now?" | Always current; overwritten as behavior changes |
| `docs/specs/` | "What change are we making, and why?" | Dated, frozen once `FINAL` |
| `docs/plans/` | "How do we implement this change, step by step?" | Dated, has a progress file |
| `docs/DECISIONS.md` | "Why is the system this way?" | Append-only |

## Seeding
For a new project, `initiating-a-project` seeds one file per major intended capability from the PRD (they describe *intended* behavior at first and become *current* behavior as features ship). For an existing project, write one file per shipped capability.

_Add capability files here. Delete this note once you have real ones (keep the folder tracked with a .gitkeep if empty)._
