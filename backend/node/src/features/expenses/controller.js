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
      title,
      total_amount,
      expense_date,
      description,
      splits,
      category,
      is_settled = false,
    } = req.body;

    let queryString = `
      INSERT INTO expenses (house_id, house_member_id, total_amount, expense_date, description, category, is_settled, title, splits)
      VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
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
        title,
        splits,
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
  async findMyExpenses(req, res, next) {
    const queryData = req.query;

    const queryString = `
      SELECT *
      FROM
          expenses e,
          jsonb_array_elements(e.splits -> 'member_splits') AS split(value)
      WHERE
          split.value ->> 'member_id' = $1
      AND
          e.house_id = $2
      AND
          e.is_settled = false
    `;

    try {
      console.log(queryString);
      let result = await query(queryString, [
        queryData.house_member_id,
        queryData.house_id,
      ]);
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
   * Handle GET /expenses with optional query filters
   * @param {*} req - Express request object
   * @param {*} res - Express response object
   * @param {*} next - Express next function
   */
  async findMyTotalExpenses(req, res, next) {
    const queryData = req.query;

    const queryString = `
      SELECT
          SUM((split.value ->> 'amount_owed')::NUMERIC) AS total_amount_owed
      FROM
          expenses e,
          jsonb_array_elements(e.splits -> 'member_splits') AS split(value)
      WHERE
          split.value ->> 'member_id' = $1
      AND
          e.house_id = $2
      AND
          e.is_settled = false
    `;

    try {
      console.log(queryString);
      let result = await query(queryString, [
        queryData.house_member_id,
        queryData.house_id,
      ]);
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
   * Handle GET /expenses with optional query filters
   * @param {*} req - Express request object
   * @param {*} res - Express response object
   * @param {*} next - Express next function
   */
  async findExpenses(req, res, next) {
    const queryData = req.query;
    let queryString = `SELECT * FROM expenses `;
    const queryParams = [];

    // Add WHERE clauses for filtering
    const houseId = queryData.house_id;
    if (houseId) {
      queryString += ` WHERE house_id = $${queryParams.length + 1} `;
      queryParams.push(houseId);
    }

    // Add WHERE clauses for filtering
    const houseMemberId = queryData.house_member_id;
    if (houseMemberId) {
      queryString += ` ${
        queryParams.length > 0 ? "AND" : "WHERE"
      } house_member_id = $${queryParams.length + 1} `;
      queryParams.push(houseMemberId);
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

      orderBy = ` ORDER BY ${queryData.sort_by} `;

      let sortOrder = "";
      if (queryData.sort_order) {
        sortOrder = queryData.sort_order.toUpperCase();
      }

      orderBy += sortOrder == "ASC" || sortOrder == "DESC" ? sortOrder : "ASC";
    } else {
      orderBy = ` ORDER BY created_at DESC `;
    }
    queryString += orderBy;

    // Add LIMIT clause
    let limitValue = 25; // Default limit
    if (queryData.limit) {
      limitValue = parseInt(queryData.limit, 10);
      queryString += ` LIMIT $${queryParams.length + 1} `;
      queryParams.push(limitValue);
    } else {
      queryString += ` LIMIT ${limitValue} `;
    }

    try {
      console.log(queryString);
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
   * Handle GET /expenses/this-week with house_id
   * @param {*} req - Express request object
   * @param {*} res - Express response object
   * @param {*} next - Express next function
   */
  async getWeeklyExpenses(req, res, next) {
    const queryData = req.query;
    const queryString = `
      SELECT
          created_at::DATE AS day,
          SUM((split.value ->> 'amount_owed')::NUMERIC) AS total
      FROM
          expenses e,
          jsonb_array_elements(e.splits -> 'member_splits') AS split(value)
      WHERE
          split.value ->> 'member_id' = $1
      AND 
          e.house_id = $2
      AND 
          e.created_at >= (CURRENT_DATE - INTERVAL '6 day')
      AND 
          e.created_at < (CURRENT_DATE + INTERVAL '1 day')
      GROUP BY
          day
      ORDER BY
          day;
    `;

    try {
      let result = await query(queryString, [
        queryData.house_member_id,
        queryData.house_id,
      ]);
      const data = result.rows;
      console.log(`Week of expenses fetched successfully`);
      return res.status(201).json({
        success: true,
        data: data,
      });
    } catch (err) {
      console.error(`Error getting expense: ${err.message}`);
      return res.status(500).json({
        success: false,
        error: "Internal server error while fetching weekly expense",
        code: "INTERNAL_ERROR",
        details: err.message,
      });
    }
  }

  /**
   * Handle GET /expenses/categories with house_id
   * @param {*} req - Express request object
   * @param {*} res - Express response object
   * @param {*} next - Express next function
   */
  async getExpenseCategories(req, res, next) {
    const queryData = req.query;
    const queryString = `
      SELECT
          LOWER(category) AS category,
          SUM(total_amount) AS total
      FROM
          expenses e,
          jsonb_array_elements(e.splits -> 'member_splits') AS split(value)
      WHERE
          split.value ->> 'member_id' = $1
      AND 
          e.house_id = $2
      GROUP BY
          LOWER(e.category)
      ORDER BY
          LOWER(e.category); 
    `;

    try {
      let result = await query(queryString, [
        queryData.house_member_id,
        queryData.house_id,
      ]);
      const data = result.rows;
      console.log(`Week of expense categories fetched successfully`);
      return res.status(201).json({
        success: true,
        data: data,
      });
    } catch (err) {
      console.error(`Error getting expense: ${err.message}`);
      return res.status(500).json({
        success: false,
        error: "Internal server error while fetching expense categories",
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
      house_id,
      house_member_id,
      title,
      description,
      splits,
      total_amount,
      expense_date,
      category,
      is_settled,
      settled_at,
      updated_at,
    } = req.body;

    let fields = [];
    let queryParams = [];

    if (house_id) {
      fields.push(`house_id = $${fields.length + 1}`);
      queryParams.push(house_id);
    }
    if (house_member_id) {
      fields.push(`house_member_id = $${fields.length + 1}`);
      queryParams.push(house_member_id);
    }
    if (title) {
      fields.push(`title = $${fields.length + 1}`);
      queryParams.push(title);
    }
    if (description) {
      fields.push(`description = $${fields.length + 1}`);
      queryParams.push(description);
    }
    if (splits) {
      fields.push(`splits = $${fields.length + 1}`);
      queryParams.push(splits);
    }
    if (total_amount) {
      fields.push(`total_amount = $${fields.length + 1}`);
      queryParams.push(total_amount);
    }
    if (expense_date) {
      fields.push(`expense_date = $${fields.length + 1}`);
      queryParams.push(expense_date);
    }
    if (is_settled) {
      fields.push(`is_settled = $${fields.length + 1}`);
      queryParams.push(is_settled);
    }
    if (category) {
      fields.push(`category = $${fields.length + 1}`);
      queryParams.push(category);
    }
    if (settled_at) {
      fields.push(`settled_at = $${fields.length + 1}`);
      queryParams.push(settled_at);
    }
    if (updated_at) {
      fields.push(`updated_at = $${fields.length + 1}`);
      queryParams.push(updated_at);
    }

    const queryString = `
      UPDATE
        expenses
      SET 
        ${fields.join(", ")}
      WHERE 
        expense_id = $${queryParams.length + 1}
      RETURNING *
    `;
    queryParams.push(id);
    console.log(queryString);

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
