const { body, query, param } = require('express-validator');

const expensesValidators = {
    expensesId: [],
    expensesQuery: [],
    updateExpenses: [],
    createExpenses: []
}

module.exports = {
    expensesValidators
}