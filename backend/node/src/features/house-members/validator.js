const { body, query, param } = require('express-validator');

const houseMembersValidators = {
    houseMembersId: [],
    houseMembersQuery: [],
    updateHouseMembers: [],
    createHouseMembers: []
}

module.exports = {
    houseMembersValidators
}