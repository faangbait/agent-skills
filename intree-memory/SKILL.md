---
name: intree-memory
description: One source of truth for project facts, decisions, and known limits. Keeps team using same current info. Avoids stale notes, duplicate facts, and conflicting docs.
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

After changing code for a subsystem, update its memory entry.

## Updating Memory

Memory shows current state only.

Do not keep dead, removed, or historical behavior. This is not a changelog.

Put not-yet-built work at the end of the entry under:

`# TODO / Future Projects`

Do not add manual line breaks inside paragraphs. Let word wrap handle lines.

## Entry Template

Use `assets/template.md`.

Adapt sections when better sections make more sense.