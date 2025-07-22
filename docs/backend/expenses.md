# Expenses 
This document will cover the basics of our expenses logic within the ExpressJS server as well as describe the related modules and subdirectories.

---

## General Idea:

Expenses are the core feature within this application. With RET, you can have all the data you need - in one place. The REST API created within our Express server allows the client-side application to connect to and interact with our database. Our backend supports simple CRUD methods using stateless HTTP requests.

---

## Architecture:

Within the expenses sub-directory, the following files can be found:

```bash
expenses/
├── controller.js  # Handles the main logic for the endpoint
├── router.js      # Handles the routes (API endpoints)
└── validator.js   # Validates the HTTP payload and headers
```

Each feature contains the following routes:

```bash
POST expense/
PATCH expense/:id
GET expense/
GET expense/:id
DELETE expense/:id
```

---

## Router:

The router is the base for implementing the logic required for the `/expenses` API endpoints.

In the router we create a sequence of methods that must be executed to validate the request and return a response. The steps are as follows:

1. Validate the incoming request using the `expensesValidators` defined within the `validator.js` file. This covers basic input validation which ensures the request contains the expected values with the correct data types.
2. Execute a generic helper method to ensure proper handling of the validation output.
3. Execute a generic helper method to ensure the requesting user has proper authentication.
4. Execute the desired function (Create / Read / Update / Delete) using the `expenseController` defined within `controller.js` - more on this below.

After completing these steps, the router will handle the incoming `request` and send the appropriate `response`.

---

## Controller:

The `expenseController` class defines all the necessary logic to handle the CRUD operations for `expenses` in our database. Each function takes in a request (`req`) and sends back a response (`res`). In the case of a failure, `next` is executed.

### Creating an Expense:

To create an expense, the following body is required within the request:

```jsx
const {
  house_id,
  house_member_id,
  total_amount,
  expense_date,
  description,
  category,
  is_settled = false,
} = req.body;
```

We then execute SQL to insert this data into the `expenses` table:

```sql
INSERT INTO expenses (house_id, house_member_id, total_amount, expense_date, description, category, is_settled)
VALUES ($1, $2, $3, $4, $5, $6, $7)
RETURNING *
```

Note, using the keyword `RETURNING` allows us to return the newly created expense back to the client.

After the query is ran, the result is store in the variable named `result`. If successful, we extract the first row of the result - `result.rows[0]` - and send it back within the body of `res`.

If the query fails, we throw an error and send the `error`, `code`, and `details` back to the client.

Possible Responses:

| Response Status Code | Successful | Code |
| --- | --- | --- |
| `201` | `true` | `SUCCESS` |
| `500` | `false` | `INTERNAL_ERROR` |

### Fetching a Single Expense:

To fetch an expense, the endpoint requires query `params`:

```jsx
const { id } = req.params;
```

We then execute SQL to find the desired row from the `expenses` table using the provided `id`:

```sql
SELECT (*) FROM expenses WHERE expense_id = ($1)
```

After the query is ran, the result is store in the variable named `result`. If successful, we extract the first row of the result - `result.rows[0]` - and send it back within the body of `res`.

If the query fails, we throw an error and send the `error`, `code`, and `details` back to the client.

Possible Responses:

| Response Status Code | Successful | Code |
| --- | --- | --- |
| `201` | `true` | `SUCCESS` |
| `404` | `false` | `EXPENSE_NOT_FOUND` |
| `500` | `false` | `INTERNAL_ERROR` |

### Querying Expenses:

To query the expenses table, the endpoint requires a list of query `params`:

```jsx
const queryData = req.query;
```

The logic here is much more complex due to the required flexibility with querying the table. However, this allows for a much better developer experience in the long run.

The following steps are required to build the correct SQL query:

1. Add `WHERE` clauses for filtering
2. Add `ORDER BY` clause
3. Add `LIMIT` clause

Once these are compiled, the SQL query string is built and executed.

After the query is ran, the result is store in the variable named `result`. If successful, we return ALL the resulting rows within the body of `res`.

If the query fails, we throw an error and send the `error`, `code`, and `details` back to the client.

Possible Responses:

| Response Status Code | Successful | Code |
| --- | --- | --- |
| `201` | `true` | `SUCCESS` |
| `404` | `false` | `EXPENSES_NOT_FOUND` |
| `500` | `false` | `INTERNAL_ERROR` |

### Updating an Expense:

To update an expense, the endpoint requires the `expense_id` within the query `params` AND the newly updated data points in the request `body`:

```jsx
// Expense ID
const { id } = req.params;

// Updated fields
const {
  description,
  total_amount,
  category,
  is_settled,
  settled_at,
} = req.body;
```

We then execute this SQL to update the desired row from the `expenses` table using the provided `id`:

```sql
UPDATE expenses
SET ${setString}
WHERE expense_id = (${paramIndex})
RETURNING *
```

Where `setString` is an array of all the updated fields.

Note that we are again using the keyword `RETURNING` to retrieve the newly updated row in our database.

After the query is ran, the result is store in the variable named `result`. If successful, we extract the first row of the result - `result.rows[0]` - and send it back within the body of `res`.

If the query fails, we throw an error and send the `error`, `code`, and `details` back to the client.

Possible Responses:

| Response Status Code | Successful | Code |
| --- | --- | --- |
| `201` | `true` | `SUCCESS` |
| `404` | `false` | `EXPENSE_NOT_FOUND` |
| `500` | `false` | `INTERNAL_ERROR` |

### Deleting an Expense:

To delete an expense, the endpoint requires the `expense_id` within the query `params`:

```jsx
const { id } = req.params;
```

We then execute SQL to delete the desired row from the `expenses` table using the provided `id`:

```sql
DELETE (*) FROM expenses WHERE expense_id = ($1)
```

After the query is ran, the result is store in the variable named `result`. If successful, we simply send the client a success message within the body of `res`.

```jsx
// Response Body
message: `Successfully deleted expense with id: (${id})`,
```

If the query fails, we throw an error and send the `error`, `code`, and `details` back to the client.

Possible Responses:

| Response Status Code | Successful | Code |
| --- | --- | --- |
| `201` | `true` | `SUCCESS` |
| `404` | `false` | `EXPENSE_NOT_FOUND` |
| `500` | `false` | `INTERNAL_ERROR` |

---

## Testing:

At this point (July 10th, 2025) the endpoints have not been tested.