const { body, query, param } = require('express-validator');

const userHousesValidator = {
  userHousesQuery: [
    param("id").isUUID().withMessage("Valid ID is required"),
    query("sort_by")
      .optional()
      .isString()
      .withMessage("Sort by must be a string")
      .isIn(["created_at", "updated_at", "name"]),
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
}

module.exports = {
    userHousesValidator
}