const { query } = require("../../../db/connection");

/**
 * Checks if a user is the head of a house
 * @param {string} house_Id - UUID of the house
 * @param {string} user_Id - UUID of the user
 * @returns {Promise<boolean>} - True if user is head of the house, else false
 */
async function isUserHeadOfHouse(house_Id, user_Id) {
  try {
    const result = await query(
      "SELECT user_id FROM houses WHERE house_id = $1",
      [house_Id]
    );

    if (result.rows.length === 0) {
      // No house found with the given house_id
      const error = new Error("House not found");
      error.status = 404;
      throw error;
    }

    return result.rows[0].user_id === user_Id;
  } catch (error) {
    throw error;
  }
}

async function assertUserIsHouseHead(house_id, user_id) {
  const isHead = await isUserHeadOfHouse(house_id, user_id);
  if (!isHead) {
    const error = new Error(
      "Forbidden: only head of house can perform this action"
    );
    error.status = 403;
    throw error;
  }
}

module.exports = { assertUserIsHouseHead };