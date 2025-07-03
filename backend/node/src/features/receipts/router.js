const express = require("express");
const ReceiptsRouter = express.Router();
const { receiptsValidators } = require("./validator");
const { ReceiptsController } = require("./controller");

const receiptsController = new ReceiptsController();

// Create
ReceiptsRouter.post(
	"/",
	receiptsValidators.createReceipts,
	receiptsController.createReceipts
);

// Read
ReceiptsRouter.get(
	"/:id",
	receiptsValidators.receiptsId,
	receiptsController.getReceipts
);

// Read
ReceiptsRouter.get(
	"/",
	receiptsValidators.receiptsQuery,
	receiptsController.findReceiptss
);

// Update
ReceiptsRouter.patch(
	"/:id",
	receiptsValidators.receiptsId,
	receiptsValidators.updateReceipts,
	receiptsController.updateReceipts
);

// Delete
ReceiptsRouter.delete(
	"/:id",
	receiptsValidators.receiptsId,
	receiptsController.deleteReceipts
);

module.exports = { ReceiptsRouter };
