const { body, query, param } = require("express-validator");

const MAX_NAME_LENGTH = 255;

const optionalFieldValidator = (location, field, max_length) =>
  location(field)
    .optional()
    .isString()
    .withMessage(`If provided, ${field} must be a string`)
    .trim()
    .notEmpty()
    .withMessage(`If provided, ${field} must not be empty`)
    .isLength({ max: max_length })
    .withMessage(`${field} must be at most ${max_length} characters`);

const requiredFieldValidator = (location, field, max_length) =>
  location(field)
    .isString()
    .withMessage(`${field} must be a string`)
    .trim()
    .notEmpty()
    .withMessage(`${field} must not be empty`)
    .isLength({ max: max_length })
    .withMessage(`${field} must be at most ${max_length} characters`);

const housesValidators = {
  housesId: [
    param("id")
      .notEmpty()
      .withMessage("House id is required")
      .isUUID()
      .withMessage("House id must be a valid UUID"),
  ],
  housesQuery: [
    optionalFieldValidator(query, "name", MAX_NAME_LENGTH),
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
    optionalFieldValidator(body, "name", MAX_NAME_LENGTH),
    body("user_id")
      .optional()
      .notEmpty()
      .withMessage("If provided, user_id must not be empty")
      .isUUID()
      .withMessage("user_id must be a valid UUID"),
  ],
  createHouses: [requiredFieldValidator(body, "name", MAX_NAME_LENGTH)],
};

module.exports = {
  housesValidators,
};
