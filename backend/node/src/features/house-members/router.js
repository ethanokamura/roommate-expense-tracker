const express = require("express");
const HouseMembersRouter = express.Router();
const { houseMembersValidators } = require("./validator");
const { HouseMembersController } = require("./controller");
const { validateRequest } = require("../../utils/validator");
const { validateUser } = require("../auth/middleware");

const houseMembersController = new HouseMembersController();

// Create
HouseMembersRouter.post(
  "/",
  houseMembersValidators.createHouseMembers,
  validateRequest,
  validateUser,
  houseMembersController.createHouseMembers
);

// Read
HouseMembersRouter.get(
  "/:id",
  houseMembersValidators.houseMembersId,
  validateRequest,
  validateUser,
  houseMembersController.getHouseMembers
);

// Read with filters
HouseMembersRouter.get(
  "/",
  houseMembersValidators.houseMembersQuery,
  validateRequest,
  validateUser,
  houseMembersController.findHouseMembers
);

// Update
HouseMembersRouter.patch(
  "/:id",
  houseMembersValidators.houseMembersId,
  houseMembersValidators.updateHouseMembers,
  validateRequest,
  validateUser,
  houseMembersController.updateHouseMembers
);

// Delete
HouseMembersRouter.delete(
  "/:id",
  houseMembersValidators.houseMembersId,
  validateRequest,
  validateUser,
  houseMembersController.deleteHouseMembers
);

module.exports = { HouseMembersRouter };