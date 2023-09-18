const http = require('http');
const systemdSocketFd = require('./systemd');

const startedAt = new Date();

const server = http.createServer(
  { keepAlive: true },
  (req, res) => {
    res.writeHead(200, {
      'Content-Type': 'text/plain',
      'Connection': 'keep-alive'
    });
    setInterval(() => { res.write(startedAt.toString() + '\n'); }, 1000);
  }
);

process.on('SIGTERM', () => {
  console.log('SIGTERM signal received');

  server.close(() => {
    console.log('Server closed');
    process.exit(0);
  });
});

server.listen(systemdSocketFd(), () => {
  console.log('Listening on socket');
});
