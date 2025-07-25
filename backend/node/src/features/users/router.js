const express = require("express");
const UserRouter = express.Router();
const { userValidators } = require("./validator");
const { UserController } = require("./controller");
const { validateRequest } = require("../../utils/validator");

const userController = new UserController();

// Create
UserRouter.post(
  "/",
  userValidators.createUser,
  validateRequest,
  userController.createUser
);

// Read
UserRouter.get(
  "/:id",
  userValidators.userId,
  validateRequest,
  userController.getUser
);

// Read
UserRouter.get(
  "/",
  userValidators.userQuery,
  validateRequest,
  userController.findUsers
);

// Update
UserRouter.patch(
  "/:id",
  userValidators.userId,
  userValidators.updateUser,
  validateRequest,
  userController.updateUser
);

// Delete
UserRouter.delete(
  "/:id",
  userValidators.userId,
  validateRequest,
  userController.deleteUser
);

module.exports = { UserRouter };
