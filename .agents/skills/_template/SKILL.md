---
name: <kebab-case-folder-name>
description: <What this skill covers AND when to consult it. This is the only part the
  model sees when deciding whether to use the skill, so be specific and a little pushy
  about the trigger — e.g. "Use whenever you touch X, change Y, or debug Z." Name real
  subsystems/symbols so it matches relevant tasks.>
---
# Skill: <Imperative title — e.g. "Add a thumbnail generator">

<One or two sentences: what this task is and the single most important rule to respect while doing it.>

## Where things are
<The exact files/types/symbols an agent will touch — link or path them. e.g. `src/foo/Bar.ext` defines `Bar`.>

## Steps
1. <Concrete, ordered steps. Name the interface/function to implement or edit.>
2. <Where to register/wire it so it's actually reachable.>
3. <Any UI or config wiring needed.>

## Conventions to keep
- <Project rules this task must honor. Link the relevant invariant in ../../../AGENTS.md.>

## Gotchas
- <Non-obvious traps you'd want to have known up front. Encode the lesson, not just the symptom.>

## Verify
<How to prove it works: which test to add, and the project's verify gate (see ../verify/SKILL.md).>

## Reference
<Point at the closest existing implementation to copy the shape from.>

<!--
Authoring notes (delete in the real skill):
- The `---` frontmatter MUST be the very first thing in the file (line 1), no blank
  line above it. `name` = the folder name; `description` is what gets matched when
  deciding to use the skill, so make it specific and a little pushy.
- Keep it skimmable: an agent should act after one read. Aim for <60 lines.
- Reference REAL files/symbols, not aspirations. Verify they exist first.
- After creating a skill folder, add a row to the routing table in ../../../AGENTS.md.
- Folder name = kebab-case verb-phrase (e.g. add-provider, generate-thumbnails).
- Markdown style: no maximum line width. Never hard-wrap a paragraph in the middle to
  satisfy a column limit — one paragraph is one continuous line (the editor soft-wraps).
  See ../../../AGENTS.md "Documentation conventions".
-->
