# Expenses Repository

This repository provides the core logic and data interactions for the **`Expenses`** domain within our application. It acts as an abstraction layer, handling all necessary communication with our backend services and the **Athena database** to manage `Expenses`-related data.

By centralizing `GET` methods and other data operations here, we ensure a consistent and robust approach to data retrieval and manipulation for `Expenses`.

---

## Key Responsibilities

* **Data Abstraction:** Isolates the frontend (via Cubits) from the complexities of direct API calls and database interactions.
* **Athena Database Interaction:** Leverages our custom **Athena SDK** to fetch and manage data related to `Expenses`.
* **Backend Communication:** Primarily handles `GET` requests to our NodeJS backend, ensuring efficient data retrieval.
* **Error Handling:** Defines specific **failures** for `Expenses` operations, allowing for robust error management in the frontend.

---

## Core Components

This package defines the following publicly accessible classes and their associated functionality:

- **Expenses**: Represents the data model for `Expenses`. This is your primary entity for this domain.
- **ExpenseSpits**: Represents the data model for `ExpenseSpits`. This is your primary entity for this domain.
- **RecurringExpenses**: Represents the data model for `RecurringExpenses`. This is your primary entity for this domain.
- **Receipts**: Represents the data model for `Receipts`. This is your primary entity for this domain.

These models are the building blocks for how `Expenses` data is structured and used throughout the application.

---

## Project Structure

```
expenses_repository/
	├── lib/
  │    ├── src/
  │    │    ├── models/                    # Data entities
  │    │    ├── expenses_repository.dart  # Main repository logic and interface
  │    │    └── failures.dart              # Custom failure definitions for this domain
  │    │
  │    └── expenses_repository.dart  # Exports the repository as a consumable library
  │
	├── analysis_options.yaml    # `very_good_analysis` config for linting rules
	├── devtools_options.yaml  # Dart tooling settings
	├── pubspec.yaml           # Package dependencies and metadata
	└── README.md              # This description of the repository
```

---

## Usage

To use this repository in the main Flutter application:

1.  Add it to the main `pubspec.yaml`:
    ```yaml
    dependencies:
        expenses_repository:
            path: packages/expenses_repository
    ```
2.  Run `flutter pub get`
3.  Inject the `ExpensesRepository()` into Cubits or other service layers.
4.  **Access methods** like `fetchExpenses()`, `fetchExpensesWithId(id)`, etc., to interact with `Expenses` data.

---