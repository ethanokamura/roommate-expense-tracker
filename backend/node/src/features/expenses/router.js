const express = require("express");
const ExpensesRouter = express.Router();
const { expensesValidators } = require("./validator");
const { validateRequest } = require("../../utils/validator");
const { ExpensesController } = require("./controller");

const expensesController = new ExpensesController();

// Create
ExpensesRouter.post(
  "/",
  expensesValidators.createExpenses,
  validateRequest,
  expensesController.createExpenses
);

// Read
ExpensesRouter.get(
  "/:id",
  expensesValidators.expensesId,
  validateRequest,
  expensesController.getExpenses
);

// Read
ExpensesRouter.get(
  "/",
  expensesValidators.expensesQuery,
  validateRequest,
  expensesController.findExpenses
);

// Update
ExpensesRouter.patch(
  "/:id",
  expensesValidators.expensesId,
  expensesValidators.updateExpenses,
  validateRequest,
  expensesController.updateExpenses
);

// Delete
ExpensesRouter.delete(
  "/:id",
  expensesValidators.expensesId,
  validateRequest,
  expensesController.deleteExpenses
);

module.exports = { ExpensesRouter };
