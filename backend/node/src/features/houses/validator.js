const { body, query, param } = require('express-validator');

const housesValidators = {
    housesId: [],
    housesQuery: [],
    updateHouses: [],
    createHouses: []
}

module.exports = {
    housesValidators
}