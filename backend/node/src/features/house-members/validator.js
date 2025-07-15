const { body, query, param } = require("express-validator");

const VALID_ROLES = ['member', 'head_of_house'];

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
    
    query("role")
      .optional()
      .isString()
      .withMessage("If provided, role must be a string")
      .isIn(VALID_ROLES)
      .withMessage(`Role must be one of: ${VALID_ROLES.join(', ')}`),
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
    
    body("role")
      .optional()
      .isString()
      .withMessage("If provided, role must be a string")
      .isIn(VALID_ROLES)
      .withMessage(`Role must be one of: ${VALID_ROLES.join(', ')}`),
  ],

  updateHouseMembers: [
    body("role")
      .optional()
      .isString()
      .withMessage("If provided, role must be a string")
      .isIn(VALID_ROLES)
      .withMessage(`Role must be one of: ${VALID_ROLES.join(', ')}`),
  ],
};

module.exports = {
  houseMembersValidators,
};