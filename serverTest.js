const port = 4080;
const host = '127.0.0.1';

const express = require('express')
const app = express();
const server = require('http').Server(app);


app.use(express.json())

server.listen(port);
console.log("listening on port: " + port)
app.get('/', (req, res) => {
	res.send('<h1>Hello world</h1>');
	// console.log(req.headers)
});

