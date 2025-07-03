# Packages Directory

The **packages** directory contains the backend and core functionality of the project. It is responsible for handling API calls, database interactions, reusable UI components, and essential app libraries.  

This directory ensures a clean separation of concerns by organizing the project's logic, data management, and utility functions separately from the UI, which is built using Cubits in the `lib` directory.

## Structure
```
packages/
  ├── api_client/         # Manages API interactions and network requests 
  ├── app_core/           # Core functionalities and foundational backend logic 
  ├── app_ui/             # Common UI components, theming, and constants 
  ├── winery_repository/  # Winery-related data management and API/database interactions 
  └── user_repository/    # User-related data management and API/database interactions
```

## Directory Breakdown

### `api_client/`
- Provides networking capabilities for the app.
- Contains API service classes and HTTP request handlers.

### `app_core/`
- The backbone of the project, managing core functionalities.
- May include dependency injection, configuration settings, and shared utilities.

### `app_ui/`
- Holds reusable UI elements, including:
  - **Themes & styles** – Defines the app’s color scheme and typography.
  - **Widgets** – Commonly used UI components.
  - **Constants** – Shared values such as spacing, dimensions, and assets.

### `winery_repository/`
- Manages winery-related data, including:
  - Fetching and storing winery details.
  - Handling winery-specific API calls and database interactions.

### `user_repository/`
- Manages user data, including:
  - Authentication and user profile management.
  - API calls and local database storage related to users.

---

This structure keeps the business logic modular, reusable, and scalable. By separating the data and backend logic from the UI, the project remains well-organized and easier to maintain. 🚀
