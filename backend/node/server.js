// server.js

require("dotenv").config();

// create a new http server
const http = require("http");
const { Server: SocketIOServer } = require("socket.io");
const { PrismaClient } = require("@prisma/client");
const app = require("./app");

const prisma = new PrismaClient();
const server = http.createServer(app);

//supports both GET and POST requests
const io = new SocketIOServer(server, {
  cors: {origin: "*", methods: ["GET", "POST"],
  },
});

let lastTaskId = null;

// uses polling
// sorts task in descending order

setInterval(async () => {
  try {
    const latestTask = await prisma.task.findFirst({
      orderBy: { createdAt: "desc" },
    });

    if (latestTask && latestTask.id !== lastTaskId) {
      lastTaskId = latestTask.id;
      io.emit("new-task", latestTask);
    }
  } catch (err) {
    console.error("error is there:", err);
  }
}, 3000);

io.on("connection", (socket) => {
  socket.on("disconnect", () => {
  });
});

const PORT = process.env.SERVER_PORT || 3001;
server.listen(PORT);

server.on("close", async () => {
  await prisma.$disconnect();
});

module.exports = { app, server };


