# multi-provider-harness

I switch between AI models a lot, usually because I ran out of usage on provider and have to move to another to keep going. The frustrating part is what happens when a model stops in the middle of a task. Everything it was working on is still there. The plan, the half-done change, the approaches it already tried and threw out. But it's all stuck in that provider's chat history or hidden away somewhere in its app folder. So you start over with a fresh model somewhere else, explain what you were doing all over again, and then watch it slowly rediscover things the last one already knew.

I put this template together to fix that. Instead of each tool storing its state in chat history or its own private folders, a small harness tells **Claude Code, ChatGPT Codex, Cursor, and Gemini CLI** to write the important stuff down as plain files in the project folder. The current task, the decisions, the memory, what's in progress, what's already been tried, all of it lives in the repo. That folder becomes the one place every tool checks first. On bigger tasks the model drops checkpoints as it works and leaves a clear note that says "look here first", so when one model taps out, a model on a different provider can open the same repo and keep going from where the last one stopped.


## What's here

```
AGENTS.md                    THE instruction file — the source of truth all four tools read.
CLAUDE.md                 →  symlink to AGENTS.md (Claude Code entry point)
.claude/
  skills   →  ../.agents/skills     (symlink)
  agents   →  ../.agents/agents     (symlink)
  settings.json                     (REAL, Claude-specific)
.codex/
  config.toml                       (Codex shell/env config)
  agents/*.toml                     (Codex persona adapters — mirror of .agents/agents/*.md)
.gemini/settings.json        points Gemini at AGENTS.md ({ "contextFileName": "AGENTS.md" })
.cursor/rules/00-harness.mdc pointer telling Cursor to read AGENTS.md + CURRENT.md
.github/copilot-instructions.md   pointer for Copilot surfaces
                             (Codex also reads AGENTS.md natively)

.agents/                     canonical harness content (the only real copy)
  agents/                    role personas: product-manager, principal-engineer, ux-design-reviewer, qa-analyst, code-reviewer
  skills/                    SKILL.md workflows (cross-tool standard)
  memory/                    MEMORY.md index + one-fact-per-file notes

docs/
  product/                   product brief + PRD (the "what & why") + templates
  system/                    LIVING SPEC — current behavior, no dates, always true
  specs/                     dated change proposals (DRAFT/IN_PROGRESS/FINAL) + _TEMPLATE
  plans/                     implementation plans + progress files + _TEMPLATEs
  DECISIONS.md               append-only ADR log
  state/
    CURRENT.md               ← the single "start here" file every tool reads first
    sessions/                ← append-only per-session handoff logs

scripts/
  verify-harness.sh          fails if a pointer broke or AGENTS.md exceeds Codex's 32 KiB cap
  setup-harness.sh           (re)creates the symlinks after a fresh clone / on repair
```

## Two ways to start

### A) A brand-new project (from a product brief)
1. **Write a product brief.** Copy `docs/product/_TEMPLATE-product-brief.md` to `docs/product/product-brief.md` and fill in what you know.
2. **Turn it into a PRD.** Ask your AI tool to run the `initiating-a-project` skill. It reads the brief, **asks you about anything critical that's missing** (target users, the one differentiator, success metrics, scope, constraints), and writes a complete `docs/product/PRD.md`.
3. **Populate the harness.** The same skill helps you fill `AGENTS.md` and seed `docs/system/` from the PRD.
4. **Build.** Pick the first feature, write its spec + plan, and execute — the harness owns everything from "spec" onward. See the workflow in `AGENTS.md`.

### B) An existing codebase
1. **Fill in the placeholders.** Search for `<PROJECT_NAME>` and `<...>` across `AGENTS.md`, the personas, and the skills, and replace with your project's specifics. Delete the example memory and the `_TEMPLATE` docs once you have real ones.
2. **Verify the wiring:** `bash scripts/verify-harness.sh`
3. **Commit everything**, including the symlinks. Anyone who clones gets the identical harness.
4. If symlinks don't materialize (e.g. a repaired checkout), run `bash scripts/setup-harness.sh`.

## The core idea: continuity lives in the project repo, not in chat

No provider's chat history — and no single tool's native `/resume` — transfers to another provider. The only thing that survives a Claude → Codex → Cursor → Gemini switch is **files in the repo**. So:

- **`docs/state/CURRENT.md`** always holds the active task, what's done, the *exact next action*, and the dead ends already tried. Every tool reads it first. Keep it short. It's a snapshot, not a log.
- The active task's **"do not retry" list lives right in `CURRENT.md`**, so the next provider skips known dead ends without reading anything else. `docs/state/sessions/` keeps the longer history as an optional archive for when the snapshot isn't enough.
- **Git commits** are the safe handoff points. The git history is the one piece of state all four providers share perfectly, so commit after every task. When a limit cuts a model off mid-task, the next one reads the diff of the uncommitted work and carries on.

## Multi-provider daily loop

1. Open the repo in whichever provider still has quota.
2. It reads `AGENTS.md`, gets pointed at `CURRENT.md`, and knows the next action with zero chat context.
3. Work task by task. Each task ends the same way. Run the tests, update `CURRENT.md`, commit. A separate progress ledger is optional and only pays off on big multi-session features.
4. Hit a limit and the model just stops, often mid-sentence. That's expected. If you were committing per task, the next provider picks up from the last commit. If it stopped mid-task, the dirty tree plus `CURRENT.md` is enough to reconstruct where it was.
5. Switch providers. The new one reads `CURRENT.md`, runs `git status` to see any half-finished work, and keeps going. It reads the "do not retry" list and skips the dead ends.
6. Repeat as limits reset.

## The development workflow

The required spine is **spec → plan → execute (test-first) → verify → checkpoint**, and each phase has a first-class skill in `.agents/skills/` — no plugin required:

| Phase | Skill | Required? |
|---|---|---|
| Start a new project from a brief | `initiating-a-project` | new projects only |
| Expand a rough idea into a design | `brainstorming` | optional |
| Adversarially pressure-test the idea | `idea-review` | optional |
| Write the spec | `docs/specs/_TEMPLATE-spec.md` (+ `product-manager` persona) | required |
| Write the plan | `docs/plans/_TEMPLATE-*.md` (+ `checkpointing-progress`) | required |
| Execute test-first, one commit per task | `executing-plans` + `test-driven-development` | required |
| Prove it's good | `verify` (+ `code-reviewer` persona) | required |
| Hand off cleanly | `checkpointing-progress` | required |

`brainstorming` and `idea-review` are **optional** — reach for them when a design choice is genuinely open or an idea is risky, not as mandatory gates. Everything else is the always-on spine.

## A few caveats

**Symlinks, ZIP downloads, and Windows.** A couple of environments quietly turn the symlinks into plain text files, which makes the tools stop finding their skills and agents. Downloading the repo as a ZIP from GitHub does it, and so does a Windows checkout without symlink support. Two things help. Clone with git rather than downloading a ZIP, and if a checkout still comes out flat, run `bash scripts/setup-harness.sh` to rebuild the links (`bash scripts/verify-harness.sh` will tell you if they're broken and point you at the fix). On a Windows or mixed team, make `CLAUDE.md` a one-line `@AGENTS.md` import instead of a symlink with `CLAUDE_IMPORT=1 bash scripts/setup-harness.sh`.

**GUI tools.** The command-line tools read `AGENTS.md` and `CURRENT.md` on their own at the start of a session. GUI tools like Cursor and Copilot load `AGENTS.md` through their pointer files (`.cursor/rules/00-harness.mdc` and `.github/copilot-instructions.md`), and in practice they follow `CURRENT.md` fine once it's loaded. Early in a session it's worth a quick check that the tool actually picked it up, and if it seems to be skipping it, nudge it with something like "read CURRENT.md and resume."

## Why standalone (no bundled framework)
This template deliberately does **not** install a framework that ships its own parallel `AGENTS.md`/config, because a second config competes with this file for authority ("whichever the tool reads last" ambiguity) and breaks the single-source-of-truth guarantee that makes mid-task provider switching safe. The project-initiation flow (brief → PRD → spec) is inspired by that style of method but is implemented **natively** here — as plain skills and templates that obey `AGENTS.md` rather than replacing it. If you later adopt a workflow plugin, point it at these same `docs/` folders so no separate tool-branded folder appears.

## Contributing
Contributions are welcome — see [CONTRIBUTING.md](CONTRIBUTING.md) for the setup steps, the spec → plan → execute → verify → checkpoint workflow, and the repo conventions. All participation is governed by the [Code of Conduct](CODE_OF_CONDUCT.md).

## Security
Please don't file public issues for vulnerabilities. See [SECURITY.md](SECURITY.md) for how to report privately.

## License
Released under the [MIT License](LICENSE). © 2026 Michael Feldblyum.
