# Roommate Expense Tracker

Living with roommates often involves shared expenses such as rent, utilities, groceries, household items, and subscription services. Tracking these manually (via spreadsheets, text messages, or informal apps) often leads to confusion, forgotten payments, or disputes. There’s a clear opportunity to streamline this process with a dedicated, intuitive, real-time mobile app that simplifies expense sharing and increases transparency.

---

## Frontend

To run the client application, you must first install and set up Flutter. Note, that if you are on Mac, further installation is required via XCode. To ensure your setup has been completed, run the following command in your terminal: `flutter doctor -v`

If everything looks good, you are ready to run the application. To do so, `cd` into the frontend directory — under `<root>/frontend/roommate_expense_tracker` 

Once here, run the following command: `flutter run` 

It may prompt you to choose a device — it is at this point you can choose whatever device you prefer.

If you have a specific device you want to use, locate the device ID with `flutter devices` and then use `flutter run -d <device_id>`

---

## Backend

To run the express server, the set up is straight forward, ensure you have `docker` installed on your local machine and then navigate to the backend directory (`<root>/backend`)

Now,  simply run `docker compose up --build` to build and run the server. If you have already built the server and no new changes have been made, you may simply run `docker compose up`

Note — to see the new changes made in the server, you must kill the docker instance with `^C` and rebuild using `docker compose up --build`

---

## Database

For our database, we chose to use an instance of Postgres through neondb. Neon offers a serverless, highly scalable solution to hosting our database. It has a generous free tier that is perfect for the purpose of this application.

To set up the database connection, create a Neon account at neon.tech and create a new project. Copy your connection string and add it to your environment file at `backend/.env`:

```
DATABASE_URL=postgresql://username:password@hostname.neon.tech:5432/database_name
```

Once configured, run `docker compose exec node node src/db/setup.js` to create all database tables including users, houses, expenses, and related tables.

**Using the PostgreSQL Connection Pool:**
The backend uses a PostgreSQL connection pool configured in `backend/node/src/db/connection.js` that automatically manages database connections for optimal performance. To use the database in your controllers, import the query helper function with `const { query } = require('../../db/connection');`. Execute queries using `await query('SELECT * FROM users')` for basic queries or `await query('INSERT INTO users (email) VALUES ($1)', [email])` for parameterized queries. The pool handles connection management automatically, so you don't need to manually open or close connections.

For our database, we chose to use an instance of Postgres through neondb. Neon offers a serverless, highly scalable solution to hosting our database. It has a generous free tier that is perfect for the purpose of this application.

---

## Authentication

Authentication is handled using Google sign in and is linked via Google Firebase. This allows us to skip the headache of setting up our own custom authentication. It also leaves security vulnerabilities to Google (which will be much more secure than our solution).

Authentication — because it is handled via 0Auth — is handled via the frontend client. In the frontend, we then cache the user’s data (ie access tokens and personal information such as email). When we need to reach an API endpoint, we can forward the user’s access token via the authorization header within the HTTP request.