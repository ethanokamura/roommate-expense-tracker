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
    const { house_id, user_id, is_admin } = req.body;

    let nickname = "";
    if (req.user.name != null) {
      nickname = req.user.name;
    }

    try {
      // Insert new house member
      const result = await query(
        "INSERT INTO house_members (house_id, user_id, is_admin, nickname) VALUES ($1, $2, $3, $4) RETURNING *",
        [house_id, user_id, is_admin, nickname]
      );
      return res.status(201).json({ data: result.rows[0], success: true });
    } catch (error) {
      if (error.code === "23505") {
        return res.status(400).json({
          error: "User is already a member of this house.",
          success: false,
        });
      }
      if (error.code === "23503") {
        return res
          .status(400)
          .json({ error: "Invalid house_id or user_id.", success: false });
      }
      return next(error);
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
        "SELECT * FROM house_members WHERE house_member_id = $1",
        [house_member_id]
      );

      if (result.rows.length === 0) {
        return res.status(404).json({
          error: `House member with ID "${house_member_id}" not found`,
          success: false,
        });
      }

      return res.status(200).json({ data: result.rows[0], success: true });
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

  //select all instead of join, return all rows
  async findHouseMembers(req, res, next) {
    const filters = [];
    const values = [];
    let sql_query = "SELECT * FROM house_members";

    // Build dynamic query filters
    if (req.query.house_id) {
      values.push(req.query.house_id);
      filters.push(`house_id = $${values.length}`);
    }

    if (req.query.user_id) {
      values.push(req.query.user_id);
      filters.push(`user_id = $${values.length}`);
    }

    if (req.query.is_admin) {
      values.push(req.query.is_admin);
      filters.push(`is_admin = $${values.length}`);
    }
    if (filters.length > 0) {
      sql_query += " WHERE " + filters.join(" AND ");
    }

    const sort_by = req.query.sort_by || "created_at";
    const sort_order = req.query.sort_order || "desc";
    sql_query += ` ORDER BY ${sort_by} ${sort_order.toUpperCase()}`;

    try {
      const result = await query(sql_query, values);
      return res.status(200).json({ data: result.rows, success: true });
    } catch (error) {
      return next(error);
    }
  }

  /**
   * Handle GET /:house_id/user-info
   * @param {*} req - Express request object
   * @param {*} res - Express response object
   * @param {*} next - Express next function
   */
  async getHouseMembersUserInfo(req, res, next) {
    const { house_id } = req.params;
    const sort_by = req.query.sort_by || "created_at";
    const sort_order = req.query.sort_order || "desc";
    const queryString = `
      SELECT 
      users.*
      FROM house_members
      JOIN users ON house_members.user_id = users.user_id
      WHERE house_members.house_id = $1 
      AND house_members.is_active = TRUE
      ORDER BY house_members.${sort_by} ${sort_order};
    `;

    try {
      let result = await query(queryString, [house_id]);
      const data = result.rows;
      return res.status(200).json({
        success: true,
        data: data,
      });
    } catch (error) {
      return next(error);
    }
  }

  /**
   * Update a house member's details
   * @param {*} req - Express request object
   * @param {*} res - Express response object
   * @param {*} next - Express next function
   */
  async updateHouseMembers(req, res, next) {
    const house_member_id = req.params.id;

    // Build update query dynamically
    const updates = [];
    const values = [];

    if (req.body.hasOwnProperty("is_admin")) {
      values.push(req.body.is_admin);
      updates.push(`is_admin = $${values.length}`);
    }

    if (req.body.nickname) {
      values.push(req.body.nickname);
      updates.push(`nickname = $${values.length}`);
    }

    if (req.body.hasOwnProperty("is_active")) {
      values.push(req.body.is_active);
      updates.push(`is_active = $${values.length}`);
    }

    if (updates.length === 0) {
      return res.status(400).json({
        error: "No valid fields to update",
        success: false,
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

    try {
      const result = await query(sql_query, values);
      return res.status(200).json({ data: result.rows[0], success: true });
    } catch (error) {
      return next(error);
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
    try {
      // Delete the house member
      const result = await query(
        "DELETE FROM house_members WHERE house_member_id = $1 RETURNING *",
        [house_member_id]
      );
      return res.status(200).json({
        message: "House member removed successfully",
        data: result.rows[0],
        success: true,
      });
    } catch (error) {
      return next(error);
    }
  }
}

module.exports = {
  HouseMembersController,
};
