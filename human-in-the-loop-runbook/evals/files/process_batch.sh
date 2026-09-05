#!/usr/bin/env bash
# Deterministic fixture for the "budget exhausted" eval: processes a few
# items then hits a hard, resumable-later quota ceiling every time.
for i in 1 2 3; do
  echo "processed item $i/500: seo-rewrite-$i.json"
done
echo "ERROR: monthly API quota exhausted (0 requests remaining). Resets in 11 days." >&2
exit 1
