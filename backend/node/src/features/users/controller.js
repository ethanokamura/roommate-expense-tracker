const { query } = require("../../db/connection");


class UserController {

	/**
	 * Create a new user
	 * @param {*} req - Express request object
	 * @param {*} res - Express response object
	 * @param {*} next - Express next function
	 */
	async createUser(req, res, next) {
		try {
			const { name, email, password } = req.body;
			const result = await query(
				`INSERT INTO users (name, email, password) VALUES (?, ?, ?)`,
				[name, email, password]
			);
			const newUser = { id: result.insertId, name, email };
			res.status(201).json({ message: "User created successfully", user: newUser });
		} catch (error) {
			if (error.code === 'ER_DUP_ENTRY') {
				res.status(409).json({ error: "Email already exists" });
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
			const userId = req.params.id;
			const results = await query(`SELECT id, name, email FROM users WHERE id = ?`, [userId]);
			if (results.length === 0) {
				return res.status(404).json({ error: "User not found" });
			}
			res.status(200).json(results[0]);
		} catch (error) {
			next(error);
		}
	}

	/**
	 * Handle GET /users with optional query filters
	 * @param {*} req - Express request object
	 * @param {*} res - Express response object
	 * @param {*} next - Express next function
	 */
	async findUsers(req, res, next) {
		try {
			const { name, email } = req.query;
			let sql = `SELECT id, name, email FROM users WHERE 1=1`;
			const params = [];
			if (name) {
				sql += ` AND name LIKE ?`;
				params.push(`%${name}%`);
			}
			if (email) {
				sql += ` AND email LIKE ?`;
				params.push(`%${email}%`);
			}
			const results = await query(sql, params);
			res.status(200).json(results);
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
			const userId = req.params.id;
			const { name, email, password } = req.body;
			const fields = [];
			const params = [];
			if (name) { fields.push("name = ?"); params.push(name); }
			if (email) { fields.push("email = ?"); params.push(email); }
			if (password) { fields.push("password = ?"); params.push(password); }
			if (fields.length === 0) {
				return res.status(400).json({ error: "No fields to update" });
			}
			params.push(userId);
			const sql = `UPDATE users SET ${fields.join(", ")} WHERE id = ?`;
			const result = await query(sql, params);
			if (result.affectedRows === 0) {
				return res.status(404).json({ error: "User not found" });
			}
			res.status(200).json({ message: "User updated successfully" });
		} catch (error) {
			if (error.code === 'ER_DUP_ENTRY') {
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
		try {
			const userId = req.params.id;
			const result = await query(`DELETE FROM users WHERE id = ?`, [userId]);
			if (result.affectedRows === 0) {
				return res.status(404).json({ error: "User not found" });
			}
			res.status(200).json({ message: "User deleted successfully" });
		} catch (error) {
			next(error);
		}
	}
}

module.exports = {
	UserController,
};