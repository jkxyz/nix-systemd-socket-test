// https://github.com/herzi/systemd-socket

var firstSystemdFD = 3;
var nextIndex = 0;

function systemdSocketFd (index) {
    if (arguments.length < 1) {
        index = nextIndex++;
    }

    if (!process.env.LISTEN_FDS) {
        return null;
    }

    var listenFDs = parseInt(process.env.LISTEN_FDS, 10);
    if (listenFDs < nextIndex) {
        return null;
    }

    return {
        fd: firstSystemdFD + index
    };
};

module.exports = systemdSocketFd;
