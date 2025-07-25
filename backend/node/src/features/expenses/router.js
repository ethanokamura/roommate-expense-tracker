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
  "/my-expenses",
  expensesValidators.myExpensesQuery,
  validateRequest,
  expensesController.findMyExpenses
);

// Read
ExpensesRouter.get(
  "/my-total-expenses",
  expensesValidators.myExpensesQuery,
  validateRequest,
  expensesController.findMyTotalExpenses
);

// Read
ExpensesRouter.get(
  "/this-week",
  expensesValidators.myExpensesQuery,
  validateRequest,
  expensesController.getWeeklyExpenses
);

// Read
ExpensesRouter.get(
  "/categories",
  expensesValidators.myExpensesQuery,
  validateRequest,
  expensesController.getExpenseCategories
);

// Read
ExpensesRouter.get(
  "/",
  expensesValidators.expensesQuery,
  validateRequest,
  expensesController.findExpenses
);

// Read
ExpensesRouter.get(
  "/:id",
  expensesValidators.expensesId,
  validateRequest,
  expensesController.getExpenses
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
