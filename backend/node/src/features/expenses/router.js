const express = require("express");
const ExpensesRouter = express.Router();
const { expensesValidators } = require("./validator");
const { ExpensesController } = require("./controller");

const expensesController = new ExpensesController();

// Create
ExpensesRouter.post(
	"/",
	expensesValidators.createExpenses,
	expensesController.createExpenses
);

// Read
ExpensesRouter.get(
	"/:id",
	expensesValidators.expensesId,
	expensesController.getExpenses
);

// Read
ExpensesRouter.get(
	"/",
	expensesValidators.expensesQuery,
	expensesController.findExpensess
);

// Update
ExpensesRouter.patch(
	"/:id",
	expensesValidators.expensesId,
	expensesValidators.updateExpenses,
	expensesController.updateExpenses
);

// Delete
ExpensesRouter.delete(
	"/:id",
	expensesValidators.expensesId,
	expensesController.deleteExpenses
);

module.exports = { ExpensesRouter };
