const { body, query, param } = require('express-validator');

const userValidators = {
    userId: [
        param("id").isUUID().withMessage("Valid user ID is required")
    ],

    userQuery: [
        param("id").isUUID().withMessage("Valid user ID is required"),
        query("sort_by").optional().isString().withMessage("Sort by must be a string").isIn(["display_name", "created_at", "updated_at"]),
        query("sort_order").optional().isString().withMessage("Sort order must be a string").isIn(["asc", "desc"]),
        query("limit").optional().isInt({ min: 1, max: 25 }).withMessage("Limit must be an integer between 1 and 100")
    ],

    updateUser: [
        body("display_name").optional().isString().withMessage("Display name must be a string"),
        body("email").optional().isEmail().withMessage("Valid email is required")
    ],

    createUser: [
        body("email")
          .trim()
          .notEmpty().withMessage("Value required for email")
          .isEmail().withMessage("Invalid email"),

        body("display_name")
          .notEmpty().withMessage("Display name is required")
          .isString().withMessage("Display name must be a string"),
    ]
}

module.exports = {
    userValidators
}