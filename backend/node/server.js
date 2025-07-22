//server.js

require("dotenv").config();

const app = require("./app");
const http = require("http");
const { Server: SocketIOServer } = require("socket.io");

const PORT = process.env.SERVER_PORT || 3001;

const server = http.createServer(app);

const io = new SocketIOServer(server, {
  cors: {
    origin: "*",
  },
});

io.on("connection", (socket) => {
  socket.emit("connected", {message: "Connection is successful" });

});

server.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});

server.on("close", async () => {});


module.exports = {app, server};
