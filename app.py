from http.server import BaseHTTPRequestHandler, HTTPServer
import requests
import json

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/" or self.path == "/index.html":
            self.send_response(200)
            self.send_header("Content-Type", "text/html")
            self.end_headers()
            with open("index.html", "rb") as f:
                self.wfile.write(f.read())
        else:
            self.send_error(404)

    def do_POST(self):
        if self.path == "/api/chat":
            length = int(self.headers["Content-Length"])
            body = self.rfile.read(length)

            r = requests.post(
                "http://localhost:11434/api/chat",
                headers={"Content-Type": "application/json"},
                data=body
            )

            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.end_headers()
            self.wfile.write(r.content)
        else:
            self.send_error(404)

HTTPServer(("", 8000), Handler).serve_forever()
