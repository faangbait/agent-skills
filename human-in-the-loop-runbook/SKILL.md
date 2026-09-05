---
name: human-in-the-loop-runbook
description: "Defines what an agent must do the moment it cannot safely continue on its own: an unrecoverable error, a decision that needs human judgment, a destructive/irreversible action awaiting sign-off, or an exhausted budget/quota. Use this skill whenever execution is about to halt or block, before giving up silently, before proceeding on a guess, or before running a destructive command without approval. Requires curl and network egress to an escalation webhook (ESCALATION_WEBHOOK_URL) — if neither is available, this skill does not apply."
---

# Human-in-the-loop runbook

This is an escalation policy, not general HITL philosophy. It answers one narrow
question: **when an agent hits a wall, what does it actually do next?** Treat each
halt condition below like a route in a paging system — a condition maps to a
channel, not a shrug.

## Preconditions

This skill assumes a paging webhook is reachable: `curl` is on `PATH` and
`ESCALATION_WEBHOOK_URL` is set to an endpoint that turns a POST into a desktop
notification (see [references/receiver.py](references/receiver.py) for the
exact contract). If the receiver requires auth, set
`ESCALATION_WEBHOOK_TOKEN` and it's sent as `Authorization: Bearer <token>`.

If `curl` or the endpoint isn't available, this skill's async channel doesn't
exist here — don't fake it, don't invent a URL, and don't retry. Fall back to
whatever in-session interaction the environment already gives you (e.g. asking
the user directly) and skip the rest of this document.

## Two channels, not one

- **In-session pause** — stop and ask, right now, in the current conversation.
  Assumes a human is actually watching this turn.
- **Durable page** — POST an alert to `ESCALATION_WEBHOOK_URL` via
  `scripts/send_escalation.sh`, which pops a desktop notification so a human
  finds out even if nobody is watching this session, or if the session ends
  before anyone answers.

Don't default to always doing both or always doing one — the right choice
depends on whether the session is likely attended and whether the agent will
still be around to hear the answer. That judgment is made per condition below.

## Halt conditions

### 1. Unrecoverable error
Retries are exhausted, or the failure isn't the kind retrying fixes (broken
auth, corrupted state, a missing dependency nothing in this session can
install). The agent is stuck regardless of whether anyone is watching, and an
unattended session will otherwise stall silently with no record of why.
**Page, and also say so in-session** if the session is interactive. Severity
`high` unless the error is cosmetic to the task's actual goal, then `medium`.

### 2. Blocked on ambiguous judgment
The agent has multiple valid paths and no basis — from the task, the code, or
prior instructions — to pick one. This is the common case and it almost always
has a human right there in the conversation, so default to **asking in-session
only**. Only add a page if there's a concrete reason to think no one is
attending live (a scheduled/background invocation, an unattended long-running
job) — otherwise a page here is just noise on top of a question nobody needed
paged to answer. If it does get paged, severity `low`.

### 3. Destructive/irreversible action pending
The next step is hard to undo: deletion, a force-push, a production deploy, a
financial transaction, anything on that spectrum. Never take the action
without explicit sign-off, full stop. **Pause in-session to ask.** Add a page
alongside it when the action is time-sensitive enough that leaving it blocked
on an unanswered chat message has its own cost — otherwise the in-session ask
is enough, because the whole point is that nothing happens until a human
answers. Severity `high`.

### 4. Resource/budget exhausted
Tokens, cost cap, rate limit, or time budget hit zero mid-task. The mechanism
that caused this may also be the one that ends the agent's turn, so an
in-session ask can't be relied on to actually reach anyone — attempt it if
possible, but treat **the page as the channel that matters** here. Severity
`medium` if the task can safely resume later, `high` if partial work is in a
state that degrades or expires while waiting.

### 5. An infinite-loop (/goal or retry=always) hits a doom loop
The user expectation for tools that promise "run until green" service, for
instance, an agent with a defined /goal or a set of declaratively-provisioned
resources, is that they are always either green or running. If this is violated
(e.g. the agent is blocked and aborts the goal, or a crash-loop back off triggers),
**Page, and also say so in-session**. Severity `high` unless the error is
cosmetic to the task's actual goal, then `medium`.


## Sending a page

Use `scripts/send_escalation.sh` — it builds the payload and POSTs it, so no
invocation should hand-roll `curl` for this. Example:

```bash
scripts/send_escalation.sh \
  --status firing \
  --label alertname=destructive_action_pending \
  --label severity=high \
  --label instance=agent-skills-session-4821 \
  --annotation description="rm -rf on prod bucket needs sign-off — see workspace /workspaces/agent-skills"
```

The exact field contract is defined by the receiver, not by us — read
[references/receiver.py](references/receiver.py) rather than trust a
description of it here, which would just go stale the moment the receiver
changes. If you're unsure a payload is shaped right, run that file locally
and point `scripts/send_escalation.sh` at it before firing at the real
endpoint.

Do not smoke-test the real endpoint with a throwaway alert to check it's
reachable — every invocation is a real page, and a placeholder one still
pops a notification on the other end. The invocation you actually need to
send already tells you whether it worked: `scripts/send_escalation.sh`
exits 0 only when the receiver returns HTTP 200, and prints the status code
it got otherwise (auth rejection, unreachable host, receiver error, etc. all
surface this way). Read that exit status instead of firing a second request
to find out.

Following up with `--status resolved` and the same `alertname`/labels
will immediately clear the notification, but it is not required, as
a separate utiltiy is responsible for providing graceful management of
stale user-facing information.
