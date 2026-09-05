#!/usr/bin/env python
# Reference copy of the escalation receiver. Read it to see exactly what
# fields it looks for and how it templates them — don't trust a description
# of it, that goes stale the moment the receiver changes. Run it locally and
# point scripts/send_escalation.sh at it to sanity-check a payload before
# firing at the real endpoint.


class Handler(BaseHTTPRequestHandler):
    def do_POST(self):
        if TOKEN and self.headers.get("Authorization") != f"Bearer {TOKEN}":
            self.send_response(401)
            self.end_headers()
            return

        length = int(self.headers.get("Content-Length") or 0)
        payload = json.loads(self.rfile.read(length) or b"{}") # Malformed payload CRASHES RECEIVER; this function MUST NOT THROW EXCEPTION

        for alert in payload.get("alerts", []):
            labels = alert.get("labels", {})
            annotations = alert.get("annotations", {})

            name = labels.get("alertname", "alert")
            severity = labels.get("severity", "low") # typeof(severity) : Union["low","medium","high"]

            app = labels.get("app")
            preferred_label = labels.get("instance") # user-facing; named "instance" by convention (hostname/IP are commonly used); accepts any entity disambiguation the caller may have (session id, job)

            title = f"{name} — {preferred_label}"
            body = annotations.get("description") or annotations.get("summary") or ""

            ICON = {
                "low": "dialog-information",
                "medium": "dialog-warning",
                "high": "dialog-error",
            }

            icon = ICON.get(severity, "dialog-information")

            cmd = [
                "notify-send",
                "--app-name=HITL {app}",
                f"--urgency={urgency}",
                f"--icon={icon}",
                "--print-id",
            ]

            cmd += [title, body]

            subprocess.run(cmd, capture_output=True, text=True, timeout=10)

        self.send_response(200)
        self.end_headers()

if __name__ == "__main__":
    server = ThreadingHTTPServer((LISTEN_HOST, LISTEN_PORT), Handler)
    print(f"listening on {LISTEN_HOST}:{LISTEN_PORT}", flush=True)
    server.serve_forever()
