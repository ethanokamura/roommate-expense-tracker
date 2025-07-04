const express = require("express");
const HousesRouter = express.Router();
const { housesValidators } = require("./validator");
const { HousesController } = require("./controller");

const housesController = new HousesController();

// Create
HousesRouter.post(
	"/",
	housesValidators.createHouses,
	housesController.createHouses
);

// Read
HousesRouter.get(
	"/:id",
	housesValidators.housesId,
	housesController.getHouses
);

// Read
HousesRouter.get(
	"/",
	housesValidators.housesQuery,
	housesController.findHousess
);

// Update
HousesRouter.patch(
	"/:id",
	housesValidators.housesId,
	housesValidators.updateHouses,
	housesController.updateHouses
);

// Delete
HousesRouter.delete(
	"/:id",
	housesValidators.housesId,
	housesController.deleteHouses
);

module.exports = { HousesRouter };
