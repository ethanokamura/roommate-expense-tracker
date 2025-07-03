const express = require("express");
const ExpenseSplitsRouter = express.Router();
const { expenseSplitsValidators } = require("./validator");
const { ExpenseSplitsController } = require("./controller");

const expenseSplitsController = new ExpenseSplitsController();

// Create
ExpenseSplitsRouter.post(
	"/",
	expenseSplitsValidators.createExpenseSplits,
	expenseSplitsController.createExpenseSplits
);

// Read
ExpenseSplitsRouter.get(
	"/:id",
	expenseSplitsValidators.expenseSplitsId,
	expenseSplitsController.getExpenseSplits
);

// Read
ExpenseSplitsRouter.get(
	"/",
	expenseSplitsValidators.expenseSplitsQuery,
	expenseSplitsController.findExpenseSplitss
);

// Update
ExpenseSplitsRouter.patch(
	"/:id",
	expenseSplitsValidators.expenseSplitsId,
	expenseSplitsValidators.updateExpenseSplits,
	expenseSplitsController.updateExpenseSplits
);

// Delete
ExpenseSplitsRouter.delete(
	"/:id",
	expenseSplitsValidators.expenseSplitsId,
	expenseSplitsController.deleteExpenseSplits
);

module.exports = { ExpenseSplitsRouter };
