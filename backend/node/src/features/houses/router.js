const express = require("express");
const HousesRouter = express.Router();
const { housesValidators } = require("./validator");
const { HousesController } = require("./controller");
const { validateRequest } = require("../../utils/validator");
const { validateUser } = require("../auth/middleware");

const housesController = new HousesController();

// Create
HousesRouter.post(
  "/",
  housesValidators.createHouses,
  validateRequest,
  validateUser,
  housesController.createHouses
);

// Read
HousesRouter.get(
  "/:id",
  housesValidators.housesId,
  validateRequest,
  validateUser,
  housesController.getHouses
);

// Read
HousesRouter.get(
  "/",
  housesValidators.housesQuery,
  validateRequest,
  validateUser,
  housesController.findHouses
);

// Update
HousesRouter.patch(
  "/:id",
  housesValidators.housesId,
  housesValidators.updateHouses,
  validateRequest,
  validateUser,
  housesController.updateHouses
);

// Delete
HousesRouter.delete(
  "/:id",
  housesValidators.housesId,
  validateRequest,
  validateUser,
  housesController.deleteHouses
);

module.exports = { HousesRouter };
