const http = require('http');
const systemdSocketFd = require('./systemd');

const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
  res.end('Hello, world!');
});

server.listen(systemdSocketFd(), () => {
  console.log('Listening on socket');
});
