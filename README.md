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
I recommend using the `Releases` section in the sidebar to download the specific
skill(s) you want as a zip file. Then, simply unzip it to user or repository scope.

See the official [Codex skills documentation](https://developers.openai.com/codex/skills/#where-to-save-skills)
for supported locations, symlinks, and skill discovery behavior.

Note that individual skill releases are not independently versioned. A version bump on
any skill bumps every skill. Just because a skill has a new version number, that doesn't
mean it's been changed.

## Available Skills

### `human-in-the-loop-runbook`

An escalation policy, not general HITL philosophy — it answers one narrow
question: when an agent hits a wall, what does it actually do next. Covers
five halt conditions (unrecoverable error, blocked on ambiguous judgment,
a destructive/irreversible action pending sign-off, resource/budget
exhausted, and a run-until-green goal stuck in a doom loop), and for each
one picks between two channels: pausing in-session to ask, or sending a
durable page via a bundled `scripts/send_escalation.sh` so a human finds out
even if nobody is watching the session.

Requires `curl` and network egress to a paging webhook
(`ESCALATION_WEBHOOK_URL`); if neither is available, the skill's async
channel doesn't apply and it falls back to asking in-session only. The exact
payload contract is defined by [`references/receiver.py`](human-in-the-loop-runbook/references/receiver.py)
rather than restated in prose, so it can't go stale.

See [`human-in-the-loop-runbook/SKILL.md`](human-in-the-loop-runbook/SKILL.md)
for the full decision tree.

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

### `oci-env`

Explains the constraints and escape hatches of the ephemeral `oci-env` rootless
RHEL container. Use it when `printenv oci-env` succeeds, browser automation or
`PATH` behaves unexpectedly, a URI must open outside the container, or a
missing utility needs a disposable installation.

See [`oci-env/SKILL.md`](oci-env/SKILL.md) for the environment details and
alternatives.

### `ssml`

Prepares text for natural-sounding text-to-speech output using Speech Synthesis
Markup Language (SSML). It covers XML escaping, pronunciation aliases, pauses,
emphasis, prosody, and Speechify emotion controls, with practical examples and
recommended text-to-alias mappings.

See [`ssml/SKILL.md`](ssml/SKILL.md) for the complete reference.

### `write-like-sage`

Draft, rewrite, edit, or critique text in Sage's established voice. 

Agents using this skill:

1. Review the conclusions of a corpus analysis report.
2. Integrate these patterns into their output.

> ## **Psst... want to know how I generated a `write-like-me` skill?** I prompted GPT-5.6-Sol on High effort with the following: 
> - **Learn my writing style from a corpus of documents I provide.**
> - **Write a Skill that teaches another agent how to write in my style.**
>
> ### Then I provided the following anthology:
>
> 1. **(1) Manifesto** - why I do, what I do, the way I do it.
> 2. **(1) Research-Adjacent Article** - where I took a common belief and proved it wrong, showing how I attack weak ideas.
> 3. **(1) The first chapter of my Academic Thesis** - showing how I defend strong ideas.
> 4. **(5) Pieces of short-form sales copy** - things I had laying around; some print ads; some emails.
>
> Here, I paused and asked the agent to write a short email selling a "site reliability" service. 
>
> 5. **(1) Wy response to the same prompt** - answered in parallel, generating a side-by-side comparison of "their output" and "my output."
> 6. **(2) GitHub Links:** - showing my technical writing in pull requests and commits.
>
>    - https://github.com/issues/created?q=is%3Aissue%20author%3A%40me%20sort%3Aupdated-desc%20created%3A%3C%40today-90d
>    - https://github.com/issues/created?q=is%3Apr%20author%3A%40me%20sort%3Aupdated-desc%20created%3A%3C%40today-90d
> 7. **(100k words) of DMs from Slack** - engineering topics, but not exclusively (a few sidebars about life or kids)
>
> ### I requested a bundle including:
>
> - **writing corpus:** losslessly cleaned source material. verbatim text, as I wrote it, but without markup/artifacts
> - **lexicon:** a lexicographical sort. what's the most common word I start a sentence with? rank the most common two-word and three-word combos. etc.
> - **style reference:** the bulk of the reference to be provided with the Skill. this should serve as technical documentation for future agents.
> - **corpus manifest:** the description / summary of the three files mentioned above
