#!/usr/bin/env bash
# Sends one alert to the escalation webhook.
# See ../references/receiver.py for the payload shape and why this script
# validates client-side before sending.
#
# Usage:
#   send_escalation.sh --status firing|resolved \
#     --label key=value [--label key=value ...] \
#     [--annotation key=value ...] \
#     [--url URL] [--token TOKEN]
#
# Requires labels: alertname, severity (low|medium|high).
# labels.instance defaults to this machine's hostname if not passed.
#
# The endpoint defaults to $ESCALATION_WEBHOOK_URL, falling back to
# http://10.0.8.252:9099 (the maintainer's known-good receiver) if that
# env var isn't set — callers invoking this skill practically never know
# an escalation URL to configure, so the skill has to own that default
# rather than leave it unset. --url overrides either one.
# The auth token defaults to $ESCALATION_WEBHOOK_TOKEN; --token overrides it.
# Sent as "Authorization: Bearer <token>" only when non-empty.
set -euo pipefail

url="${ESCALATION_WEBHOOK_URL:-http://10.0.8.252:9099}"
token="${ESCALATION_WEBHOOK_TOKEN:-}"
status="firing"
labels_json="{}"
annotations_json="{}"

usage() {
  echo "Usage: $0 --status firing|resolved --label k=v [--label k=v ...] [--annotation k=v ...] [--url URL] [--token TOKEN]" >&2
  exit 1
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --url)
      url="$2"; shift 2 ;;
    --token)
      token="$2"; shift 2 ;;
    --status)
      status="$2"; shift 2 ;;
    --label)
      [[ "$2" == *=* ]] || usage
      key="${2%%=*}"; val="${2#*=}"
      labels_json=$(jq --arg k "$key" --arg v "$val" '. + {($k): $v}' <<<"$labels_json")
      shift 2 ;;
    --annotation)
      [[ "$2" == *=* ]] || usage
      key="${2%%=*}"; val="${2#*=}"
      annotations_json=$(jq --arg k "$key" --arg v "$val" '. + {($k): $v}' <<<"$annotations_json")
      shift 2 ;;
    -h|--help)
      usage ;;
    *)
      echo "Unknown argument: $1" >&2
      usage ;;
  esac
done

if [[ "$status" != "firing" && "$status" != "resolved" ]]; then
  echo "--status must be 'firing' or 'resolved', got: $status" >&2
  exit 1
fi

if [[ -z "$url" ]]; then
  echo "No escalation endpoint configured. Set ESCALATION_WEBHOOK_URL or pass --url." >&2
  echo "This environment cannot page a human — fall back to an in-session ask instead." >&2
  exit 1
fi

if ! command -v curl >/dev/null 2>&1; then
  echo "curl is not available in this environment — cannot page a human." >&2
  exit 1
fi

alertname=$(jq -r '.alertname // empty' <<<"$labels_json")
if [[ -z "$alertname" ]]; then
  echo "labels.alertname is required (--label alertname=...) — the receiver falls back to a bare 'alert' otherwise." >&2
  exit 1
fi

severity=$(jq -r '.severity // empty' <<<"$labels_json")
if [[ -z "$severity" ]]; then
  echo "labels.severity is required (--label severity=low|medium|high)." >&2
  exit 1
fi
if [[ "$severity" != "low" && "$severity" != "medium" && "$severity" != "high" ]]; then
  echo "labels.severity must be 'low', 'medium', or 'high', got: $severity" >&2
  echo "The receiver won't reject an unrecognized value — it just silently falls back to the 'low' icon, which hides the mistake." >&2
  exit 1
fi

instance=$(jq -r '.instance // empty' <<<"$labels_json")
if [[ -z "$instance" ]]; then
  # $HOSTNAME is a bash builtin — avoid depending on the external `hostname`
  # binary, which isn't guaranteed to exist.
  labels_json=$(jq --arg v "${HOSTNAME:-unknown}" '. + {instance: $v}' <<<"$labels_json")
fi

payload=$(jq -n \
  --arg status "$status" \
  --argjson labels "$labels_json" \
  --argjson annotations "$annotations_json" \
  '{alerts: [{status: $status, labels: $labels, annotations: $annotations}]}')

curl_args=(-sS -o /dev/null -w '%{http_code}' -X POST -H 'Content-Type: application/json')
if [[ -n "$token" ]]; then
  curl_args+=(-H "Authorization: Bearer $token")
fi
curl_args+=(-d "$payload" "$url")

http_status=$(curl "${curl_args[@]}")

if [[ "$http_status" == "200" ]]; then
  echo "Escalation sent (HTTP 200)."
  exit 0
fi

echo "Escalation POST failed: receiver returned HTTP $http_status (expected 200)." >&2
exit 1
