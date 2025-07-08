const express = require("express");
const ExpensesRouter = express.Router();
const { expensesValidators } = require("./validator");
const { validateUser } = require("../auth/middleware");
const { validateRequest } = require("../../utils/validator");
const { ExpensesController } = require("./controller");

const expensesController = new ExpensesController();

// Create
ExpensesRouter.post(
	"/",
	expensesValidators.createExpenses,
  validateRequest,
  validateUser,
	expensesController.createExpenses
);

// Read
ExpensesRouter.get(
	"/:id",
	expensesValidators.expensesId,
  validateRequest,
  validateUser,
	expensesController.getExpenses
);

// Read
ExpensesRouter.get(
	"/",
	expensesValidators.expensesQuery,
  validateRequest,
  validateUser,
	expensesController.findExpensess
);

// Update
ExpensesRouter.patch(
	"/:id",
	expensesValidators.expensesId,
	expensesValidators.updateExpenses,
  validateRequest,
  validateUser,
	expensesController.updateExpenses
);

// Delete
ExpensesRouter.delete(
	"/:id",
	expensesValidators.expensesId,
  validateRequest,
  validateUser,
	expensesController.deleteExpenses
);

module.exports = { ExpensesRouter };
