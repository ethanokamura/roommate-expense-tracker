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
    SELECT
        e.expense_id,
        e.house_id,
        e.house_member_id,
        e.title,
        e.description,
        e.splits,
        e.total_amount,
        e.expense_date,
        e.category,
        e.is_settled,
        e.settled_at,
        e.created_at,
        e.updated_at
    FROM
        expenses e,
        jsonb_array_elements(e.splits -> 'member_splits') AS split(value)
    WHERE
        e.house_id = $1
    AND
        split.value ->> 'member_id' = $2
    AND
        e.is_settled = false

    `;

    try {
      console.log(queryString);
      let result = await query(queryString, [
        queryData.house_id,
        queryData.house_member_id,
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
    const { key, value } = req.query;
    const queryString = `
      SELECT
          created_at::DATE AS day,
          SUM(total_amount) AS total
      FROM
          expenses
      WHERE
          ${key} = $1
          AND created_at >= (CURRENT_DATE - INTERVAL '6 day')
          AND created_at < (CURRENT_DATE + INTERVAL '1 day')
      GROUP BY
          day
      ORDER BY
          day;
    `;

    try {
      console.log(`fetching weekly expenses given ${key} and ${value}`);
      let result = await query(queryString, [value]);
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
    const { key, value } = req.query;
    const queryString = `
      SELECT
          LOWER(category) AS category,
          SUM(total_amount) AS total
      FROM
          expenses
      WHERE
          ${key} = $1
      GROUP BY
          LOWER(category)
      ORDER BY
          LOWER(category); 
    `;

    try {
      console.log(
        `fetching weekly expense categories given ${key} and ${value}`
      );
      let result = await query(queryString, [value]);
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
    const { description, total_amount, category, is_settled, settled_at } =
      req.body;

    let queryParams = [];
    let setString = "";

    if (description) {
      setString += `description = $${queryParams.length + 1}`;
      queryParams.push(description);
    }
    if (total_amount) {
      setString += `total_amount = $${queryParams.length + 1}`;
      queryParams.push(total_amount);
    }
    if (category) {
      setString += `category = $${queryParams.length + 1}`;
      queryParams.push(category);
    }
    if (is_settled) {
      setString += `is_settled = $${queryParams.length + 1}`;
      queryParams.push(is_settled);
    }
    if (settled_at) {
      setString += `settled_at = $${queryParams.length + 1}`;
      queryParams.push(settled_at);
    }

    queryParams.push(id);

    const queryString = `
      UPDATE expenses
      SET ${setString}
      WHERE expense_id = $${queryParams.length + 1}
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
