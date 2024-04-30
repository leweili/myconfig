import http.server
import random
import string

class RandomStringHandler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()
        random_string = ''.join(random.choices(string.ascii_letters + string.digits, k=10))
        self.wfile.write(random_string.encode())

if __name__ == '__main__':
    server_address = ('', 10003)
    httpd = http.server.HTTPServer(server_address, RandomStringHandler)
    print('Server running at http://localhost:10003/')
    httpd.serve_forever()