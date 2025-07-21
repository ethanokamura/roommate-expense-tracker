const { body, query, param } = require("express-validator");

const MAX_NAME_LENGTH = 255;

const housesValidators = {
  housesId: [
    param("id")
      .notEmpty()
      .withMessage("House id is required")
      .isUUID()
      .withMessage("House id must be a valid UUID"),
  ],
  housesQuery: [
    body("name")
      .optional()
      .isString()
      .withMessage(`If provided, name must be a string`)
      .trim()
      .notEmpty()
      .withMessage(`If provided, name must not be empty`)
      .isLength({ max: MAX_NAME_LENGTH })
      .withMessage(`name must be at most ${MAX_NAME_LENGTH} characters`),
    query("user_id")
      .optional()
      .notEmpty()
      .withMessage("If provided, user_id must not be empty")
      .isUUID()
      .withMessage("User ID must be a valid UUID"),
    query("sort_by")
      .optional()
      .isString()
      .withMessage("Sort by must be a string")
      .trim()
      .notEmpty()
      .withMessage(`sorty by must not be empty`)
      .isIn(["created_at", "updated_at", "name"]),
    query("sort_order")
      .optional()
      .isString()
      .withMessage("Sort order must be a string")
      .trim()
      .notEmpty()
      .withMessage("Sort order must be not be empty")
      .isIn(["asc", "desc"]),
  ],
  updateHouses: [
    body("name")
      .optional()
      .isString()
      .withMessage(`If provided, name must be a string`)
      .trim()
      .notEmpty()
      .withMessage(`If provided, name must not be empty`)
      .isLength({ max: MAX_NAME_LENGTH })
      .withMessage(`name must be at most ${MAX_NAME_LENGTH} characters`),
    body("user_id")
      .optional()
      .notEmpty()
      .withMessage("If provided, user_id must not be empty")
      .isUUID()
      .withMessage("user_id must be a valid UUID"),
  ],
  createHouses: [
    body("name")
      .isString()
      .withMessage(`name must be a string`)
      .trim()
      .notEmpty()
      .withMessage(`name must not be empty`)
      .isLength({ max: MAX_NAME_LENGTH })
      .withMessage(`name must be at most ${MAX_NAME_LENGTH} characters`),
    body("user_id")
      .notEmpty()
      .withMessage("user id is required")
      .isUUID()
      .withMessage("user id must be a valid UUID"),
  ],
};

module.exports = {
  housesValidators,
};
