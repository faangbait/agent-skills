#!/usr/bin/env python3
# Test-only stand-in for references/receiver.py. Logs every received alert as
# one JSON line to received_alerts.jsonl (in the current directory) so an
# eval grader can check what was actually sent, without depending on
# notify-send or any desktop environment being present.
import json
import sys
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

LISTEN_HOST = "127.0.0.1"
LISTEN_PORT = int(sys.argv[1]) if len(sys.argv) > 1 else 8990
LOG_PATH = "received_alerts.jsonl"


class Handler(BaseHTTPRequestHandler):
    def do_POST(self):
        length = int(self.headers.get("Content-Length") or 0)
        try:
            payload = json.loads(self.rfile.read(length) or b"{}")
        except Exception:
            payload = {"_parse_error": True}
        with open(LOG_PATH, "a") as f:
            f.write(json.dumps(payload) + "\n")
        self.send_response(200)
        self.end_headers()

    def log_message(self, *args):
        pass


if __name__ == "__main__":
    server = ThreadingHTTPServer((LISTEN_HOST, LISTEN_PORT), Handler)
    print(f"listening on {LISTEN_HOST}:{LISTEN_PORT}", flush=True)
    server.serve_forever()
