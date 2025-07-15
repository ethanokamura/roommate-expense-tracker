const express = require("express");
const UserRouter = express.Router();
const { userValidators } = require("./validator");
const { UserController } = require("./controller");
const { validateRequest } = require("../../utils/validator");
const { validateUser } = require("../auth/middleware");

const userController = new UserController();

// Create
UserRouter.post(
	"/",
	userValidators.createUser,
  validateRequest,
  validateUser,
	userController.createUser
);

// Read
UserRouter.get(
	"/:id",
	userValidators.userId,
  validateRequest,
  validateUser,
	userController.getUser
);

// Read
UserRouter.get(
	"/",
	userValidators.userQuery,
  validateRequest,
  validateUser,
	userController.findUsers
);

// Update
UserRouter.patch(
	"/:id",
	userValidators.userId,
	userValidators.updateUser,
  validateRequest,
  validateUser,
	userController.updateUser
);

// Delete
UserRouter.delete(
	"/:id",
	userValidators.userId,
  validateRequest,
  validateUser,
	userController.deleteUser
);

module.exports = { UserRouter };
