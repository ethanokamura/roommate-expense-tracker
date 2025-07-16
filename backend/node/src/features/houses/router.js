const express = require("express");
const HousesRouter = express.Router();
const { housesValidators } = require("./validator");
const { HousesController } = require("./controller");
const { validateRequest } = require("../../utils/validator");

const housesController = new HousesController();

// Create
HousesRouter.post(
  "/",
  housesValidators.createHouses,
  validateRequest,
  housesController.createHouses
);

// Read
HousesRouter.get(
  "/:id",
  housesValidators.housesId,
  validateRequest,
  housesController.getHouses
);

// Read
HousesRouter.get(
  "/",
  housesValidators.housesQuery,
  validateRequest,
  housesController.findHouses
);

// Update
HousesRouter.patch(
  "/:id",
  housesValidators.housesId,
  housesValidators.updateHouses,
  validateRequest,
  housesController.updateHouses
);

// Delete
HousesRouter.delete(
  "/:id",
  housesValidators.housesId,
  validateRequest,
  housesController.deleteHouses
);

module.exports = { HousesRouter };
