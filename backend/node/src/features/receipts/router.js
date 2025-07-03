const express = require("express");
const ReceiptsRouter = express.Router();
const { ReceiptsValidators } = require("./validators");
const { ReceiptsController } = require("./controller");

const ReceiptsController = new ReceiptsController();

// Create
ReceiptsRouter.post(
	"/",
	ReceiptsValidators.createReceipts,
	ReceiptsController.createReceipts
);

// Read
ReceiptsRouter.get(
	"/:id",
	ReceiptsValidators.ReceiptsId,
	ReceiptsController.getReceipts
);

// Read
ReceiptsRouter.get(
	"/",
	ReceiptsValidators.ReceiptsQuery,
	ReceiptsController.findReceiptss
);

// Update
ReceiptsRouter.patch(
	"/:id",
	ReceiptsValidators.ReceiptsId,
	ReceiptsValidators.updateReceipts,
	ReceiptsController.updateReceipts
);

// Delete
ReceiptsRouter.delete(
	"/:id",
	ReceiptsValidators.ReceiptsId,
	ReceiptsController.deleteReceipts
);

module.exports = { ReceiptsRouter };
