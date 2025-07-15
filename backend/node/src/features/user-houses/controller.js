const { query } = require("../../db/connection");

class UserHousesController {
  /**
   * Fetch user's houses
   * @param {*} req - Express request object
   * @param {*} res - Express response object
   * @param {*} next - Express next function
   */
  async getUserHouses(req, res, next) {
    const { userId } = req.params;
    const queryString = `
      SELECT
        h.house_id,
        h.name AS house_name,
        hm.house_member_id,
        hm.is_admin,
        hm.nickname AS member_nickname,
        h.created_at AS house_created_at,
        h.updated_at AS house_updated_at,
        hm.created_at AS member_created_at,
        hm.updated_at AS member_updated_at
      FROM users u
      JOIN house_members hm ON u.user_id = hm.user_id
      JOIN houses h ON hm.house_id = h.house_id
      WHERE u.user_id = $1 AND hm.is_active = TRUE
      ORDER BY hm.created_at DESC
    `;

    try {
      let result = await query(queryString, [userId]);

      const data = result.rows;
      console.log(`User's houses fetched successfully`);
      return res.status(200).json({
        success: true,
        data: data,
      });
    } catch (err) {
      console.error(`Error getting expense: ${err.message}`);
      return res.status(500).json({
        success: false,
        error: "Internal server error while creating expense",
        code: "INTERNAL_ERROR",
        details: err.message,
      });
    }
  }
}

module.exports = {
  UserHousesController,
};
