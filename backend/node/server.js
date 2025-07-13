require("dotenv").config();

const http = require("http");
const express = require("express");
const { Server: SocketIOServer } = require("socket.io");
const { PrismaClient } = require("@prisma/client");

const app = express();
const prisma = new PrismaClient();
const server = http.createServer(app);

const io = new SocketIOServer(server, {
  cors: {
    origin: "*",
    methods: ["GET", "POST"],
  }
});

io.on("connection", (socket) => {
  console.log("Client connected:", socket.id);

  socket.on("disconnect", () => {
    console.log("Client disconnected:", socket.id);
  });
});

let lastTaskId = null;

setInterval(async () => {
  try {
    const latestTask = await prisma.task.findFirst({
      orderBy: { createdAt: "desc" },
    });

    if (latestTask && latestTask.id !== lastTaskId) {
      lastTaskId = latestTask.id;
      io.emit("new-task", latestTask);
    }
  } catch (error) {
    console.error("Polling error:", error);
  }
}, 3000);

const PORT = process.env.SERVER_PORT || 3001;
server.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});

server.on("close", async () => {
  await prisma.$disconnect();
});

module.exports = { app, server };


