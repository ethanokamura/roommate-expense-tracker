const { query } = require("../../db/connection");

class UserController {
  //Check db and ? parameters, remove password

  /**
   * Create a new user
   * @param {*} req - Express request object
   * @param {*} res - Express response object
   * @param {*} next - Express next function
   */
  async createUser(req, res, next) {
    const { display_name, email } = req.body;
    //const user_id = req.body.user_id
    try {
      const result = await query(
        "INSERT INTO users (display_name, email) VALUES ($1, $2) RETURNING *",
        [display_name, email]
      );
      const user = result.rows[0];
      return res.status(201).json({ success: true, data: user });
    } catch (error) {
      if (error.code === "ER_DUP_ENTRY") {
        res.status(409).json({
          success: false,
          error: "Email already exists",
          code: "EMAIL_EXISTS",
        });
      } else {
        next(error);
      }
    }
  }

  /**
   * Get a user by its ID
   * @param {*} req - Express request object
   * @param {*} res - Express response object
   * @param {*} next - Express next function
   * @returns {Promise<void>}
   */
  async getUser(req, res, next) {
    try {
      const { user_id } = req.params;
      const result = await query("SELECT * FROM users WHERE user_id = $1", [
        user_id,
      ]);
      if (result.length === 0) {
        return res.status(404).json({
          success: false,
          error: "User not found",
          code: "USER_NOT_FOUND",
        });
      }
      console.log(`User fetched successfully`);
      res.status(200).json({ success: true, data: result.rows[0] });
    } catch (error) {
      return res.status(500).json({ error: "Internal server error" });
    }
  }

  /**
   * Handle GET /users with optional query filters
   * @param {*} req - Express request object
   * @param {*} res - Express response object
   * @param {*} next - Express next faunction
   */
  async findUsers(req, res, next) {
    try {
      const { display_name, email } = req.query;
      let sql = "SELECT * FROM users";
      const params = [];
      console.log(`querying user with email ${email}`);
      if (display_name) {
        sql += ` WHERE display_name = ($${params.length + 1})`;
        params.push(display_name);
      }
      if (email) {
        let prefix = params.length == 1 ? "AND" : "WHERE";
        sql += ` ${prefix} email = ($${params.length + 1})`;
        params.push(email);
      }
      const results = await query(sql, params);
      res.status(200).json({
        success: true,
        data: results.rows,
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * Update a user's details
   * @param {*} req - Express request object
   * @param {*} res - Express response object
   * @param {*} next - Express next function
   */
  async updateUser(req, res, next) {
    try {
      const { user_id } = req.params;
      const { display_name, email } = req.body;
      const fields = [];
      const params = [];
      if (display_name) {
        fields.push(`display_name = ($${fields.length + 1})`);
        params.push(display_name);
      }
      if (email) {
        fields.push(`email = ($${fields.length + 1})`);
        params.push(email);
      }
      if (fields.length === 0) {
        return res.status(400).json({ error: "No fields to update" });
      }
      params.push(user_id);

      const sql = `UPDATE users SET ${fields.join(
        ", "
      )} WHERE user_id = $1 RETURNING *`;
      const result = await query(sql, params);
      if (result.affectedRows === 0) {
        return res.status(404).json({ error: "User not found" });
      }
      res.status(200).json({
        success: true,
        data: result.rows[0],
      });
    } catch (error) {
      if (error.code === "ER_DUP_ENTRY") {
        res.status(409).json({ error: "Email already exists" });
      } else {
        next(error);
      }
    }
  }

  /**
   * Deletes a user and removes them from the database
   * @param {*} req - Express request object
   * @param {*} res - Express response object
   * @param {*} next - Express next function
   */
  async deleteUser(req, res, next) {
    const user_id = req.params.id;
    try {
      const result = await query("DELETE (*) FROM users WHERE user_id = ($1)", [
        user_id,
      ]);
      console.log(`User deleted successfully`);
      res
        .status(200)
        .json({
          success: true,
          message: "User deleted successfully with id: (${user_id})",
        });

      if (result.rowCount === 0) {
        return res.status(404).json({ error: "User not found" });
      }
    } catch (error) {
      console.error(`Error getting user: ${error.message}`);
      return res.status(500).json({
        error: "Internal server error while deleting user",
        code: "INTERNAL_ERROR",
      });
    }
  }
}

module.exports = {
  UserController,
};
