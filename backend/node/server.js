// server.js
require("dotenv").config();


const https = require("http")
const{Server} = require("socket.io")
const {PrismaClient} = require("@prisma/client");
const {pulse} = require("@prisma/pulse");
const app = require("./app");

const newserver = http.createServer(app);


const prisma = new PrismaClient();


server.on("close", async () => {});

module.exports = { app, server };
