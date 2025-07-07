const { body, query, param } = require("express-validator");

const housesValidators = {
  housesId: [],
  housesQuery: [],
  updateHouses: [],
  createHouses: [
    body("name")
      .notEmpty()
      .withMessage("Name is required")
      .isLength({ max: 255 })
      .withMessage("Name must be at most 255 characters"),

    body("invite_code")
      .notEmpty()
      .withMessage("Invite code is required")
      .isLength({ max: 50 })
      .withMessage("Invite code must be at most 50 characters"),
  ],
};

module.exports = {
  housesValidators,
};
