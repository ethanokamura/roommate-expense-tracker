const express = require("express");
const UserHousesRouter = express.Router();
const { userHousesValidator } = require("./validator");
const { UserHousesController } = require("./controller");

const userHousesController = new UserHousesController();

// Read
UserHousesRouter.get(
	"/:id",
	userHousesValidator.userHousesQuery,
	userHousesController.getUserHouses
);

module.exports = { UserHousesRouter };
