const { query } = require("../../db/connection");

class ExpensesController {
  /**
   * Create a new expense
   * @param {*} req - Express request object
   * @param {*} res - Express response object
   * @param {*} next - Express next function
   */
  async createExpenses(req, res, next) {
    const {
      house_id,
      house_member_id,
      total_amount,
      expense_date,
      description,
      category,
      is_settled = false,
    } = req.body;

    let queryString = `
      INSERT INTO expenses (house_id, house_member_id, total_amount, expense_date, description, category, is_settled)
      VALUES ($1, $2, $3, $4, $5, $6, $7)
      RETURNING *
    `;

    try {
      let result = await query(queryString, [
        house_id,
        house_member_id,
        total_amount,
        expense_date,
        description,
        category,
        is_settled,
      ]);

      const data = result.rows[0];
      console.log(`Expense created successfully`);
      return res.status(201).json({
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

  /**
   * Get a expense by its ID
   * @param {*} req - Express request object
   * @param {*} res - Express response object
   * @param {*} next - Express next function
   * @returns {Promise<void>}
   */
  async getExpenses(req, res, next) {
    const { id } = req.params;

    let queryString = `SELECT (*) FROM expenses WHERE expense_id = ($1)`;

    try {
      let result = await query(queryString, [id]);
      const data = result.rows[0];
      if (!data) {
        return res.status(404).json({
          success: false,
          error: "Expense not found",
          code: "EXPENSE_NOT_FOUND",
        });
      }

      console.log(`Expense fetched successfully`);
      return res.status(200).json({
        success: true,
        data: data,
      });
    } catch (err) {
      console.error(`Error getting expense: ${err.message}`);
      return res.status(500).json({
        success: false,
        error: "Internal server error while retrieving expense",
        code: "INTERNAL_ERROR",
        details: err.message,
      });
    }
  }

  /**
   * Handle GET /expenses with optional query filters
   * @param {*} req - Express request object
   * @param {*} res - Express response object
   * @param {*} next - Express next function
   */
  async findExpensess(req, res, next) {
    const queryData = req.query;
    let queryString = `SELECT * FROM expenses`;
    const queryParams = [];
    let paramIndex = 1;

    // Add WHERE clauses for filtering
    const houseId = queryData.house_id;
    if (houseId) {
      queryString += ` WHERE house_id = $${houseId}`;
      queryParams.push(houseId);
      paramIndex++;
    }

    // Add ORDER BY clause
    let orderBy = "";
    if (queryData.sort_by) {
      const validSortColumns = [
        "total_amount",
        "created_at",
        "updated_at",
        "settled_date",
        "expense_date",
      ];

      if (!validSortColumns.includes(queryData.sort_by)) {
        console.error("Error getting expense - invalid sort parameter");
        return res.status(400).json({
          success: false,
          error: "Invalid sort_by parameter",
          code: "INVALID_SORT_BY",
        });
      }

      orderBy = `ORDER BY ${sort_by}`;

      let sortOrder = "";
      if (queryData.sort_order) {
        sortOrder = queryData.sort_order.toUpperCase();
      }

      orderBy += sortOrder == "ASC" || sortOrder == "DESC" ? sortOrder : "ASC";
    } else {
      orderBy = ` ORDER BY created_at DESC`;
    }
    queryString += orderBy;

    // Add LIMIT clause
    let limitValue = 25; // Default limit
    if (queryData.limit) {
      limitValue = parseInt(queryData.limit, 10);
      queryString += ` LIMIT $${paramIndex}`;
      queryParams.push(limitValue);
      paramIndex++;
    } else {
      queryString += ` LIMIT ${limitValue}`;
    }

    try {
      let result = await query(queryString, queryParams);
      const data = result.rows;
      if (!data) {
        return res.status(404).json({
          success: false,
          error: "Expenses not found",
          code: "EXPENSES_NOT_FOUND",
        });
      }
      console.log(`🚀 Expenses found: ${data.length}`);
      return res.status(200).json({
        success: true,
        data: data,
      });
    } catch (err) {
      console.error(`Error getting expenses: ${err.message}`);
      return res.status(500).json({
        success: false,
        error: "Internal server error while retrieving expenses",
        code: "INTERNAL_ERROR",
        details: err.message,
      });
    }
  }

  /**
   * Update a expense's details
   * @param {*} req - Express request object
   * @param {*} res - Express response object
   * @param {*} next - Express next function
   */
  async updateExpenses(req, res, next) {
    const { id } = req.params;
    const {
      description,
      total_amount,
      category,
      is_settled,
      settled_at,
    } = req.body;

    let queryParams = [];
    let setString = '';
    let paramIndex = 1;

    if (description) {
      setString += `description = (${paramIndex})`
      queryParams.push(description);
      paramIndex++;
    }
    if (total_amount) {
      setString += `total_amount = (${paramIndex})`
      queryParams.push(total_amount);
      paramIndex++;
    }
    if (category) {
      setString += `category = (${paramIndex})`
      queryParams.push(category);
      paramIndex++;
    }
    if (is_settled) {
      setString += `is_settled = (${paramIndex})`
      queryParams.push(is_settled);
      paramIndex++;
    }
    if (settled_at) {
      setString += `settled_at = (${paramIndex})`
      queryParams.push(settled_at);
      paramIndex++;
    }

    queryParams.push(id);

    const queryString = `
      UPDATE expenses
      SET ${setString}
      WHERE expense_id = (${paramIndex})
      RETURNING *
    `;

    try {
      let result = await query(queryString, queryParams);
      const data = result.rows[0];
      if (!data) {
        return res.status(404).json({
          success: false,
          error: "Expense not found",
          code: "EXPENSE_NOT_FOUND",
        });
      }

      console.log(`Expense updated successfully`);
      return res.status(200).json({
        success: true,
        data: data,
      });
    } catch (err) {
      console.error(`Error getting expense: ${err.message}`);
      return res.status(500).json({
        success: false,
        error: "Internal server error while updating expense",
        code: "INTERNAL_ERROR",
        details: err.message,
      });
    }
  }

  /**
   * Deletes a expense and removes them from the database
   * @param {*} req - Express request object
   * @param {*} res - Express response object
   * @param {*} next - Express next function
   */
  async deleteExpenses(req, res, next) {
    const { id } = req.params;

    let queryString = `DELETE (*) FROM expenses WHERE expense_id = ($1)`;

    try {
      await query(queryString, [id]);

      console.log(`Expense deleted successfully`);
      return res.status(200).json({
        success: true,
        message: `Successfully deleted expense with id: (${id})`,
      });
    } catch (err) {
      console.error(`Error getting expense: ${err.message}`);
      return res.status(500).json({
        success: false,
        error: "Internal server error while deleting expense",
        code: "INTERNAL_ERROR",
        details: err.message,
      });
    }
  }
}

module.exports = {
  ExpensesController,
};
