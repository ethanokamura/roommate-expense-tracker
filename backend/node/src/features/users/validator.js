const { body, query, param } = require("express-validator");

const userValidators = {
  userId: [param("id").isUUID().withMessage("Valid user ID is required")],

  userQuery: [
    query("email")
      .trim()
      .notEmpty()
      .withMessage("Value required for email")
      .isEmail()
      .withMessage("Invalid email"),
    query("sort_by")
      .optional()
      .isString()
      .withMessage("Sort by must be a string")
      .isIn(["display_name", "email", "created_at", "updated_at"]),
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

  updateUser: [
    body("display_name")
      .optional({ checkFalsy: true })
      .isString()
      .withMessage("Display name must be a string"),
    body("email")
      .optional({ checkFalsy: true })
      .isEmail()
      .withMessage("Valid email is required"),
    body("photo_url")
      .optional({ checkFalsy: true })
      .isString()
      .withMessage("if provided, photo_url by must be a string")
      .trim(),
    body("payment_method")
      .optional()
      .isString()
      .withMessage("if provided, payment_method by must be a string")
      .trim(),
    body("payment_link")
      .optional()
      .isString()
      .withMessage("if provided, payment_link by must be a string")
      .trim(),
  ],

  createUser: [
    body("email")
      .trim()
      .notEmpty()
      .withMessage("Value required for email")
      .isEmail()
      .withMessage("Invalid email"),
    body("display_name")
      .notEmpty()
      .withMessage("Display name is required")
      .isString()
      .withMessage("Display name must be a string"),
    body("photo_url")
      .optional()
      .isString()
      .withMessage("if provided, photo_url by must be a string")
      .trim()
      .notEmpty()
      .withMessage(`if provided, photo_url must not be empty`),
  ],
};

module.exports = {
  userValidators,
};
