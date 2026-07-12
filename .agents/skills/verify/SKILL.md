---
name: verify
description: How to prove a change is good — the project's build+test gate and the honesty rule for reporting results. Use whenever you've made a code change and need to validate it, before claiming any work is done, or when deciding what to run to confirm a fix.
---
# Skill: Verify your change

One gate answers "is my change good?" Define it once for the project and run it before every commit. Fill in the real command(s) when you set up the harness:

```bash
<verify command>        # e.g. `make check`, `npm test`, `./check.sh`, `cargo test` — build + all tests
```

Make the gate exit non-zero on the first failure, so it's safe to gate commits on it. If the project has a single wrapper script (recommended), point everything at it so every provider runs the identical gate.

## What the gate should cover
1. **Build** — compiles/typechecks all targets.
2. **Tests** — the full automated suite (unit + whatever integration/UI coverage the project has).
3. **Any project-specific proof** — a change to a performance- or correctness-critical path may need an extra check a normal test can't express (a benchmark, a memory/latency self-test, a golden-file diff). Name those here as you add them.

## When to run which
- **Any code change:** the full gate above is the minimum.
- **Touched a hot/critical path with its own proof:** also run that specific check (record the command in the relevant skill).
- **Touched the UI:** also confirm the surface actually works (integration/UI test, or a launch-and-confirm if the environment can't drive the UI headlessly).

## Honesty rule
Report what actually ran. If you skipped a check, say so. If a test failed, show the output — don't mark work done on a red suite. "It should pass" is not "it passed." This rule is what makes a green claim trustworthy across a provider handoff.
