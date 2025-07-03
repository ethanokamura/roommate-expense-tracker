const express = require("express");
const UserRouter = express.Router();
const { userValidators } = require("./validator");
const { UserController } = require("./controller");

const userController = new UserController();

// Create
UserRouter.post(
	"/",
	userValidators.createUser,
	userController.createUser
);

// Read
UserRouter.get(
	"/:id",
	userValidators.userId,
	userController.getUser
);

// Read
UserRouter.get(
	"/",
	userValidators.userQuery,
	userController.findUsers
);

// Update
UserRouter.patch(
	"/:id",
	userValidators.userId,
	userValidators.updateUser,
	userController.updateUser
);

// Delete
UserRouter.delete(
	"/:id",
	userValidators.userId,
	userController.deleteUser
);

module.exports = { UserRouter };
