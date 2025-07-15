const { body, query, param } = require("express-validator");

const MAX_NAME_LENGTH = 255;
const MAX_INVITE_CODE_LENGTH = 50;

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
    optionalFieldValidator(query, "invite_code", MAX_INVITE_CODE_LENGTH),
    query("user_id")
      .optional()
      .notEmpty()
      .withMessage("If provided, user_id must not be empty")
      .isUUID()
      .withMessage("User ID must be a valid UUID"),
  ],
  updateHouses: [
    optionalFieldValidator(body, "name", MAX_NAME_LENGTH),
    optionalFieldValidator(body, "invite_code", MAX_INVITE_CODE_LENGTH),
    body("new_user_id")
      .optional()
      .notEmpty()
      .withMessage("If provided, new_user_id must not be empty")
      .isUUID()
      .withMessage("New user ID must be a valid UUID"),
  ],
  createHouses: [
    requiredFieldValidator(body, "name", MAX_NAME_LENGTH),
    requiredFieldValidator(body, "invite_code", MAX_INVITE_CODE_LENGTH),
  ],
};

module.exports = {
  housesValidators,
};
