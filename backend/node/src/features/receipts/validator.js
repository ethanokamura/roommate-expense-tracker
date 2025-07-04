const { body, query, param } = require('express-validator');

const receiptsValidators = {
    receiptsId: [],
    receiptsQuery: [],
    updateReceipts: [],
    createReceipts: []
}

module.exports = {
    receiptsValidators
}