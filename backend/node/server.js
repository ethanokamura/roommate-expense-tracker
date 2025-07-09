// server.js using socket.io in JavaScript

require("dotenv").config();

const http = require("http");
const { Server: SocketIOServer } = require("socket.io");
const { PrismaClient } = require("@prisma/client");
const { pulse } = require("@prisma/pulse");
const app = require("./app");

const prisma = new PrismaClient();
const server = http.createServer(app);

const socketOptions = {
  cors: {
    origin: "*",
    methods: ["GET", "POST"],
  }
};

const io = new SocketIOServer(server, socketOptions);


io.on("connection", (socket) => {
  console.log("Client connected:", socket.id);
  socket.on("disconnect", () => {
    console.log("Client disconnected:", socket.id);
  });
});

const PORT = process.env.SERVER_PORT || 3001;
const server = app.listen(PORT, () => {
	console.log(`Server running on port ${PORT}`);
server.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});

server.on("close", async () => {});
