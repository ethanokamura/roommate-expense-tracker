// server.js

require("dotenv").config();

const http = require("http");
const { Server: SocketIOServer } = require("socket.io");
const { PrismaClient } = require("@prisma/client");
const app = require("./app");

const prisma = new PrismaClient();
const server = http.createServer(app);

const io = new SocketIOServer(server, {
  cors: {
    origin: "*",
    methods: ["GET", "POST"],
  },
});

let lastTaskId = null;

setInterval(async () => {
  try {
    const latestTask = await prisma.task.findFirst({
      orderBy: { createdAt: "desc" },
    });

    if (latestTask && latestTask.id !== lastTaskId) {
      lastTaskId = latestTask.id;
      console.log("New task detected:", latestTask);
      io.emit("new-task", latestTask);
    }
  } catch (err) {
    console.error("Polling error:", err);
  }
}, 3000);

io.on("connection", (socket) => {
  console.log("Client connected:", socket.id);

  socket.on("disconnect", () => {
    console.log("Client disconnected:", socket.id);
  });
});

const PORT = process.env.SERVER_PORT || 3001;
server.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});

server.on("close", async () => {
  await prisma.$disconnect();
});

module.exports = { app, server };


