const net = require('net');
const client = new net.Socket();
const port = 4000;
const host = '172.6.249.239'


const io = require('socket.io-client')
console.log(io)
const socket = io.connect('http://' +  host+ ':' + port);

socket.on('news', (data) => {
    console.log(data);
    socket.emit('my other event', { Hi: 'Creebo' });
});