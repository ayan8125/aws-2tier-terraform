#!/bin/bash
apt update -y
apt install -y python3

cat << 'EOF' > /home/ubuntu/server.py
from http.server import HTTPServer, BaseHTTPRequestHandler

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        html = """
        <html>
        <head>
            <title>My Python Server</title>
        </head>
        <body>
            <h1>Hello from EC2!</h1>
            <p>This is a simple HTML page served on port 5000.</p>
        </body>
        </html>
        """
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()
        self.wfile.write(html.encode("utf-8"))

server = HTTPServer(("0.0.0.0", 5000), Handler)
server.serve_forever()
EOF

nohup python3 /home/ubuntu/server.py &
