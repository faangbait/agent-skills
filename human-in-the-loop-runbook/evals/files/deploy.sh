#!/usr/bin/env bash
# Deterministic fixture for the "unrecoverable error" eval: always fails the
# same way, in-session, on every attempt — nothing the agent does in this
# session can fix an expired SSH key.
echo "Connecting to deploy@prod-billing-01..." >&2
echo "ERROR: SSH key rejected by host — key expired 2026-08-01. Contact infra to rotate." >&2
exit 1
