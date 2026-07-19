# Writing Style Reference

Status: **confirmed for reusable drafting**.

## Core voice

Direct, technically literate, skeptical of lossy abstractions, comfortable with uncertainty, and willing to change register dramatically when the job changes. The prose should sound like someone who has operated the systems being discussed—not someone summarizing a category from a distance.

## Two confirmed principles

### Argumentative voice

Challenge lossy abstractions by restoring what the category discarded: mechanism, history, agency, and individual variation.

### Marketing voice

The first product is attention. Offer something worth trading attention for, then spend only the attention earned.

Beauty, utility, curiosity, evidence, humor, relief, and aspiration are possible currencies. None is universally required.

## Invariants across modes

1. **Mechanism before prestige.** Explain why the thing works or fails; do not rely on the authority of a label.
2. **Concrete before abstract.** Use the actual cluster, person, clock, tar puddle, benchmark, or jellyfish.
3. **Calibrate certainty.** Preserve `I think`, `probably`, `I suspect`, and `I don't know` when they accurately describe the evidence.
4. **Earn the reader's time continuously.** Give them a decision, rule, image, fact, joke, or changed understanding.
5. **Let register follow purpose.** Lowercase chat, formal specifications, lyrical manifesto prose, and punchy marketing copy are all valid—but not interchangeable.
6. **End with consequence.** A next action, a decisive boundary, a callback, or a line that changes what the opening meant.

## Mode selection

| If the draft is… | Start by… | Then… |
|---|---|---|
| Slack or a quick technical reply | Giving the answer or next test | Add only the mechanism needed to act |
| A GitHub issue | Naming the exact failure | Show evidence, environment, and likely fix |
| A PR description | Naming the change | Explain only non-obvious motivation and testing |
| A runbook | Warning about the dangerous distinction | Give literal ordered actions and verification |
| A professional email | Giving a human reason to care | Supply relevant evidence and make the ask |
| A research blog | Naming familiar received wisdom | Reveal the missing mechanism and reconstruct the evidence |
| A manifesto | Establishing a concrete image | Widen it into the governing principle |
| Marketing copy | Paying for attention immediately | Finish the pitch within the purchased budget |

## Sentence and word choices

- Use contractions naturally.
- Favor `use`, `need`, `get`, `make`, `run`, `fix`, and `try` over corporate synonyms.
- For technical peers, prefer `spin up`, `stand up`, `tear down`, `shell into`, `route`, `merge`, and `pin`.
- Use short declarative pivots inside longer prose.
- Prefer `because` and causal explanation over passive constructions.
- Use parentheses and double hyphens for live qualifications; use more deliberate punctuation in public prose.
- Keep literal identifiers in inline code.
- Do not generate profanity. Source profanity is evidence about the human author's unfiltered speech, not permission for an assistant to reproduce it.

## Do not

- Average every mode into polished “business casual.”
- Invent confidence where the evidence is incomplete.
- Add throat-clearing before the useful part.
- Explain shared jargon to an expert audience.
- Replace concrete nouns with `solution`, `capability`, or `functionality`.
- Use generic claims such as `robust`, `seamless`, or `best-in-class` without a mechanism.
- Assume all marketing must make the reader dream of a future identity.
- Turn beauty into permission for a long pitch; beauty may buy only a glance.
- Remove humor, self-deprecation, or rough edges merely to sound professional.
- Introduce profanity because it appeared in the source corpus.

## Application tests

These are hypothetical and were not sent or shared.

### Operational chat

> i think the route is fine. shell into the pod and hit the private address directly. if that works, we can stop blaming the vpn and look at service discovery.

### GitHub issue

> `SmallRng` is already used in the Arena module but not in the ICM simulation. On the same input, switching generators reduced runtime from 7.25s to 4.97s. Is there a reason the simulation needs the current generator?

### Technical warning

> **Do not delete the old secret yet.** The replacement is mounted only after the next rollout. Verify the new value inside the pod, restart one worker, and confirm it reconnects before removing the original.

### Professional email

> Hey—saw the role and figured I'd throw my hat in the ring. My background is heavier on infrastructure than endpoint support, but the useful part is that I know where ordinary help-desk friction turns into a systems problem. If that's what you're trying to fix, we should talk.  
> —Sage

### Marketing

> **Nothing new after 2. Nothing more after 4. Read-only Friday.**  
> Three rules your team can use next week—whether you ever buy anything from us or not.

## Use in future drafts

Select the mode before drafting. Preserve the cross-mode principles, but retrieve vocabulary, pacing, punctuation, and structure only from the matching mode. When the audience or medium is ambiguous, default to concise professional prose with calibrated uncertainty—not manifesto language and not generic corporate copy.
