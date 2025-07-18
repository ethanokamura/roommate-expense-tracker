const { body, query, param } = require("express-validator");

const expensesValidators = {
  expensesId: [
    param("expense_id").isUUID().withMessage("Valid expense ID is required"),
  ],
  weeklyExpenseQuery: [
    param("key").isString().withMessage("Valid key is required"),
    param("value").isUUID().withMessage("Valid ID is required"),
  ],
  expensesQuery: [
    query("house_id")
      .optional()
      .isUUID()
      .notEmpty()
      .withMessage("Valid House ID is required"),
    query("house_member_id")
      .optional()
      .isUUID()
      .notEmpty()
      .withMessage("Valid House Member ID is required"),
    query("sort_by")
      .optional()
      .isString()
      .withMessage("Sort by must be a string")
      .isIn([
        "total_amount",
        "created_at",
        "updated_at",
        "settled_date",
        "expense_date",
      ]),
    query("sort_order")
      .optional()
      .isString()
      .withMessage("Sort order must be a string")
      .isIn(["asc", "desc"]),
    query("limit")
      .optional()
      .isInt({ min: 1, max: 25 })
      .withMessage("Limit must be an integer between 1 and 100"),
  ],
  updateExpenses: [
    body("description")
      .optional()
      .isString()
      .withMessage("Description must be a string"),
    body("total_amount")
      .optional()
      .isDecimal()
      .withMessage("Total amount must be a decimal"),
    body("category")
      .optional()
      .isString()
      .withMessage("Category must be a string"),
    body("is_settled")
      .optional()
      .isBoolean()
      .withMessage("Is settled must be a bool"),
    body("settled_at")
      .optional()
      .isDate()
      .withMessage("Settled at must be a timestamp"),
  ],
  createExpenses: [
    param("house_id")
      .isUUID()
      .notEmpty()
      .withMessage("Value required for houseId")
      .withMessage("Valid houseId is required"),
    param("house_member_id")
      .isUUID()
      .notEmpty()
      .withMessage("Value required for houseMemberId")
      .withMessage("Valid houseMemberId is required"),
    body("total_amount")
      .isDecimal()
      .withMessage("Total amount must be a decimal"),
    body("expense_date")
      .isDate()
      .withMessage("Expense date at must be a timestamp"),
    body("description")
      .notEmpty()
      .withMessage("Value required for description")
      .isString()
      .withMessage("Description must be a string"),
    body("category")
      .notEmpty()
      .withMessage("Value required for category")
      .isString()
      .withMessage("Category must be a string"),
  ],
};

module.exports = {
  expensesValidators,
};
