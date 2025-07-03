const express = require("express");
const RecurringExpensesRouter = express.Router();
const { recurringExpensesValidators } = require("./validators");
const { RecurringExpensesController } = require("./controller");

const recurringExpensesController = new RecurringExpensesController();

// Create
RecurringExpensesRouter.post(
	"/",
	recurringExpensesValidators.createRecurringExpenses,
	recurringExpensesController.createRecurringExpenses
);

// Read
RecurringExpensesRouter.get(
	"/:id",
	recurringExpensesValidators.recurringExpensesId,
	recurringExpensesController.getRecurringExpenses
);

// Read
RecurringExpensesRouter.get(
	"/",
	recurringExpensesValidators.recurringExpensesQuery,
	recurringExpensesController.findRecurringExpensess
);

// Update
RecurringExpensesRouter.patch(
	"/:id",
	recurringExpensesValidators.recurringExpensesId,
	recurringExpensesValidators.updateRecurringExpenses,
	recurringExpensesController.updateRecurringExpenses
);

// Delete
RecurringExpensesRouter.delete(
	"/:id",
	recurringExpensesValidators.recurringExpensesId,
	recurringExpensesController.deleteRecurringExpenses
);

module.exports = { RecurringExpensesRouter };
