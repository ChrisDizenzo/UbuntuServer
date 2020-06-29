const WebSocket = require('ws')
var webSocketFactory = {
    connectionTries: 3,
    connect: function(url) {
      var ws = new WebSocket(url);
      ws.addEventListener("message", (m)=>{
          console.log(m.data)
      })
      ws.onopen = (event) => {
        //   console.log(event)
        //   var temp = {
        //       creebo: "Thats me",
        //       dipdoozy: "Thats brother",
        //       tanjie: "Thats a pizza pie VR guy"
        //   }
        var temp = {
            user_id: "Thats me",
            username: "Thats brother",
            password: "Thats a pizza pie VR guy",
            color: "blue"
        }

          ws.send(JSON.stringify(temp))
          console.log("sent")
      }
      ws.addEventListener("error", e => {
        // readyState === 3 is CLOSED
        if (e.target.readyState === 3) {
          this.connectionTries--;
  
          if (this.connectionTries > 0) {
            setTimeout(() => this.connect(url), 5000);
          } else {
            throw new Error("Maximum number of connection trials has been reached");
          }
  
        }
      });
    }
  };
  
//   var webSocket = webSocketFactory.connect("ws://localhost:8025/myContextRoot");

var webSocket = webSocketFactory.connect("ws://localhost:4567/user/room4?user=5");
// var wbs = new WebSocket("ws://localhost:4567/echo")