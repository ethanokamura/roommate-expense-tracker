// server.js
require("dotenv").config();
const app = require("./app");

const PORT = process.env.SERVER_PORT || 3001;
const server = app.listen(PORT, () => {
	console.log(`Server running on port ${PORT}`);
});

server.on("close", async () => {});

module.exports = { app, server };
