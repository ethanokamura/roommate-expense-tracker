const { query } = require("../../db/connection");
const { assertUserIsHouseHead } = require("../houses/utils/houseOwnership");

class HouseMembersController {
  /**
   * Add a new member to a house
   * @param {*} req - Express request object
   * @param {*} res - Express response object
   * @param {*} next - Express next function
   */
  async createHouseMembers(req, res, next) {
    const { house_id, user_id, role = 'member' } = req.body;
    const current_user_id = req.user.user_id;

    try {
      // Only house head can add members
      await assertUserIsHouseHead(house_id, current_user_id);

      // Check if user already exists in this house
      const existingMember = await query(
        "SELECT * FROM house_members WHERE house_id = $1 AND user_id = $2",
        [house_id, user_id]
      );

      if (existingMember.rows.length > 0) {
        return res.status(409).json({
          error: "User is already a member of this house"
        });
      }

      // Validate user exists
      const userExists = await query(
        "SELECT 1 FROM users WHERE user_id = $1",
        [user_id]
      );

      if (userExists.rows.length === 0) {
        return res.status(400).json({
          error: `User with user_id "${user_id}" not found`
        });
      }

      // Insert new house member
      const result = await query(
        "INSERT INTO house_members (house_id, user_id, role) VALUES ($1, $2, $3) RETURNING *",
        [house_id, user_id, role]
      );

      return res.status(201).json({ house_member: result.rows[0] });

    } catch (error) {
      if (error.code === "23503") {
        return res.status(400).json({
          error: "Invalid house_id or user_id provided"
        });
      }
      return res.status(error.status || 500).json({
        error: error.message || "Internal Server Error"
      });
    }
  }

  /**
   * Get a house member by their ID
   * @param {*} req - Express request object
   * @param {*} res - Express response object
   * @param {*} next - Express next function
   */
  async getHouseMembers(req, res, next) {
    const house_member_id = req.params.id;

    try {
      const result = await query(
        `SELECT hm.*, u.username, u.email, h.name as house_name 
         FROM house_members hm 
         JOIN users u ON hm.user_id = u.user_id 
         JOIN houses h ON hm.house_id = h.house_id 
         WHERE hm.house_member_id = $1`,
        [house_member_id]
      );

      if (result.rows.length === 0) {
        return res.status(404).json({
          error: `House member with ID "${house_member_id}" not found`
        });
      }

      return res.status(200).json({ house_member: result.rows[0] });

    } catch (error) {
      return next(error);
    }
  }

  /**
   * Handle GET /house-members with optional query filters
   * @param {*} req - Express request object
   * @param {*} res - Express response object
   * @param {*} next - Express next function
   */
  async findHouseMembers(req, res, next) {
    const filters = [];
    const values = [];
    let sql_query = `
      SELECT hm.*, u.username, u.email, h.name as house_name 
      FROM house_members hm 
      JOIN users u ON hm.user_id = u.user_id 
      JOIN houses h ON hm.house_id = h.house_id
    `;

    // Build dynamic query filters
    if (req.query.house_id) {
      values.push(req.query.house_id);
      filters.push(`hm.house_id = $${values.length}`);
    }

    if (req.query.user_id) {
      values.push(req.query.user_id);
      filters.push(`hm.user_id = $${values.length}`);
    }

    if (req.query.role) {
      values.push(req.query.role);
      filters.push(`hm.role = $${values.length}`);
    }

    try {
      if (filters.length > 0) {
        sql_query += " WHERE " + filters.join(" AND ");
      }

      const result = await query(sql_query, values);
      return res.status(200).json({ house_members: result.rows });

    } catch (error) {
      return next(error);
    }
  }

  /**
   * Update a house member's details (mainly role changes)
   * @param {*} req - Express request object
   * @param {*} res - Express response object
   * @param {*} next - Express next function
   */
  async updateHouseMembers(req, res, next) {
    const house_member_id = req.params.id;
    const current_user_id = req.user.user_id;

    try {
      // Get house member info to validate house ownership
      const memberInfo = await query(
        "SELECT house_id, user_id, role FROM house_members WHERE house_member_id = $1",
        [house_member_id]
      );

      if (memberInfo.rows.length === 0) {
        return res.status(404).json({
          error: `House member with ID "${house_member_id}" not found`
        });
      }

      const { house_id } = memberInfo.rows[0];

      // Only house head can update member roles
      await assertUserIsHouseHead(house_id, current_user_id);

      // Build update query dynamically
      const updates = [];
      const values = [];

      if (req.body.role) {
        values.push(req.body.role);
        updates.push(`role = $${values.length}`);
      }

      if (updates.length === 0) {
        return res.status(400).json({
          error: "No valid fields to update"
        });
      }

      // Add house_member_id to values
      values.push(house_member_id);
      const sql_query = `
        UPDATE house_members 
        SET ${updates.join(", ")}, updated_at = NOW() 
        WHERE house_member_id = $${values.length} 
        RETURNING *
      `;

      const result = await query(sql_query, values);
      return res.status(200).json({ house_member: result.rows[0] });

    } catch (error) {
      return res.status(error.status || 500).json({
        error: error.message || "Internal Server Error"
      });
    }
  }

  /**
   * Remove a member from a house
   * @param {*} req - Express request object
   * @param {*} res - Express response object
   * @param {*} next - Express next function
   */
  async deleteHouseMembers(req, res, next) {
    const house_member_id = req.params.id;
    const current_user_id = req.user.user_id;

    try {
      // Get house member info
      const memberInfo = await query(
        "SELECT house_id, user_id FROM house_members WHERE house_member_id = $1",
        [house_member_id]
      );

      if (memberInfo.rows.length === 0) {
        return res.status(404).json({
          error: `House member with ID "${house_member_id}" not found`
        });
      }

      const { house_id, user_id } = memberInfo.rows[0];

      // Either house head can remove anyone, or users can remove themselves
      const isHouseHead = await query(
        "SELECT user_id FROM houses WHERE house_id = $1",
        [house_id]
      );

      const canDelete = (
        isHouseHead.rows[0]?.user_id === current_user_id || // Is house head
        user_id === current_user_id // Is removing themselves
      );

      if (!canDelete) {
        return res.status(403).json({
          error: "Forbidden: You can only remove yourself or be the house head"
        });
      }

      // Check if this is the house head trying to leave
      if (user_id === isHouseHead.rows[0]?.user_id) {
        // Count remaining members
        const memberCount = await query(
          "SELECT COUNT(*) FROM house_members WHERE house_id = $1",
          [house_id]
        );

        if (parseInt(memberCount.rows[0].count) > 1) {
          return res.status(400).json({
            error: "House head cannot leave while other members remain. Transfer ownership first."
          });
        }
      }

      // Delete the house member
      const result = await query(
        "DELETE FROM house_members WHERE house_member_id = $1 RETURNING *",
        [house_member_id]
      );

      return res.status(200).json({
        message: "House member removed successfully"
      });

    } catch (error) {
      return res.status(error.status || 500).json({
        error: error.message || "Internal Server Error"
      });
    }
  }
}

module.exports = {
  HouseMembersController,
};