const { query } = require("../../db/connection");

class HousesController {
  /**
   * Create a new house
   * @param {*} req - Express request object
   * @param {*} res - Express response object
   * @param {*} next - Express next function
   */
  async createHouses(req, res, next) {
    const { name, invite_code } = req.body;
    const user_id = req.user.user_id;
    try {
      const result = await query(
        "INSERT INTO houses (name, invite_code, user_id) VALUES ($1, $2, $3)",
        [name, invite_code, user_id]
      );
      return res.status(201).json({ house: result.rows[0] });
    } catch (error) {
      // invite_code not unique
      if (error.code == "23505") {
        return res.status(409).json({
          error: `House with invite_code: ${invite_code} already exists`,
        });
      } else {
        next(error);
      }
    }
  }

  /**
   * Get a house by its ID
   * @param {*} req - Express request object
   * @param {*} res - Express response object
   * @param {*} next - Express next function
   * @returns {Promise<void>}
   */
  async getHouses(req, res, next) {}

  /**
   * Handle GET /houses with optional query filters
   * @param {*} req - Express request object
   * @param {*} res - Express response object
   * @param {*} next - Express next function
   */
  async findHouses(req, res, next) {}

  /**
   * Update a house's details
   * @param {*} req - Express request object
   * @param {*} res - Express response object
   * @param {*} next - Express next function
   */
  async updateHouses(req, res, next) {}

  /**
   * Deletes a house and removes it from the database
   * @param {*} req - Express request object
   * @param {*} res - Express response object
   * @param {*} next - Express next function
   */
  async deleteHouses(req, res, next) {}
}

module.exports = {
  HousesController,
};
