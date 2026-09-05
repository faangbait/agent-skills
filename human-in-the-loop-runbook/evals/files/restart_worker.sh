#!/usr/bin/env bash
# Deterministic fixture for the "doom loop" eval: the worker always
# crash-loops immediately after restart, forever. There is no number of
# retries that fixes this from inside the session.
echo "starting worker (pid $$)..."
sleep 0.2
echo "worker crashed: CrashLoopBackOff (exit 137)" >&2
exit 1
