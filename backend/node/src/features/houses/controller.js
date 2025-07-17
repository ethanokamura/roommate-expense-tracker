const { query } = require("../../db/connection");
const { assertUserIsHouseHead } = require("./utils/houseOwnership");

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
        "INSERT INTO houses (name, invite_code, user_id) VALUES ($1, $2, $3) RETURNING *",
        [name, invite_code, user_id]
      );
      return res.status(201).json({ data: result.rows[0], success: true });
    } catch (error) {
      return next(error);
    }
  }

  /**
   * Get a house by its ID
   * @param {*} req - Express request object
   * @param {*} res - Express response object
   * @param {*} next - Express next function
   * @returns {Promise<void>}
   */
  async getHouses(req, res, next) {
    const house_id = req.params.id;
    try {
      const result = await query("SELECT * FROM houses WHERE house_id = $1", [
        house_id,
      ]);
      if (result.rows.length === 0) {
        return res.status(404).json({
          error: `House with ID "${house_id}" not found`,
          success: false,
        });
      }
      return res.status(200).json({ data: result.rows[0], success: true });
    } catch (error) {
      return next(error);
    }
  }

  /**
   * Handle GET /houses with optional query filters
   * @param {*} req - Express request object
   * @param {*} res - Express response object
   * @param {*} next - Express next function
   */
  async findHouses(req, res, next) {
    const filters = [];
    const values = [];
    let sql_query = "SELECT * FROM houses";

    // dynamically build query text and values. empty queries are allowed
    if (req.query.name) {
      values.push(req.query.name);
      // returns houses with names that contain "name", case insensitive
      filters.push(`name = $${values.length}`);
    }
    if (req.query.invite_code) {
      values.push(req.query.invite_code);
      filters.push(`invite_code = $${values.length}`);
    }
    if (req.query.user_id) {
      values.push(req.query.user_id);
      filters.push(`user_id = $${values.length}`);
    }

    // if there are filters, add them to the query text
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
   * Update a house's details
   * @param {*} req - Express request object
   * @param {*} res - Express response object
   * @param {*} next - Express next function
   */
  async updateHouses(req, res, next) {
    const house_id = req.params.id;

    // check if current user is head of house
    const current_user_id = req.user.user_id;
    try {
      await assertUserIsHouseHead(house_id, current_user_id);
    } catch (error) {
      return res
        .status(error.status || 500)
        .json({ error: error.message || "Internal Server Error" });
    }

    try {
      let updateIsAdmin = false;
      // dynamically build query text and values, empty queries are not allowed
      const updates = [];
      const values = [];
      if (req.body.name) {
        values.push(req.body.name);
        updates.push(`name = $${values.length}`);
      }
      if (req.body.invite_code) {
        values.push(req.body.invite_code);
        updates.push(`invite_code = $${values.length}`);
      }

      // if switching head of house, ensure new user is in the house, and isnt current head
      const new_user_id = req.body.user_id;
      if (new_user_id && new_user_id != current_user_id) {
        const validHouseMemberResult = await query(
          "SELECT 1 FROM house_members WHERE user_id = $1 AND house_id = $2",
          [new_user_id, house_id]
        );
        if (validHouseMemberResult.rows.length === 0) {
          return res.status(400).json({
            error: `New user with id "${new_user_id}" not found in house.`,
            success: false,
          });
        }
        // add to query text and values
        values.push(new_user_id);
        updates.push(`user_id = $${values.length}`);

        updateIsAdmin = true;
      }

      // if nothing to update, return error
      if (updates.length === 0) {
        return res
          .status(400)
          .json({ error: "No valid fields to update", success: false });
      }

      // add house_id to values so we can update the specified house
      values.push(house_id);
      // build query text
      const sql_query = `UPDATE houses SET ${updates.join(
        ", "
      )}, updated_at = NOW() WHERE house_id = $${values.length} RETURNING *`;

      const result = await query(sql_query, values);

      // if no result found, return error
      if (result.rows.length === 0) {
        return res.status(404).json({
          error: `House with ID "${house_id}" not found`,
          success: false,
        });
      }

      if (updateIsAdmin) {
        await query(
          "UPDATE house_members SET is_admin = false WHERE house_id = $1 AND user_id = $2",
          [house_id, current_user_id]
        );
        await query(
          "UPDATE house_members SET is_admin = true WHERE house_id = $1 AND user_id = $2",
          [house_id, new_user_id]
        );
      }

      // else, house found with given parameters return it
      return res.status(200).json({ data: result.rows[0], success: true });
    } catch (error) {
      // invite code not unique
      if (error.code == "23505") {
        const invite_code = req.body.invite_code ?? "(unknown)";
        return res.status(409).json({
          error: `House with invite_code "${invite_code}" already exists`,
          success: false,
        });
      } else {
        return next(error);
      }
    }
  }

  /**
   * Deletes a house and removes it from the database
   * @param {*} req - Express request object
   * @param {*} res - Express response object
   * @param {*} next - Express next function
   */
  async deleteHouses(req, res, next) {
    const house_id = req.params.id;
    const user_id = req.user.user_id;

    try {
      // check if user is head of house
      await assertUserIsHouseHead(house_id, user_id);

      // delete house with house_id from database
      const result = await query(
        "DELETE FROM houses WHERE house_id = $1 RETURNING *",
        [house_id]
      );
      if (result.rows.length === 0) {
        return res
          .status(404)
          .json({ error: `House with ID "${house_id}" not found` });
      }
      return res
        .status(200)
        .json({ message: "House deleted successfully", success: true });
    } catch (error) {
      return res
        .status(error.status || 500)
        .json({ error: error.message || "Internal Server Error" });
    }
  }
}

module.exports = {
  HousesController,
};
