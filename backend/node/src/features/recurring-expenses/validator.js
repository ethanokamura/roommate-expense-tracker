const { body, query, param } = require('express-validator');

const recurringExpensesValidators = {
    recurringExpensesId: [],
    recurringExpensesQuery: [],
    updateRecurringExpenses: [],
    createRecurringExpenses: []
}

module.exports = {
    recurringExpensesValidators
}