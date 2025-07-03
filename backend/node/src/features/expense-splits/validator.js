const { body, query, param } = require('express-validator');

const expenseSplitsValidators = {
    expenseSplitsId: [],
    expenseSplitsQuery: [],
    updateExpenseSplits: [],
    createExpenseSplits: []
}

module.exports = {
    expenseSplitsValidators
}