const express = require("express");
const HouseMembersRouter = express.Router();
const { houseMembersValidators } = require("./validators");
const { HouseMembersController } = require("./controller");

const houseMembersController = new HouseMembersController();

// Create
HouseMembersRouter.post(
	"/",
	houseMembersValidators.createHouseMembers,
	houseMembersController.createHouseMembers
);

// Read
HouseMembersRouter.get(
	"/:id",
	houseMembersValidators.houseMembersId,
	houseMembersController.getHouseMembers
);

// Read
HouseMembersRouter.get(
	"/",
	houseMembersValidators.houseMembersQuery,
	houseMembersController.findHouseMemberss
);

// Update
HouseMembersRouter.patch(
	"/:id",
	houseMembersValidators.houseMembersId,
	houseMembersValidators.updateHouseMembers,
	houseMembersController.updateHouseMembers
);

// Delete
HouseMembersRouter.delete(
	"/:id",
	houseMembersValidators.houseMembersId,
	houseMembersController.deleteHouseMembers
);

module.exports = { HouseMembersRouter };
