const express = require("express");
const HouseMembersRouter = express.Router();
const { houseMembersValidators } = require("./validator");
const { HouseMembersController } = require("./controller");
const { validateRequest } = require("../../utils/validator");

const houseMembersController = new HouseMembersController();

// Create
HouseMembersRouter.post(
  "/",
  houseMembersValidators.createHouseMembers,
  validateRequest,
  houseMembersController.createHouseMembers
);

// Read
HouseMembersRouter.get(
  "/:id",
  houseMembersValidators.houseMembersId,
  validateRequest,
  houseMembersController.getHouseMembers
);

// Read with filters
HouseMembersRouter.get(
  "/",
  houseMembersValidators.houseMembersQuery,
  validateRequest,
  houseMembersController.findHouseMembers
);

// Update
HouseMembersRouter.patch(
  "/:id",
  houseMembersValidators.houseMembersId,
  houseMembersValidators.updateHouseMembers,
  validateRequest,
  houseMembersController.updateHouseMembers
);

// Delete
HouseMembersRouter.delete(
  "/:id",
  houseMembersValidators.houseMembersId,
  validateRequest,
  houseMembersController.deleteHouseMembers
);

module.exports = { HouseMembersRouter };
