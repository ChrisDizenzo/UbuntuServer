const port = 7070;
const host = '127.0.0.1';

const express = require('express')
const app = express();
const server = require('http').Server(app);
const io = require("socket.io")(server);
const moment = require('moment');
const sqlRoutes = require('./database')
const axios = require('axios')


app.use(express.json())
app.use('/sql', sqlRoutes)

server.listen(port);
console.log("listening on port: " + port)


app.get('/', (req, res) => {
	res.send('<h1>Hello world</h1>');
	// console.log(req.headers)
});





// usernames which are currently connected to the chat
var display_names = {};

// rooms which are currently available in chat
var rooms = ['Home'];
// chats = {'Chat1':[]}

io.on('connection', (socket) => {

	socket.on('USERINFO', (data) =>{
		console.log("Name change to: " + JSON.stringify(data))
		if (data.consumer_id){
			axios.post(`http://tcp.chrisdizenzo.com:4000/sql/update/consumer`,{ 
				set: { 
					display_name: data.display_name,
					color: data.color
				},
				where: {
					consumer_id: data.consumer_id
				}
			})
			.then(response => {
				axios.get(`http://tcp.chrisdizenzo.com:4000/sql/consumer`,{ 
					params: {
						where: {
							display_name: data.display_name,
							color: data.color
						},
						limit: 1
					}
				})
				.then(response2 => {
					socket.consumer_id = response2.data.consumer_id
					socket.emit('USERINFO', response2.data)
					console.log('emit userinfo: ' + JSON.stringify(response2.data))
				})
				.catch(err => console.warn(err));
			})
			.catch(err => console.warn(err));
		}else{
			axios.post(`http://tcp.chrisdizenzo.com:4000/sql/consumer`,{ 
				display_name: data.display_name,
				color: data.color
			})
			.then(response => {
				console.log("getting")
				axios.get(`http://tcp.chrisdizenzo.com:4000/sql/consumer`,{ 
					params: {
						where: {
							display_name: data.display_name,
							color: data.color
						},
						limit: 1
					}
				})
				.then(response2 => {
					socket.consumer_id = response2.data.consumer_id
					socket.emit('USERINFO', response2.data)
					console.log('emit userinfo: ' + response2.data)
				})
				.catch(err => console.warn(err));
			})
			.catch(err => console.warn(err));
		}
		socket.display_name = data.display_name
		// socket.join('Home');
		// // socket.emit('updatechat', 'SERVER', 'you have connected to Home');
		// socket.emit('updaterooms', rooms, 'Home');
	})

	socket.on('sendChat', function (data) {
		console.log(socket.display_name + " said to room " + socket.room + ": " + data)
		// we tell the client to execute 'updatechat' with 2 parameters
		io.sockets.in(socket.room).emit('updatechat', data);
		// chats[socket.room].push(data)
		axios.post(`http://tcp.chrisdizenzo.com:4000/sql/comment`,{ 
			message: data.text,
			consumer_id: data.consumer_id,
			chat_id: socket.room.slice(-1)
		 })
		  .then(response => response.status)
		  .catch(err => console.warn(err));
	});
	
	socket.on('switchRoom', (newroom) => {
		if (rooms.indexOf(newroom) == -1){
			console.log("Rooms is: " + rooms)
			console.log("Adding room: " + newroom)
			rooms.push(newroom)
			// chats[newroom] = []
			console.log("Rooms is now: " + rooms)
			axios.post(`http://tcp.chrisdizenzo.com:4000/sql/chat`,{ 
			name: newroom,
		 })
		}
		console.log(socket.display_name + " joined room: " + newroom + " and left room " + socket.room)
		socket.leave(socket.room);
		socket.join(newroom);
		// socket.emit('updatechat' , 'Server' , 'you connected to ' + newroom)
		socket.room = newroom;
		socket.broadcast.to(newroom).emit('updatechat', {text: String(socket.display_name + " has just Joined!"), color: 'bg-blue-500', time: moment()});
		socket.emit('updaterooms', rooms);
	})

	socket.on('disconnect', function(){
		delete display_names[socket.display_name];
		// update list of users in chat, client-side
		// io.sockets.emit('updateusers', display_name);
		// echo globally that this client has left
		socket.leave(socket.room);
	});
});

