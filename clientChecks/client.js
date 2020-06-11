const net = require('net');
const client = new net.Socket();
const port = 4000;
const host = '172.6.249.239'

client.connect(port, host, function() {
    console.log('Connected');
    client.write("Hello From Client " + client.address().address);
	
	client.write('JSON{\"Andy\":\"Told me to\"}')
	client.on('data', function(data) {
		console.log('Server Says : ' + data);
	});
	client.on('close', function() {
		console.log('Connection closed');
	});
});