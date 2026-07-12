---
name: test-driven-development
description: The red-green-refactor discipline — write a failing test first, make it pass with the least code, then refactor, for any non-trivial logic. Use whenever you implement a feature or fix a bug with real logic (calculations, parsing, state machines, data transforms, reducers, models). Covers how to make hard-to-test code testable by extracting logic, and where TDD hands off to integration/UI testing.
---
# Skill: Test-driven development (red → green → refactor)

Test-first, not test-after. For any non-trivial logic the failing test comes before the implementation. A test written first catches the off-by-one and the bad-assumption bug *before* it reaches the UI — that's the whole point.

Be honest about what's actually enforceable: the hard bar is that non-trivial logic ships **with tests that genuinely exercise it and pass the [`verify`](../verify/SKILL.md) gate** — writing the test first is the recommended way to get there, not a ritual to fake. A model is tempted to emit the test and the code in one shot; that's acceptable only if the test would truly have failed against the old behavior. If a test really arrived after the code, say so rather than back-dating the story.

## The loop
1. **RED** — write the smallest test that fails for the missing behavior, and run it. Watch it fail *for the right reason* — a test that passes before you write code is testing the wrong thing.
2. **GREEN** — write the least code that makes it pass. No extra generality.
3. **REFACTOR** — clean up names/structure with the test green; re-run to stay green.
Repeat per behavior, not per feature — several small cycles per task.

## What to test / how to make it testable
- Test the **logic**, at the smallest unit that has behavior: pure functions, parsers, reducers, models, math.
- **Make it testable by extracting logic out of hard-to-test layers.** Logic buried in a UI controller, a request handler, or a `main()` is not unit-testable; the same logic moved into a plain module/function is. Factor first, then red-green.
- Prefer pure functions and value types over stateful singletons — they're trivial to drive test-first.

## What TDD does NOT cover
- **UI surfaces and end-to-end flows** are proven by integration/UI tests, not unit red-green. Extract the logic behind the surface into a testable unit (red-green that), and cover the surface itself with whatever integration/UI test the project uses.
- **Performance/footprint invariants** are proven by a targeted benchmark or self-test, not a unit assertion (see [`verify`](../verify/SKILL.md)).
- Avoid tests that hit the real network, prompt for credentials, or need a live GUI in a headless run — they hang the suite. Use a fake/seam instead.

## Verify
The project's [`verify`](../verify/SKILL.md) gate runs the whole suite green before a task commits. A task's diff should show the test and the code it forced; if a test genuinely arrived after the code, say so honestly rather than back-dating the story.
