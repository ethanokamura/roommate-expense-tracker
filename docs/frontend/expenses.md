# Expenses
This document will cover the basics of our expenses logic as well as describe the related modules and subdirectories.

---

## General Idea:

Expenses are the core feature within this application. With RET, you can have all the data you need - in one place. The expense dashboard allows a user to view all the necessary information and analysis they need in order to optimize their financial decisions. The expenses allow users to track their history of house-related expenses between themselves and other members of the house.

---

## Architecture:

Just like other features within the app, the expense related pages consist of multiple modules:

1. The UI components
2. A cubit for state management
3. A repository that makes requests to the REST API’s

When a user navigates to the expense dashboard, the cubit is provided to the widget tree and immediately notifies the repository. Within the repository, we check the existing cache for previously fetched `Expenses` - if none are provided or the cache is out of date, we send an HTTP request to the backend. Regardless of how the expense is obtained, we map the JSON response to our custom `Expenses` object.

---

## Expense Data:

Raw JSON:

```json
{
  "expense_id": "o4tto4n3-3q4p-hr5q-l1s2-2o3n4p5q6r7s",
  "house_id": "e4ifg4d3-3g4f-7i5g-b1i2-2e3d4f5g6h7i",
  "house_member_id": "j9nlj9i8-8l9k-cm0l-g6n7-7j8i9k0l1m2n",
  "title": "Dinner Out",
  "description": "Pizza and drinks",
  "splits": {
    "member_splits": [
      {
        "member_id": "h7ljh7g6-6j7i-ak8j-e4l5-5h6g7i8j9k0l",
        "amount_owed": 15.0,
        "paid_on": "2025-07-05T15:00:00Z"
      },
      {
        "member_id": "j9nlj9i8-8l9k-cm0l-g6n7-7j8i9k0l1m2n",
        "amount_owed": 15.0,
        "paid_on": "2025-07-08T15:00:00Z"
      }
    ]
  },
  "total_amount": 30.0,
  "expense_date": "2025-07-08",
  "category": "food",
  "is_settled": true,
  "settled_at": "2025-07-08T15:00:00Z",
  "created_at": "2025-07-05T19:12:06Z",
  "updated_at": "2025-07-08T19:12:06Z"
}
```

Dart Object:

```dart
/// Object mapping for [Expenses]
/// Defines helper functions to help with bidirectional mapping
class Expenses extends Equatable {
  /// Constructor for [Expenses]
  /// Requires default values for non-nullable data
  const Expenses({
    this.expenseId, // PK
    this.houseId, // FK
    this.houseMemberId, // FK
    this.title = '',
    this.description = '',
    this.splits = const {},
    this.totalAmount = 0.0,
    this.expenseDate,
    this.category = '',
    this.isSettled = false,
    this.settledAt,
    this.createdAt,
    this.updatedAt,
  });

  // Data for Expenses
  final String? expenseId; // PK
  final String? houseId; // FK
  final String? houseMemberId; // FK
  final String title;
  final String description;
  final Map<String, dynamic> splits;
  final double totalAmount;
  final DateTime? expenseDate;
  final String category;
  final bool isSettled;
  final DateTime? settledAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}
```

Note that the object is broken down further to define expense splits:

```dart
class ExpenseSplit {
  const ExpenseSplit({
    this.memberId = '',
    this.amountOwed = 0.0,
    this.paidOn,
  });

  final String memberId;
  final double amountOwed;
  final DateTime? paidOn;
}
```

---

## API Interaction:

This section covers all the CRUD operations required for expenses.

```dart
/// Repository class for managing [Expenses] methods and data
class ExpensesRepository {
  /// Constructor for ExpensesRepository.
  ExpensesRepository({
    CacheManager? cacheManager,
  }) : _cacheManager = cacheManager ?? GetIt.instance<CacheManager>();

  final CacheManager _cacheManager;
	Future<Expenses> createExpenses();
	Future<List<Expenses>> fetchAllExpenses();
	Future<Expenses> fetchExpensesWithExpenseId();
	Future<List<Expenses>> fetchAllExpensesWithHouseMemberId();
	Future<List<Expenses>> fetchAllExpensesWithHouseId();
	Future<Expenses> updateExpenses();
	Future<String> deleteExpenses();
}
```

### Creating Expenses:

To create an expense, we call the `createExpenses()` method within the `ExpenseRepository`.

This function will first check our local cache, and then send a request to the backend (if it is not found, the cache is stale, or the `forceRefresh` flag is raised). The method - if applicable - will execute the HTTP request.

Code Snippet:

```dart
Future<Expenses> createExpenses({
  required Map<String, dynamic> data,
  required String token,
  bool forceRefresh = true,
}) async {
	// Check cache

	// POST /expenses
	final response = await dioRequest(
	  dio: _dio,
	  apiEndpoint: '/expenses',
	  method: 'POST',
	  headers: {
		  'Content-Type': 'application/json; charset=UTF-8',
		  'Authorization': 'Bearer $token'
	  }
    payload: data,
	);
	
	// Return mapped Expenses object
}
```

### Reading / Fetching Expenses:

There are many ways to fetch expenses - we can fetch an individual expense or a list of all expenses for a given user / house.

The most frequently used methods and `fetchExpensesWithExpenseId()` and `fetchAllExpensesWithHouseId()`.

These functions will first check our local cache, and then send a request to the backend (if it is not found, the cache is stale, or the `forceRefresh` flag is raised). The method - if applicable - will execute the HTTP request.

Code Snippet:

```dart
Future<Expenses> fetchExpensesWithExpenseId({
  required String expenseId,
  required String token,
  bool forceRefresh = false,
  bool useTestData = true,
}) async {
	// Check cache

	// GET /expenses:id
  // Retrieve new row after inserting
  final response = await dioRequest(
    dio: Dio(),
    apiEndpoint: '/expenses/$expenseId',
    method: 'GET',
    headers: {
		  'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
	  }
	);
	
	// Return mapped Expenses object
}
```

Code Snippet:

```dart
Future<List<Expenses>> fetchAllExpensesWithHouseId({
  required String houseId,
  required String token,
  required String orderBy,
  required bool ascending,
  bool forceRefresh = false,
  bool useTestData = true,
}) async {
	// Check cache

	// GET /expenses
	final response = await dioRequest(
	  dio: _dio,
    apiEndpoint: '/expenses?house_id=$houseId&sort_by=$orderBy&sort_order=$ascendingQuery',
    method: 'GET',
	  headers: {
		  'Content-Type': 'application/json; charset=UTF-8',
		  'Authorization': 'Bearer $token'
	  }
    payload: data,
	);
	
	// Return mapped List<Expenses> object
}
```

### Updating Expsense:

To update an expense, we call the `updateExpense()` method.

In this function we pass through a new `Expenses` object containing the updated fields. This method does not check the cache, because we do not need to fetch the existing data - merely update it. However, upon a successful upload, the resulting updated object will be cached.

Code Snippet:

```dart
Future<Expenses> updateExpenses({
  required String expenseId,
  required Expenses newExpensesData,
  required String token,
}) {
  final data = newExpensesData.toJson();

	// PATCH /expenses
  final response = await dioRequest(
    dio: Dio(),
    apiEndpoint: '/expenses/$expenseId',
    method: 'PATCH',
    headers: {
		  'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
    payload: data,
  );

	// Return mapped Expense object
}
```

### Deleting Expenses:

To delete an expense, we call the `deleteExpenses()` method.

In this function we pass through the `expenseId` of the expense we wish to delete. Upon a successful deletion, a success message is returned in the response body. This is useful for logging, but unnecessary for the frontend UI.

Code Snippet:

```dart
Future<String> deleteExpenses({
  required String expenseId,
  required String token,
}) {
	// Check cache

	// DELETE /expenses
  final response = await dioRequest(
    dio: Dio(),
    apiEndpoint: '/expenses/$expenseId',
    method: 'DELETE',
    headers: {
		  'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
  );

	// Return deletion message
}
```