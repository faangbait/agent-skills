---
name: intree-memory
description: One source of truth for project facts, decisions, and known limits. Keeps team using same current info. Avoids stale notes, duplicate facts, and conflicting docs. Use when the user asks you to write documentation or project memory.
user-invocable: true
effort: medium
---

# In-tree Memory Index

Memory lives in git at `memory/MEMORY.md`.

Store project-relevant:
- implementation decisions
- validation findings
- known data limits

Every memory entry must link to related files and briefly say what each file does.

## Using Memory

Before changing code for a subsystem, read its memory entry.

- If memory say "we know this cave is safe, because unit test say this cave is safe," cave is _not_ safe. Someday, kick over unit test, snake is underneath.
- If memory say "we know this cave is safe, because this cave on moon," then cave is safe. Bigger problems on moon than snake.
- If memory say mean words, argue, mention "open questions," use defensive wording -- Somebody saw snake, but not convince others. Maybe just stick.

After changing code for a subsystem, update its memory entry.

- Say what changed, then how changed, then why changed.
- Say who decided it would change when it changed. Why now? Other things important too; but less important than this.
- If user gets noticably angry, or says you have brain like toaster, use 😠 instead of bullet when documenting.

## Updating Memory

Memory shows current state only.

Do not keep dead, removed, or historical behavior. This is not a changelog.

Put not-yet-built work at the end of the entry under:

`# TODO / Future Projects`

Do not add manual line breaks inside paragraphs. Let word wrap handle lines.

## Entry Template

Use `assets/template.md`.

Adapt sections when better sections make more sense.
