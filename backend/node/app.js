// app.js
const express = require("express");
const cors = require("cors");

const { ExpenseSplitsRouter } = require("./src/features/expense-splits/router");
const { ExpensesRouter } = require("./src/features/expenses/router");
const { HouseMembersRouter } = require("./src/features/house-members/router");
const { HousesRouter } = require("./src/features/houses/router");
const { ReceiptsRouter } = require("./src/features/receipts/router");
const { RecurringExpensesRouter } = require("./src/features/recurring-expenses/router");
const { UserRouter } = require("./src/features/users/router");
const { UserHousesRouter } = require("./src/features/user-houses/router");


const app = express();

function isOriginAllowed(origin) {
	return origin && /^https?:\/\/localhost(:\d+)?$/.test(origin);
}

const corsOpts = {
	origin: function (org, cb) {
		if (!org || isOriginAllowed(org)) {
			cb(null, true);
		} else {
			cb(new Error("Cors not allowed"));
		}
	},
	credentials: true,
};

app.use(cors(corsOpts));

app.use("/expense-splits", ExpenseSplitsRouter);
app.use("/expenses", ExpensesRouter);
app.use("/house-members", HouseMembersRouter);
app.use("/houses", HousesRouter);
app.use("/receipts", ReceiptsRouter);
app.use("/recurring-expenses", RecurringExpensesRouter);
app.use("/users", UserRouter);
app.use("/user-houses", UserHousesRouter);

app.use((err, req, res, next) => {
	const info_string = `Error on path: ${req.path} using ${req.method}`;
	console.log(info_string);
	writeLog(info_string, { name: "server-log", dir: "./logs/" });
	console.error(err.code, "\n", err.e);
	res.status(err.code || 500).send({});
});

module.exports = app;
