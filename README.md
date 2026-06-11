# Agent Skills

General-purpose skills for AI agents.

This repository collects practical, reusable instructions that help agents give
better responses with fewer tokens. Skills should improve common workflows,
reduce repeated reasoning, and stay useful across projects and domains.

## Principles

- Broadly useful, not niche
- Clear enough to follow consistently
- Compact enough to justify their context cost
- Focused on better outcomes, not longer prompts

Each skill lives in its own directory with a `SKILL.md` file and any supporting
assets it needs.

## Installation

Clone the repository somewhere permanent:

```sh
git clone https://github.com/faangbait/agent-skills.git ~/.local/share/agent-skills
```

Then install the desired skill at user or repository scope. See the official
[Codex skills documentation](https://developers.openai.com/codex/skills/#where-to-save-skills)
for supported locations, symlinks, and skill discovery behavior.

## Available Skills

### `intree-memory`

Keeps project facts, implementation decisions, validation findings, and known
limits in a version-controlled source of truth at `memory/MEMORY.md`.

Agents using this skill:

1. Read the relevant memory entry before changing a subsystem.
2. Update that entry after making the change.
3. Link entries to the related project files and explain what those files do.
4. Remove stale behavior instead of preserving history; memory describes the
   current state and is not a changelog.

Future work belongs under `TODO / Future Projects`. New entries can start from
the included [`assets/template.md`](intree-memory/assets/template.md) and adapt
its sections to the subsystem being documented.

See [`intree-memory/SKILL.md`](intree-memory/SKILL.md) for the complete rules.
