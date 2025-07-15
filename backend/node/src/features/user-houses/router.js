const express = require("express");
const UserRouter = express.Router();
const { userHousesValidator } = require("./validator");
const { UserHousesController } = require("./controller");

const userHousesController = new UserHousesController();

// Read
UserRouter.get(
	"/:id",
	userHousesValidator.userId,
	userHousesController.getUser
);