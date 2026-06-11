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

