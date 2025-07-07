const express = require("express");
const HousesRouter = express.Router();
const { housesValidators } = require("./validator");
const { HousesController } = require("./controller");
const { validationRequest } = require("./validator");

const housesController = new HousesController();

// check if user and user_id exists
const checkAuth = (req, res, next) => {
  if (!req.user || !req.user.user_id) {
    return res.status(401).json({ error: "Unauthorized" });
  }
  next();
};

// Create
HousesRouter.post(
  "/",
  checkAuth,
  housesValidators.createHouses,
  validateRequest,
  housesController.createHouses
);

// Read
HousesRouter.get("/:id", housesValidators.housesId, housesController.getHouses);

// Read
HousesRouter.get(
  "/",
  housesValidators.housesQuery,
  housesController.findHouses
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
