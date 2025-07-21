const { body, query, param } = require("express-validator");

const houseMembersValidators = {
  houseMembersId: [
    param("id")
      .notEmpty()
      .withMessage("House member id is required")
      .isUUID()
      .withMessage("House member id must be a valid UUID"),
  ],

  houseMembersQuery: [
    query("house_id")
      .optional()
      .notEmpty()
      .withMessage("If provided, house_id must not be empty")
      .isUUID()
      .withMessage("House ID must be a valid UUID"),

    query("user_id")
      .optional()
      .notEmpty()
      .withMessage("If provided, user_id must not be empty")
      .isUUID()
      .withMessage("User ID must be a valid UUID"),

    query("is_admin")
      .optional()
      .notEmpty()
      .withMessage("If provided, is_admin must not be empty")
      .isBoolean()
      .withMessage("must be a boolean"),

    query("sort_by")
      .optional()
      .isString()
      .withMessage("Sort by must be a string")
      .trim()
      .notEmpty()
      .withMessage(`sorty by must not be empty`)
      .isIn(["created_at", "updated_at", "nickname"]),

    query("sort_order")
      .optional()
      .isString()
      .withMessage("Sort order must be a string")
      .trim()
      .notEmpty()
      .withMessage("Sort order must be not be empty")
      .isIn(["asc", "desc"]),
  ],

  createHouseMembers: [
    body("house_id")
      .notEmpty()
      .withMessage("House ID is required")
      .isUUID()
      .withMessage("House ID must be a valid UUID"),

    body("user_id")
      .notEmpty()
      .withMessage("User ID is required")
      .isUUID()
      .withMessage("User ID must be a valid UUID"),

    body("is_admin")
      .notEmpty()
      .withMessage("is_admin is required")
      .isBoolean()
      .withMessage("must be a boolean"),
  ],

  updateHouseMembers: [
    body("is_admin")
      .optional()
      .notEmpty()
      .withMessage("If provided, is_admin must not be empty")
      .isBoolean()
      .withMessage("If provided, is_admin must be a bool"),

    body("is_active")
      .optional()
      .notEmpty()
      .withMessage("If provided, is_active must not be empty")
      .isBoolean()
      .withMessage("If provided, is_active must be a bool"),

    body("nickname")
      .optional()
      .isString()
      .withMessage("If provided, nickname must be a string")
      .trim()
      .notEmpty()
      .withMessage(`nickname must not be empty`)
      .isLength({ max: 100 })
      .withMessage(`must be at most 100 characters`),
  ],

  houseMembersUserInfo: [
    param("house_id")
      .notEmpty()
      .withMessage("House ID is required")
      .isUUID()
      .withMessage("House ID must be a valid UUID"),
    query("sort_by")
      .optional()
      .isString()
      .withMessage("Sort by must be a string")
      .trim()
      .notEmpty()
      .withMessage(`sorty by must not be empty`)
      .isIn(["created_at", "updated_at", "nickname"]),
    query("sort_order")
      .optional()
      .isString()
      .withMessage("Sort order must be a string")
      .trim()
      .notEmpty()
      .withMessage("Sort order must be not be empty")
      .isIn(["asc", "desc"]),
  ],
};

module.exports = {
  houseMembersValidators,
};
